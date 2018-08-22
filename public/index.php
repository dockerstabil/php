<?php
header("Content-Type: text/plain");

$hostname = trim(`hostname`);
xdebug_break();
echo $hostname.PHP_EOL;
