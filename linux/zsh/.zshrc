#!/usr/bin/zsh
# Written by KalpaKavindu <kalpadevonline@gmail.com>

setopt prompt_subst

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export ZSH="/usr/share/zsh"
export LANG="en_US.UTF-8"
export EDITOR="code"
export TERMINAL="alacritty"
export GDK_BACKEND="wayland,x11"
export GPG_TTY=$(tty)

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%F{green}➤%f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤%f'
fi

if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then # SSH
  PR_HOST='%F{red}%M%f'
else # no SSH
  PR_HOST='%F{green}%m%f'
fi

local return_code="%(?..%F{red}%? ↵%f)"
local user_host="${PR_USER}%F{cyan}@%F{reset}${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"

update_prompt(){
  PROMPT="%F{green}╭─(%F{reset}${user_host}%F{green})%F{reset} ${current_dir}
%F{green}╰─%F{green}$PR_PROMPT "
}
precmd_functions+=(update_prompt)
update_prompt

RPROMPT="${return_code}"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias list-wifi='nmcli -f "IN-USE,BARS,RATE,SECURITY,SSID" dev wifi'

source ${ZSH}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
