$scriptDir = if ($PSScriptRoot) {
    $PSScriptRoot
} elseif ($MyInvocation -and $MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path) {
    Split-Path -Path $MyInvocation.MyCommand.Path -Parent
} else {
    (Get-Location).ProviderPath
}

$localFile = Join-Path $scriptDir 'apps3.txt'
$remoteUrl = 'https://raw.githubusercontent.com/mahfujarr/ADBloop/refs/heads/main/apps3.txt'

if (Test-Path $localFile) {
    $packages = Get-Content -Path $localFile -ErrorAction Stop
} else {
    try {
        $content = Invoke-RestMethod -Uri $remoteUrl -ErrorAction Stop
        if ($null -eq $content) { throw "Empty content" }
        $packages = $content -split "`r?`n"
        Write-Host "Downloaded apps list from $remoteUrl"
    } catch {
        Write-Host "apps3.txt not found locally and failed to download from $remoteUrl`n$_"
        exit 1
    }
}

$packages = @($packages) | ForEach-Object { $_.ToString().Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not $_.StartsWith('#') }

$count = $packages.Count
Write-Host "You have $count packages in the file`n"

if ($count -eq 0) {
    Write-Host "No packages to process."
    exit 0
}

$i = 0
foreach ($pkg in $packages) {
    try {
        $adbArgs = @('shell','appops','set',$pkg,'RUN_ANY_IN_BACKGROUND','ignore')
        $output = & adb @adbArgs 2>&1

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