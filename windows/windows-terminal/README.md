# Setting up Windows Terminal

Ensure installed:
- `Windows Terminal`
- `MSYS2`
- `Git Bash`
- `JetBrains Mono Nerd Font`

# Setup

Symlink `./settings.json` to the Windows Terminal Configuration Path.
In my case here: `~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`

```powershell
New-Item -ItemType SymbolicLink `
-Path "C:\Users\kalpa\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
-Target "D:\src\dotfiles\windows\windows-terminal\settings.json"
```