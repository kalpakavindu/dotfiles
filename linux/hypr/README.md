# Setting up Hyprland

Ensure installed:
- **`hyprland`**

## Setup

Symlink this directory with `~/.config/hypr`.

```bash
sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/hypr' '/home/kalpakavindu/.config/hypr'
```

### hyprpaper

If using `uwsm`, set `hyprpaper` start at startup or source the config file.

```bash
systemctl --user enable --now hyprpaper.service
source = ~/.config/hypr/hyprpaper.conf
```

### hypridle

If using `uwsm`, set `hypridle` start at startup or source the config file.

```bash
systemctl --user enable --now hypridle.service
```