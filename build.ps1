$projectdir = 'C:\git\project-report-4'
# $kv = bat C:\git\project-report-4\Variables.txt -p |
$kv = Get-Content "$projectdir\Variables.txt" |
    sed -n '10,$d;p' |
    Foreach-Object {$_ -replace '(?:\s+=\s+)|(?:\s+=)|(?:=\s+)', '=' } |
    ConvertFrom-Csv -Delimiter '='

foreach($i in 0..($kv.Length-1)) {
    $kv[$i].Variables = [regex]::escape($kv[$i].Variables)
}

$kv.Variables -replace '/','\/' |
    Foreach-Object -Begin { $i=0 } {
        $kv[$i].Variables=$_; $i++
    }

Write $kv

$lhs = $kv.Variables
$rhs = $kv.Value

Copy-Item $projectdir\index.html $projectdir\print.html

foreach ($e in $kv) {
    $lhs, $rhs = $e.Variables, $e.Value;
    sed -i s/$lhs/$rhs/g .\print.html ;
    # Start-Sleep -Milliseconds 1 
    #// Uncomment it if build produces an empty print.html
}