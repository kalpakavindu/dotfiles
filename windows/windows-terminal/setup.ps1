# Written by Kalpa Kavindu <kalpadevonline@gmail.com>

$TargetDir = "C:\Users\kalpa\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$SourceDir = "$PSScriptRoot"

Get-ChildItem -Path $TargetDir -Recurse -Exclude "settings.json" | Copy-Item -Destination {
    Join-Path $SourceDir $_.FullName.Substring($TargetDir.Length)
} -Force

Remove-Item -Path $TargetDir -Recurse -Force

New-Item -ItemType Junction -Path $TargetDir -Target $SourceDir