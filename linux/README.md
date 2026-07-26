# Linux Configuration Files

My configurations on Linux.

System info:
```
OS: 
Kernel: 
Shell: zsh
Locale: en_US.UTF-8
```

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

## Pre configuration
Install `less` for view pagers in other tools.

## Software

- [`visual-studio-code-bin`<sup>AUR</sup>](./vscode/README.md)
- [`nautilus`](./nautilus/README.md)
- [`zsh`](./zsh/README.md)
- [`alacritty`](./alacritty/README.md)