# Linux Configuration Files

My configurations on Linux.

System info:
```
OS: Arch Linux x86_64
Kernel: Linux 7.1.4-arch1-1
Shell: zsh
Locale: en_US.UTF-8
```

## Audio
I configured audio with `pipewire`. Install these packages to get started.

- `pipewire`
- `pipewire-pulse`
- `pipewire-alsa`
- `wireplumber`

## Gnome Keyring
Install `gnome-keyring`, `libsecret` and `seahorse`.

To setup auto unlock at login. Edit `/etc/pam.d/login` file.

Append this line at the end of the `auth` section.
```txt
auth       optional     pam_gnome_keyring.so
```

Append this line at the end of the `session` section
```txt
session    optional     pam_gnome_keyring.so auto_start
```

For window managers, to set environment variables,
```bash
export (gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export XDG_CURRENT_DESKTOP=GNOME
```

To verify keyring daemon integration run,
```bash
busctl --user tree org.freedesktop.secrets
```

## Software

- [`visual-studio-code-bin`<sup>AUR</sup>](./vscode/README.md)
- [`nautilus`](./nautilus/README.md)
- [`zsh`](./zsh/README.md)
- [`alacritty`](./alacritty/README.md)
- [`easyeffects`](./easyeffects/README.md)
- [`fastfetch`](./fastfetch/README.md)

## Other configurations

### Hiding Windows Drive in File Managers
I hide Windows Drive in my main hard drive through adding a new rule for `udev`. This prevents me from accidentally accessing it from portable drive which will maybe lead to data corruption from Windows side. To add the rule,

```bash
sudo nano /etc/udev/rules.d/99-hide-partitions.rules
```
then write this line by replacing `<UUID>` with the UUID of the Windows Drive,

```txt
ENV{ID_FS_UUID}=="<UUID>", ENV{UDISKS_IGNORE}="1"
```

Then save and reload the rules using this command.

```bash
sudo udevadm control --reload-rules && sudo udevadm trigger
```