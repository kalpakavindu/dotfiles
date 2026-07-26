# Setting up WSL

Ensure installed:
- `Windows Subsystem for Linux` windows feature
  
# Setup

Create a symlink for `./.wslconfig` to `~\.wslconfig`. Run the following command in powershell with administrator privileges.

```powershell
New-Item -Type SymbolicLink `
-Target "D:\dotfiles\windows\wsl\.wslconfig" `
-Path "C:\Users\kalpa\.wslconfig"
```