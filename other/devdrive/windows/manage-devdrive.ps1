#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Attach", "Detach")]
    [string]$Action,

    [string]$VhdxPath = $(if ($env:DEV_DRIVE_PATH -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_PATH))) { "$($env:DEV_DRIVE_PATH)" } else { "D:\disks\dev_drive.vhdx" }),
    [string]$DriveRoot = $(if ($env:DEV_DRIVE_LETTER -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_LETTER))) { "$($env:DEV_DRIVE_LETTER):" } else { "V:" })
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EnvScript = Join-Path $ScriptDir "manage-devdrive-env.ps1"
$ServicesScript = Join-Path $ScriptDir "manage-services.ps1"
$TerminalScript = Join-Path $ScriptDir "manage-terminal-profiles.ps1"

function Invoke-DiskpartScript ([string]$scriptContent) {
    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $scriptContent -Encoding ASCII
    try {
        $output = & diskpart.exe /s $tempFile
        return $output
    }
    finally {
        Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
    }
}

# Attach: Attach Workflow
if ($Action -eq "Attach") {
    Write-Host "`n[+] Attaching Dev Drive ($DriveRoot)" -ForegroundColor Cyan

    # Attach VHDX container
    if (-not (Test-Path $DriveRoot)) {    
        if (-not (Test-Path $VhdxPath)) {
            throw "VHDX container file not found: $VhdxPath"
        }

        Write-Host "    Mounting VHDX via diskpart..." -ForegroundColor Gray
        $diskpartCmd = @"
select vdisk file="$VhdxPath"
attach vdisk
select partition 1
assign letter=$DriveLetter
"@
        Invoke-DiskpartScript $diskpartCmd | Out-Null

        $retry = 0
        while (-not (Test-Path $DriveRoot) -and $retry -lt 10) {
            Start-Sleep -Seconds 1
            $retry++
        }

        if (-not (Test-Path $DriveRoot)) {
            throw "Failed to attach and mount VHDX to $DriveRoot"
        }

        Write-Host "    VHDX attached to $DriveRoot successfully." -ForegroundColor Green
    }
    else {
        Write-Host "[!] Drive $DriveRoot is already mounted." -ForegroundColor Yellow
    }

    # Install Services
    if (Test-Path $ServicesScript) {
        & $ServicesScript -Action Install -DriveRoot $DriveRoot
    }

    # Setup Environment
    if (Test-Path $EnvScript) {
        & $EnvScript -Action Attach -DriveRoot $DriveRoot
    }

    # Register Windows Terminal profiles
    if (Test-Path $TerminalScript) {
        & $TerminalScript -Action Attach -DriveRoot $DriveRoot
    }
}

# Detach: Detach Workflow
if ($Action -eq "Detach") {
    Write-Host "`n[+] Detaching Dev Drive ($DriveRoot)" -ForegroundColor Cyan

    # Unregister Windows Terminal profiles
    if (Test-Path $TerminalScript) {
        & $TerminalScript -Action Detach -DriveRoot $DriveRoot
    }

    # Uninstall Services
    if (Test-Path $ServicesScript) {
        & $ServicesScript -Action Uninstall -DriveRoot $DriveRoot
    }

    # Teardown Environment
    if (Test-Path $EnvScript) {
        & $EnvScript -Action Detach -DriveRoot $DriveRoot
    }

    # Detach VHDX container
    if (Test-Path $DriveRoot) {
        Write-Host "    Dismounting and detaching VHDX..." -ForegroundColor Gray
        $diskpartCmd = @"
select vdisk file="$VhdxPath"
detach vdisk
"@
        Invoke-DiskpartScript $diskpartCmd | Out-Null

        Start-Sleep -Seconds 3
        if (Test-Path $DriveRoot) {
            Write-Host "[WARN] Drive $DriveRoot is still present. Files may still be in use." -ForegroundColor Yellow
        }
        else {
            Write-Host "[+] DevDrive container detached cleanly." -ForegroundColor Green
        }
    }
    else {
        Write-Host "[OK] Drive $DriveRoot was not mounted." -ForegroundColor DarkGray
    }
}