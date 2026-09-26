#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n=== [DEVDRIVE MANAGER INSTALLER] ===" -ForegroundColor Cyan

# 1. Prompt for Drive Letter
$inputLetter = Read-Host "Enter the drive letter for DevDrive [Default: V]"
if ([string]::IsNullOrWhiteSpace($inputLetter)) {
    $inputLetter = "V"
}
# Normalize: strip colon, backslash, whitespace, and uppercase
$cleanLetter = $inputLetter.Trim().TrimEnd(':').TrimEnd('\').ToUpper()

# Store in persistent Machine environment variable
[Environment]::SetEnvironmentVariable("DEVDRIVE_LETTER", $cleanLetter, "Machine")
[Environment]::SetEnvironmentVariable("DEVDRIVE_LETTER", $cleanLetter, "Process")
Write-Host "[+] Stored DEVDRIVE_LETTER = '$cleanLetter' in Machine environment." -ForegroundColor Green

# 2. Prompt for VHDX Path
$defaultVhdx = "D:\disks\devdrive.vhdx"
$inputVhdx = Read-Host "Enter full path to devdrive.vhdx [Default: $defaultVhdx]"
$vhdxPath = if ([string]::IsNullOrWhiteSpace($inputVhdx)) { $defaultVhdx } else { $inputVhdx.Trim() }

if (-not (Test-Path $vhdxPath)) {
    Write-Host "[WARN] VHDX container not currently found at: $vhdxPath" -ForegroundColor Yellow
}

# 3. Create Logs Directory
$logDir = Join-Path$ScriptDir "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
}

# 4. Generate AutomountDevDrive WinSW XML
$serviceXmlPath = Join-Path$ScriptDir "AutomountDevDrive.xml"
$manageScript = Join-Path$ScriptDir "Manage-DevDrive.ps1"

$xmlContent = @"
<service>
  <id>AutomountDevDrive</id>
  <name>DevDrive Automount Service</name>
  <description>Mounts DevDrive container on boot and executes teardown on shutdown.</description>
  <executable>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</executable>
  <arguments>-NoProfile -ExecutionPolicy Bypass -Command "&amp; '$manageScript' -Action Attach -VhdxPath '$vhdxPath'; while (`$true) { Start-Sleep -Seconds 3600 }"</arguments>
  
  <stopexecutable>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</stopexecutable>
  <stoparguments>-NoProfile -ExecutionPolicy Bypass -Command "&amp; '$manageScript' -Action Detach -VhdxPath '$vhdxPath'"</stoparguments>
  
  <logmode>rotate</logmode>
  <logpath>$logDir</logpath>
  <startmode>Automatic</startmode>
</service>
"@

Set-Content -Path $serviceXmlPath -Value $xmlContent -Encoding UTF8
Write-Host "[+] Generated service configuration: $serviceXmlPath" -ForegroundColor Green

# 5. Register WinSW Service
$baseWinSW = Join-Path $ScriptDir "winsw.exe"
$serviceExe = Join-Path $ScriptDir "AutomountDevDrive.exe"

if (-not (Test-Path $serviceExe)) {
    if (Test-Path $baseWinSW) {
        Copy-Item -Path $baseWinSW -Destination $serviceExe -Force
        Write-Host "[+] Created $serviceExe from winsw.exe" -ForegroundColor Gray
    }
    else {
        throw "Could not find 'winsw.exe' in $ScriptDir to create $serviceExe"
    }
}

$existingService = Get-Service -Name "AutomountDevDrive" -ErrorAction SilentlyContinue
if ($existingService) {
    Write-Host "[!] AutomountDevDrive service already registered. Restarting..." -ForegroundColor Yellow
    Start-Process -FilePath $serviceExe -ArgumentList "restart" -WorkingDirectory $ScriptDir -NoNewWindow -Wait
}
else {
    Write-Host "[+] Installing and starting AutomountDevDrive service..." -ForegroundColor Yellow
    Start-Process -FilePath $serviceExe -ArgumentList "install" -WorkingDirectory $ScriptDir -NoNewWindow -Wait
    Start-Process -FilePath $serviceExe -ArgumentList "start"   -WorkingDirectory $ScriptDir -NoNewWindow -Wait
}

Write-Host "`n[+] DevDrive Manager installed and configured successfully." -ForegroundColor Green