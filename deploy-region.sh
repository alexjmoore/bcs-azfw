#!/bin/bash
usage() { echo "Usage: $0 -n <string app name> -l <string azure regon>" 1>&2; exit 1; }
strip() { printf %"$(tput cols)"s |tr " " "="; }

while getopts n:l: option
do
    case "${option}"
    in
        n) NAME=${OPTARG};;
        l) LOCATION=${OPTARG};;
        *) usage;;
    esac
done

if [ -z "$NAME" ] || [ -z "$LOCATION" ]; then
    usage
fi

STORAGE=`echo $NAME | tr -cd "[:alnum:]" | tr "[:upper:]" "[:lower:]"`$RANDOM
echo Deploying: $NAME
echo To region: $LOCATION
echo Stor Acct: $STORAGE

strip
### Resource Group ###
echo creating group...
az group create -l $LOCATION -n $NAME 

### Networking ###
strip
echo NETWORK
strip
echo creating vnet...
az network vnet create -n $NAME-VNet -g $NAME \
  --address-prefixes 10.1.0.0/16 \
  --subnet-name App --subnet-prefixes 10.1.2.0/24

echo creating route table...
az network route-table create -g $NAME -n $NAME-RT

echo creating route entry...
az network route-table route create -g $NAME -n $NAME-FWROUTE \
  --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance \
  --route-table-name $NAME-RT --next-hop-ip-address 10.1.1.4

echo creating firewall subnet...
az network vnet subnet create -g $NAME -n AzureFirewallSubnet \
  --vnet-name $NAME-VNet --address-prefixes 10.1.1.0/24

echo creating app subnet...
az network vnet subnet create -g $NAME -n App \
  --vnet-name $NAME-VNet --address-prefixes 10.1.2.0/24 
  --route-table $NAME-RT

echo creating firewall public ip...
az network public-ip create -g $NAME -n $NAME-FWIP --sku Standard

echo creating nsg...
az network nsg create -g $NAME -n $NAME-NSG

#### Firewall ###
strip
echo FIREWALL
strip
echo create firewall...
az network firewall create -g $NAME -n $NAME-FW

echo create firewall ip-config...
az network firewall ip-config create -g $NAME -n $NAME-IPConf --firewall-name $NAME-FW \
  --public-ip-address $NAME-FWIP --private-ip-address 10.1.1.4 --vnet-name $NAME-VNet

#### Load Balancer ###
strip
echo LOAD BALANCER
strip
echo create internal lb...
az network lb create -g $NAME -n $NAME-AppLB \
  --frontend-ip-name loadBalancerFrontEnd \
  --private-ip-address 10.1.2.20 \
  --backend-pool-name $NAME-AppLBBEPool \
  --vnet-name $NAME-VNet \
  --subnet App \
  --sku Basic

echo creating app probe...
az network lb probe create -g $NAME --lb-name $NAME-AppLB -n App-Probe \
  --protocol http --port 80 --path /

echo creating lb rule...
az network lb rule create -g $NAME --lb-name $NAME-AppLB -n App-Rule --protocol Tcp \
  --frontend-ip-name loadBalancerFrontEnd --frontend-port 80 \
  --backend-pool-name $NAME-AppLBBEPool --backend-port 80

### Application ###
strip
echo APPLICATION
strip
echo creating scale set... 
az vmss create -g $NAME -n $NAME-App \
  --image UbuntuLTS --instance-count 2 --upgrade-policy-mode Automatic --vm-sku Standard_B1s \
  --ssh-key-value @~/.ssh/id_rsa.pub --lb $NAME-AppLB \
  --subnet App --vnet-name $NAME-VNet --nsg $NAME-NSG

echo creating storage account...
az storage account create -n $STORAGE -g $NAME --kind StorageV2 --sku Standard_LRS

### Done ###
strip
echo Firewall IP : `az network public-ip show -g $NAME -n $NAME-FWIP --query ipAddress --output json` | tr -d [\"]
echo Balancer IP : `az network lb show -g $NAME -n $NAME-AppLB --output json --query "frontendIpConfigurations[0].privateIpAddress"` | tr -d [\"]
echo Instance IPs: `az vmss nic list -g $NAME --vmss-name $NAME-APP --query "[].[ipConfigurations[0].privateIpAddress]" --output tsv`
echo 
echo Done!