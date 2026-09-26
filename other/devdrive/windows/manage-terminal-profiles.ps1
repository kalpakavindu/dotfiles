#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Attach", "Detach")]
    [string]$Action,

    [string]$DriveRoot = $(if ($env:DEV_DRIVE_LETTER -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_LETTER))) { "$($env:DEV_DRIVE_LETTER):" } else { "V:" })
)

$ErrorActionPreference = "Stop"

$FragmentDir = Join-Path $env:ProgramData "Microsoft\Windows Terminal\Fragments\devdrive"
$FragmentFile = Join-Path $FragmentDir "devdrive-profiles.json"
$ConfigFile = Join-Path $DriveRoot "devdrive-config.json"

# Attach: Inject Terminal Profiles
if ($Action -eq "Attach") {
    Write-Host "`n[+] Registering Windows Terminal Profiles from $ConfigFile..." -ForegroundColor Cyan

    if (-not (Test-Path $ConfigFile)) {
        Write-Host "  [WARN] Configuration file not found at $ConfigFile. Skipping terminal registration." -ForegroundColor Yellow
        return
    }

    $config = (Get-Content -Path $ConfigFile -Raw).Replace("{DriveRoot}", $DriveRoot) | ConvertFrom-Json

    if (-not $config.TerminalProfiles -or ($config.TerminalProfiles.Count -eq 0)) {
        Write-Host "  [OK] No TerminalProfiles array found in $ConfigFile. Skipping." -ForegroundColor DarkGray
        return
    }

    $fragmentStructure = @{
        profiles = @($config.TerminalProfiles)
    }

    if (-not (Test-Path $FragmentDir)) {
        New-Item -ItemType Directory -Force -Path $FragmentDir | Out-Null
    }

    $jsonPayload = $fragmentStructure | ConvertTo-Json -Depth 5
    Set-Content -Path $FragmentFile -Value $jsonPayload -Encoding UTF8
    Write-Host "  [CREATED] Fragment installed: $FragmentFile ($($config.TerminalProfiles.Count) profiles)" -ForegroundColor Green
}


# Detach: Purge Injected Profiles
if ($Action -eq "Detach") {
    Write-Host "`n[+] Unregistering Windows Terminal Profiles..." -ForegroundColor Cyan

    if (Test-Path $FragmentFile) {
        Remove-Item -Path $FragmentFile -Force
        Write-Host "  [REMOVED] Fragment deleted: $FragmentFile" -ForegroundColor Green
    }
    else {
        Write-Host "  [OK] Fragment was not registered." -ForegroundColor DarkGray
    }

    if ((Test-Path $FragmentDir) -and ((Get-ChildItem $FragmentDir).Count -eq 0)) {
        Remove-Item -Path $FragmentDir -Force
    }
}