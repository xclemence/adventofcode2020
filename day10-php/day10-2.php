<?php

$cache = [];

function branchNumber($values, $index, &$cache) : int {
    $size = count($values);

    if(array_key_exists($values[$index], $cache)) {
        return $cache[$values[$index]];
    }

    if ($index >= $size - 1)
        return 1;

    $multiplicator = 0;


    for ($i = 1; $i <= 3; ++$i) {
        if ($index + $i < $size && $values[$index + $i] - $values[$index] <= 3) {
            $multiplicator+= branchNumber($values, $index + $i, $cache);
        }
    }

    $cache[$values[$index]] = $multiplicator;

    return $multiplicator;
} 

$filename = "data.txt";
$lines = file($filename, FILE_IGNORE_NEW_LINES);

sort ($lines);

array_unshift($lines, 0);

echo sprintf("result->%d\n", branchNumber($lines, 0, $cache));

?>