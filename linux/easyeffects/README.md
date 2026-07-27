# Setting up Easy Effects

Ensure installed:
- **`easyeffects`**
- `pipewire`
- `pipewire-pulse`
- `lsp-plugins-lv2` - Provide Linux Studio Plugins
- `calf` - Provide Calf Studio Gear

## Setup
For application configurations, Create a symlink to `./config/db` for `~/.config/easyeffects/db` and another symlink to `./config/easyeffectsrc` for `~/.config/easyeffectsrc`.

```bash
# Run these in bash not zsh
shopt -s extglob
cp -r /home/kalpakavindu/.config/easyeffects/db/!(easyeffectsrc) /home/kalpakavindu/Source/dotfiles/linux/easyeffects/config/db/

rm -rf /home/kalpakavindu/.config/easyeffects/db
rm /home/kalpakavindu/.config/easyeffectsrc

sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/easyeffects/config/db' '/home/kalpakavindu/.config/easyeffects/db'
sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/easyeffects/config/easyeffectsrc' '/home/kalpakavindu/.config/easyeffectsrc'
```

For my presets, Create a symlink to `./local` for `~/.local/share/easyeffects`

```bash
rm -rf /home/kalpakavindu/.local/share/easyeffects
sudo ln -s -n '/home/kalpakavindu/Source/dotfiles/linux/easyeffects/local' '/home/kalpakavindu/.local/share/easyeffects'
```

## Effects

These packages provides other audio effects for easyeffects.

- `linuxstudio-plugins` - Provides a range of audio effects.
- `calf-plugins` - Another set of audio processing plugins.
- `libebur128` - For auto gain and level metering.
- `zam-plugins` - For Maximizer.
- `zita-convolver` - For Convolver.
- `lv2-plugins` - For Bass loudness.
- `speexdsp` - For Speech processor.
- `soundtouch` - For Pitch shift.
- `rnnoise` - For Noise reduction.
- `deepfilternet-git`<sup>AUR</sup> - For Deep noise remover.