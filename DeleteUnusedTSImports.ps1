$unused = @(tslint -c tslint.json **\*.ts*) -match "Unused import"
Write-Host Found $unused.Length unused imports.
[array]::reverse($unused)

$unused | foreach { 
    write-host $_
    $file,$line,$rest = $_.split(",\[")
    $lines = get-content $file
    if ($lines[$line - 1] -match ",") {
        write-host --Ignored $lines[$line - 1]
        write-host
    } else {
        $filteredlines = @($lines | select-object -first ($line - 1)) + @($lines | select-object -skip $line)
        set-content -path $file -value $filteredlines
    }
}
