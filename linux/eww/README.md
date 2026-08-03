# Setting up EWW

Ensure installed:
- **`eww-git`<sup>AUR</sup>**
- `sassc`
- `pamixer`
- `brightnessctl`
- `swaync`
- `NetworkManager`
- `pavucontrol`
- `python-pywal`
- `alsa-utils`

## Setup

Generate color variables for your wallpaper using `pywal`.

```bash
wal -i "/home/kalpakavindu/Source/dotfiles/linux/hypr/res/backgrounds/anime.girl.with.blue.eyes.1920x1080.png"
```

Symlink this folder with `~/.config/eww`

```bash
rm -rf '/home/kalpakavindu/.config/eww'
sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/eww' '/home/kalpakavindu/.config/eww'
```