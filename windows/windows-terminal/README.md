# Setting up Windows Terminal

Ensure installed:
- **`Windows Terminal`**
- `MSYS2`
- `Git Bash`
- `JetBrains Mono Nerd Font`

## Setup

Copy `./settings.json` to the Windows Terminal Configuration Path.
In my case here: `~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`

Symlinking this file or even creating a HardLink will not work with Windows Terminal because it uses `safe-save` process to save settings into this file which first deletes the current file and save the settings into a new file. So you need to create a Junction for the `LocalState` directory, not the file. The `./setup.ps1` script safely create the Junction with this directory without deleting the other files already in the `LocalState` directory.