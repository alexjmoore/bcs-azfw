<!DOCTYPE html>
<?php

header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
?>
<html>
    <head>
        <title>Simple Application!</title>
        <style>
            div {
                padding: 10px;
                display: block;
                text-align: center;               
            }
            .hello {
                font: 30px arial, sans-serif;
            }
            .location {
                font: 20px arial, sans-serif;
                font-weight: bold;
            }
            .logos {
                display: inline-block;
                vertical-align: middle;
            }
            .info {
                font: 20px arial, sans-serif;
            }
        </style>
    </head>
    <body>
        <div class="hello">
            Today is <?= date('l \t\h\e jS') ?>.
        </div>
        <div class="location">
            <?php
                $location = $_SERVER["HTTP_LOCATION"];
                echo "Application is running in: " . $location . "<br><br>";

                if ($location == "westeurope") {
                    echo '<img src="eu.gif">';
                }
                if ($location == "southeastasia") {
                    echo '<img src="singapore.gif">';
                }
            ?>
        </div>
        <div>
            <div class="logos">
                <img src="capside.png">
            </div>
            <div class="logos">
                <img src="bcs.png">
            </div>
        </div>
        <div class="info">
            <?php
                echo "VM: " . gethostname() . " / " . $_SERVER['SERVER_ADDR'];
            ?>
        </div>
    </body>
</html>
