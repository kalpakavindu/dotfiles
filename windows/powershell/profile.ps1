# Written by Kalpa Kavindu <kalpadevonline@gmail.com>

Set-Alias -Name np -Value Notepad.exe
Set-Alias -Name wh -Value where.exe

function Play-Next {(New-Object -ComObject WScript.Shell).SendKeys([char]176)}
function Play-Prev {(New-Object -ComObject WScript.Shell).SendKeys([char]177)}
function Play-Toggle {(New-Object -ComObject WScript.Shell).SendKeys([char]179)}
function Volume-Up {(New-Object -ComObject WScript.Shell).SendKeys([char]175)}
function Volume-Down {(New-Object -ComObject WScript.Shell).SendKeys([char]174)}
function Volume-Mute {(New-Object -ComObject WScript.Shell).SendKeys([char]173)}

Set-Alias -Name plnext -Value Play-Next
Set-Alias -Name plprev -Value Play-Prev
Set-Alias -Name pltogg -Value Play-Toggle
Set-Alias -Name volup -Value Volume-Up
Set-Alias -Name voldo -Value Volume-Down
Set-Alias -Name volmu -Value Volume-Mute


function prompt {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    $userColor = if ($isAdmin) { "`e[31m" } else { "`e[32m" }
    $reset = "`e[0m"
    $green = "`e[32m"
    $cyan  = "`e[36m"
    $blue  = "`e[34m"

    $user = [Environment]::UserName
    $hostName = ([Environment]::MachineName).ToLower()
    
    $pwd = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($pwd.StartsWith($HOME)) {
        $pwd = "~" + $pwd.Substring($HOME.Length)
    }

    # ╭─(USERNAME@HOSTNAME) PWD
    $line1 = "${green}╭─(${userColor}${user}${cyan}@${green}${hostName}) ${blue}${pwd}${reset}"
    
    # ╰─➤ 
    $line2 = "${green}╰─${userColor}➤${reset} "

    return "`n$line1`n$line2"
}