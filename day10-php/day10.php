<?php

$filename = "data.txt";
$lines = file($filename, FILE_IGNORE_NEW_LINES);

sort ($lines);

array_unshift($lines, 0);

for ($i = 0; $i < count($lines) - 1; $i++) {
    $difference = $lines[$i + 1] - $lines[$i];

    if($difference == 1) {
        $one++;
    }
        
    if($difference == 3){
        $three++;
    }

}
$three++;

echo sprintf("1->%d, 3->%d, result->%d\n", $one, $three, $one * $three);

?>