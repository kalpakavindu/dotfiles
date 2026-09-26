#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [string]$DriveRoot = $(if ($env:DEV_DRIVE_LETTER -and (-not [string]::IsNullOrWhiteSpace($env:DEV_DRIVE_LETTER))) { "$($env:DEV_DRIVE_LETTER):" } else { "V:" })
)

$ErrorActionPreference = "Stop"

$BinDir = "$DriveRoot\bin\windows\mysql"
$DataDir = "$DriveRoot\data\mysql\windows"
$ExePath = "$BinDir\bin\mysql.exe"
$IniPath = "$BinDir\my.ini"
$ServiceName = "mysql"

Remove-Item -Path "$DataDir\*" -Recurse -Force -ErrorAction SilentlyContinue

# Initialize system tables
& "$BinDir\bin\mysqld.exe" --defaults-file="$BinDir\my.ini" --initialize-insecure --console

if (-not (Test-Path "$DataDir\logs")) {
    New-Item -ItemType Directory -Force -Path "$DataDir\logs" | Out-Null
}

# Set Root Password
do {
    try {
        $password = Read-Host "Enter new MySQL root password" -MaskInput
        $confirm = Read-Host "Confirm new MySQL root password" -MaskInput
    }
    catch {
        $password = Read-Host "Enter new MySQL root password"
        $confirm = Read-Host "Confirm new MySQL root password"
    }

    if ([string]::IsNullOrWhiteSpace($password)) {
        Write-Host "[!] Password cannot be blank." -ForegroundColor Red
        continue
    }
    if ($password -ne $confirm) {
        Write-Host "[!] Passwords do not match. Please try again.`n" -ForegroundColor Yellow
    }
} while ($password -ne $confirm -or [string]::IsNullOrWhiteSpace($password))


$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($service -and $service.Status -ne "Running") {
    Write-Host "[+] Starting service '$ServiceName'..." -ForegroundColor Gray
    Start-Service -Name $ServiceName
    Start-Sleep -Seconds 3
}

Write-Host "[+] Setting password for root@localhost..." -ForegroundColor Cyan

$escapedPassword = $password.Replace("'", "''")
$sqlQuery = "ALTER USER 'root'@'localhost' IDENTIFIED BY '$escapedPassword'; FLUSH PRIVILEGES;"

try {
    # Attempt connecting without password (fresh/insecure cluster state)
    & $ExePath -u root --execute="$sqlQuery" 2>$null
}
catch {
    # If connection was refused, prompt for the current/existing password
    Write-Host "[!] Empty password rejected. Prompting for current password..." -ForegroundColor Yellow
    $currentPass = Read-Host "Enter CURRENT root password"
    & $ExePath -u root "-p$currentPass" --execute="$sqlQuery"
}

if ($LASTEXITCODE -ne 0) {
    throw "Failed to set root password. Check that the MySQL server is running and credentials are valid."
}

Write-Host "[+] Root password updated successfully." -ForegroundColor Green
Write-Host "Make sure to add user = root and password = $escapedPassword to the $IniPath file under [mysqladmin] section." 