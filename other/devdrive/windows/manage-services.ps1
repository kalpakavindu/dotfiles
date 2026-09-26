#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Install", "Uninstall")]
    [string]$Action,

    [string]$DriveRoot = $(if ($env:DEV_DRIVE_LETTER -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_LETTER))) { "$($env:DEV_DRIVE_LETTER):" } else { "V:" })
)

$ErrorActionPreference = "Stop"

$ConfigFile = Join-Path $DriveRoot "devdrive-config.json"
if (-not (Test-Path $ConfigFile)) {
    throw "Configuration file not found: $ConfigFile"
}
$config = (Get-Content -Path $ConfigFile -Raw).Replace("{DriveRoot}", $DriveRoot) | ConvertFrom-Json
$WinSWDirectory = $config.WinSWDirectory

# Install: Install WinSW Services
if ($Action -eq "Install") {
    Write-Host "`n[+] Inspecting and Configuring WinSW Services..." -ForegroundColor Cyan

    if (Test-Path $WinSWDirectory) {
        $baseBinary = Join-Path $WinSWDirectory "winsw.exe"
        $configFiles = Get-ChildItem -Path $WinSWDirectory -Filter "*-service.xml"

        foreach ($xmlFile in $configFiles) {
            Write-Host

            [xml]$xmlContent = Get-Content $xmlFile.FullName
            $serviceId = $xmlContent.service.id
            $serviceName = $xmlFile.BaseName
            $serviceExe = Join-Path $WinSWDirectory "$serviceName.exe"

            # Generate executable wrapper from base winsw.exe if not present
            if (-not (Test-Path $serviceExe) -and (Test-Path $baseBinary)) {
                Copy-Item -Path $baseBinary -Destination $serviceExe -Force
                Write-Host "  [COPIED]  Created wrapper $serviceName.exe" -ForegroundColor Gray
            }

            if (-not (Test-Path $serviceExe)) {
                Write-Host "  [SKIPPED] Missing executable wrapper: $serviceExe" -ForegroundColor Red
                continue
            }

            $serviceInstance = Get-Service -Name $serviceId -ErrorAction SilentlyContinue

            if (-not $serviceInstance) {
                Write-Host "  [INSTALL] Registering service '$serviceId'..." -ForegroundColor Yellow
                Start-Process -FilePath $serviceExe -ArgumentList "install" -WorkingDirectory $WinSWDirectory -NoNewWindow -Wait
            }
        }
    }
    else {
        Write-Host "  [ERROR] WinSW directory not found: $WinSWDirectory" -ForegroundColor Red
    }
}


# Uninstall: Stop and Uninstall WinSW Services
if ($Action -eq "Uninstall") {
    Write-Host "`n[+] Stopping and Unregistering WinSW Services..." -ForegroundColor Cyan

    if ((-not [string]::IsNullOrWhiteSpace($WinSWDirectory)) -and (Test-Path $WinSWDirectory)) {
        $configFiles = Get-ChildItem -Path $WinSWDirectory -Filter "*-service.xml"

        foreach ($xmlFile in $configFiles) {
            [xml]$xmlContent = Get-Content $xmlFile.FullName
            $serviceId = $xmlContent.service.id
            $serviceName = $xmlFile.BaseName
            $serviceExe = Join-Path $WinSWDirectory "$serviceName.exe"

            $serviceInstance = Get-Service -Name $serviceId -ErrorAction SilentlyContinue

            if ($serviceInstance) {
                Write-Host "`n  [FOUND] Service '$serviceId' is registered." -ForegroundColor Yellow

                if ($serviceInstance.Status -eq "Running") {
                    Write-Host "    -> Stopping service..." -ForegroundColor Gray
                    if (Test-Path $serviceExe) {
                        Start-Process -FilePath $serviceExe -ArgumentList "stop" -WorkingDirectory $WinSWDirectory -NoNewWindow -Wait
                    }
                    else {
                        Stop-Service -Name $serviceId -Force
                    }
                }

                Write-Host "    -> Uninstalling service..." -ForegroundColor Gray
                if (Test-Path $serviceExe) {
                    Start-Process -FilePath $serviceExe -ArgumentList "uninstall" -WorkingDirectory $WinSWDirectory -NoNewWindow -Wait
                }
                else {
                    Start-Process -FilePath "sc.exe" -ArgumentList "delete", $serviceId -NoNewWindow -Wait
                }
                Write-Host "  [REMOVED] Service '$serviceId' unregistered." -ForegroundColor Green
            }
        }
    }
    else {
        Write-Host "  [SKIP] WinSW directory ($WinSWDirectory) not accessible." -ForegroundColor DarkGray
    }
}