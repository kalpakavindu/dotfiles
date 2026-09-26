#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Attach", "Detach")]
    [string]$Action,

    [string]$DriveRoot = $(if ($env:DEV_DRIVE_LETTER -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_LETTER))) { "$($env:DEV_DRIVE_LETTER):" } else { "V:" })
)

$ErrorActionPreference = "Stop"

$ConfigFile = Join-Path $DriveRoot "devdrive-config.json"
if (-not (Test-Path $ConfigFile)) {
    throw "Configuration file not found: $ConfigFile"
}
$config = (Get-Content -Path $ConfigFile -Raw).Replace("{DriveRoot}", $DriveRoot) | ConvertFrom-Json
$TargetScope = $config.TargetScope


# Attach: Inject Environment Variables and PATH entries
if ($Action -eq "Attach") {
    Write-Host "`n[+] Configuring Environment Variables ($TargetScope scope)..." -ForegroundColor Cyan

    foreach ($prop in $config.EnvironmentVariables.PSObject.Properties) {
        $varName = $prop.Name
        $varValue = $prop.Value
        $currentVal = [Environment]::GetEnvironmentVariable($varName, $TargetScope)

        if ($currentVal -ne $varValue) {
            [Environment]::SetEnvironmentVariable($varName, $varValue, $TargetScope)
            [Environment]::SetEnvironmentVariable($varName, $varValue, "Process")
            Write-Host "  [UPDATED] $varName = $varValue" -ForegroundColor Green
        }
        else {
            Write-Host "  [OK]      $varName is already configured." -ForegroundColor DarkGray
        }
    }

    # Clear legacy GOPATH if present
    if ([Environment]::GetEnvironmentVariable("GOPATH", $TargetScope)) {
        [Environment]::SetEnvironmentVariable("GOPATH", $null, $TargetScope)
        [Environment]::SetEnvironmentVariable("GOPATH", $null, "Process")
        Write-Host "  [REMOVED] Legacy GOPATH variable cleared." -ForegroundColor Yellow
    }

    # Process PATH
    Write-Host "`n[+] Updating System PATH ($TargetScope scope)..." -ForegroundColor Cyan

    $rawCurrentPath = [Environment]::GetEnvironmentVariable("Path", $TargetScope)
    $currentPaths = $rawCurrentPath -split ';' | Where-Object { [string]::IsNullOrWhiteSpace($_) -eq $false }
    $pathsToAdd = [System.Collections.Generic.List[string]]::new()

    foreach ($dir in $config.PathEntries) {
        $normalizedDir = $dir.TrimEnd('\')
        $alreadyExists = $currentPaths | Where-Object { $_.TrimEnd('\').Equals($normalizedDir, [System.StringComparison]::OrdinalIgnoreCase) }

        if (-not $alreadyExists) {
            $pathsToAdd.Add($normalizedDir)
            Write-Host "  [ADDED]   $normalizedDir" -ForegroundColor Green
        }
        else {
            Write-Host "  [EXISTS]  $normalizedDir" -ForegroundColor DarkGray
        }
    }

    if ($pathsToAdd.Count -gt 0) {
        $updatedPath = ($pathsToAdd + $currentPaths) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $updatedPath, $TargetScope)
        [Environment]::SetEnvironmentVariable("Path", "$([Environment]::GetEnvironmentVariable('Path', 'Machine'));$([Environment]::GetEnvironmentVariable('Path', 'User'))", "Process")
        Write-Host "  -> PATH updated with $($pathsToAdd.Count) new entries." -ForegroundColor Cyan
    }
    else {
        Write-Host "  -> All PATH entries already exist. No change." -ForegroundColor DarkGray
    }

    Write-Host "`n[+] Environment setup completed successfully." -ForegroundColor Green
}



# Detach: Remove Environment Variables and PATH entries
if ($Action -eq "Detach") {
    Write-Host "`n[+] Purging Environment Variables ($TargetScope scope)..." -ForegroundColor Cyan

    foreach ($prop in $config.EnvironmentVariables.PSObject.Properties) {
        $varName = $prop.Name
        $currentVal = [Environment]::GetEnvironmentVariable($varName, $TargetScope)

        if ($null -ne $currentVal) {
            [Environment]::SetEnvironmentVariable($varName, $null, $TargetScope)
            [Environment]::SetEnvironmentVariable($varName, $null, "Process")
            Write-Host "  [REMOVED] $varName" -ForegroundColor Green
        }
        else {
            Write-Host "  [OK]      $varName is not set." -ForegroundColor DarkGray
        }
    }

    # Remove PATH Entries
    Write-Host "`n[+] Removing DevDrive paths from PATH ($TargetScope scope)..." -ForegroundColor Cyan

    $rawCurrentPath = [Environment]::GetEnvironmentVariable("Path", $TargetScope)
    $currentPaths = $rawCurrentPath -split ';' | Where-Object { [string]::IsNullOrWhiteSpace($_) -eq $false }

    $cleanedPaths = $currentPaths | Where-Object {
        $existing = $_.TrimEnd('\')
        $isTarget = $false

        # Check against paths defined in config
        foreach ($entry in $config.PathEntries) {
            if ($existing.Equals($entry.TrimEnd('\'), [System.StringComparison]::OrdinalIgnoreCase)) {
                $isTarget = $true
                break
            }
        }

        # Catch-all safety for any remaining DriveRoot paths
        if ($existing.StartsWith($DriveRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            $isTarget = $true
        }

        if ($isTarget) {
            Write-Host "  [PRUNED]  $existing" -ForegroundColor Yellow
            return $false
        }
        return $true
    }

    $updatedPath = $cleanedPaths -join ';'
    [Environment]::SetEnvironmentVariable("Path", $updatedPath, $TargetScope)
    [Environment]::SetEnvironmentVariable("Path", "$([Environment]::GetEnvironmentVariable('Path', 'Machine'));$([Environment]::GetEnvironmentVariable('Path', 'User'))", "Process")

    Write-Host "`n[+] Environment teardown completed successfully." -ForegroundColor Green
}