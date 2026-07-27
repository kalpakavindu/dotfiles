# Setting up HTOP System monitor

Ensure installed:
- `htop`

## Setup
Create a symlink to this folder for `~/.config/htop`.

```bash
rm -rf '/home/kalpakavindu/.config/htop'
sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/htop' '/home/kalpakavindu/.config/htop'
```