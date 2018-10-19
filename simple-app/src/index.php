<!DOCTYPE html>
<html>
    <head>
        <title>Simple BCS Docker Demo</title>

        <style>
            div {
                left: 50%;
                position: absolute; 
                margin-right: -50%; 
                transform: translate(-50%, -50%);
            }

            .hello {
                top:20%;
                font: 30px arial, sans-serif;"
            }

            .location {
                top: 25%;
                font: 20px arial, sans-serif;"
            }

            .capside {
                top: 30%;
            }
            
            .bcs {
                top: 50%;
            }

            .info {
                top:70%;
                font: 20px arial, sans-serif;"
            }
        </style>
    </head>
    <body>
        <div class="hello">
            Hello world. Today is <?= date('l \t\h\e jS') ?>.
        </div>
        <div class="location">
            <?php
                echo "Running Location is: " . $_ENV["HTTP_LOCATION"] . "<br><br>";

                if ($location == "westeurope") {
                    echo '<img src="eu.gif">';
                }
                if ($location == "southeastasia") {
                    echo '<img src="singapore.gif">';
                }
            ?>
            <img src="capside.png">
        </div>
        <div class="capside">
            <img src="capside.png">
        </div>
        <div class="bcs">
            <img src="bcs.png">
        </div>
        <div class="info">
            <?php
                echo "VM: " . gethostname() . " / " . $_SERVER['SERVER_ADDR'];
            ?>
        </div>
        <?php
            phpinfo()
        ?>
    </body>
</html>
