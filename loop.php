<?php
$hostname = trim(`hostname`);

for (;;) {
    $hostname = trim(`hostname`);
    xdebug_break();
    echo $hostname . PHP_EOL;
    sleep(10);
}
