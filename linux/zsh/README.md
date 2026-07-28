# Setting up ZSH

Ensure Installed:
- **`zsh`**
- `zsh-autosuggestions`

## Setup
Get the path to the zsh shell.

```bash
cat /etc/shells
```

Set `zsh` as the default shell for current user.

```bash
chsh -s /bin/zsh
```

Symlink `.zshrc` and `.zprofile` to `~/.zshrc` and `~/.zprofile`.

```bash
# For user account. Here it's kalpakavindu 
ln -sf '/home/kalpakavindu/Source/dotfiles/linux/zsh/.zshrc' '/home/kalpakavindu/.zshrc'
ln -sf '/home/kalpakavindu/Source/dotfiles/linux/zsh/.zprofile' '/home/kalpakavindu/.zprofile'

# For root
sudo su
ln -sf '/home/kalpakavindu/Source/dotfiles/linux/zsh/.zshrc' '/root/.zshrc'
ln -sf '/home/kalpakavindu/Source/dotfiles/linux/zsh/.zprofile' '/root/.zprofile'
```

## Preview
![alt text](../../assets/screenshots/zsh-promts.png)