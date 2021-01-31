[string[]]$lines = Get-Content -Path 'input.txt'

$pattern = "(?<min>\d+)-(?<max>\d+) (?<char>\S+): (?<pwd>\S+)"

function validate1($min, $max, $character, $password) {
    $itemNumber = @($password.ToCharArray() | Where-Object { $_ -eq $character }).Count;
    return (($itemNumber -le $max) -and ($itemNumber -ge $min))
}

function validate2($min, $max, $character, $password) {
    return ((($password[$min - 1] -eq $character) -or ($password[$max - 1] -eq $character)) -and  ($password[$min - 1] -ne $password[$max - 1]));
}

$results = $lines | Where-Object { 
    $match = [regex]::Matches($_, $pattern);
    validate2 $match[0].Groups['min'].Value $match[0].Groups['max'].Value $match[0].Groups['char'].Value $match[0].Groups['pwd'].Value
}

Write-host  @($results).Count
