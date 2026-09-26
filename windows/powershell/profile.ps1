# Written by Kalpa Kavindu <kalpadevonline@gmail.com>

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