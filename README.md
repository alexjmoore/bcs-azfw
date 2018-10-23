# bcs-azfw
Samples from the Azure Firewall &amp; Azure Front Door presentation

## Azure CLI steps to use these features

First register the features against the Network provider:
```
az feature register -n AllowRegionalGatewayManagerForSecureGateway --namespace Microsoft.Network
az feature register -n AllowAzureFirewall --namespace Microsoft.Network
az feature register -n AllowFrontdoor --namespace Microsoft.Network
```

Then re-register the provider:
```
az provider register -n Microsoft.Network –wait
```

Finally if you want to provision resources from the CLI you will need to add and/or update the extensions:
```
az extension add --name azure-firewall
az extension add --name front-door
az extension update --name azure-firewall
az extension update --name front-door
```