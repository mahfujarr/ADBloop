$appsFile = Join-Path (Split-Path -Path $MyInvocation.MyCommand.Path -Parent) 'apps3.txt'

if (-Not (Test-Path $appsFile)) {
    Write-Host "apps.txt not found in script folder: $appsFile"
    exit 1
}

$packages = Get-Content -Path $appsFile -ErrorAction Stop
$count = $packages.Count
Write-Host "You have $count packages in the file`n"

$i = 0
foreach ($pkg in $packages) {
    try {
        $output = & adb shell appops set $pkg RUN_ANY_IN_BACKGROUND allow 2>&1
        if ([string]::IsNullOrWhiteSpace($output)) {
            Write-Host "$pkg --> RESTRICTED"
        } else {
            Write-Host $output
        }
    } catch {
        Write-Host "Error running command for ${pkg}: $_"
    }

    $i++
    $percent = if ($count -gt 0) { [int](($i / $count) * 100) } else { 100 }
    Write-Progress -Activity "Processing packages" -Status "$percent% completed" -PercentComplete $percent
    Start-Sleep -Milliseconds 100
}

Write-Progress -Activity "Processing packages" -Completed
Write-Host "Done."