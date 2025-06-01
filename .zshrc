setopt prompt_subst

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="/usr/share/zsh"
export LANG=en_US.UTF-8
export EDITOR='code'
export TERMINAL='alacritty'
export GDK_BACKEND='x11'
export ELECTRON_TRASH=trash-cli code

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Custom Prompt
local PR_USER PR_USER_OP PR_PROMPT PR_HOST

if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%F{green}➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%m%f' # no SSH
fi

parse_git_branch() {
  local branch=""
  local s=" "
  local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  local git_status=$(git status --porcelain 2>/dev/null)
  
  if echo "$git_status" | grep -qE "^M|^ M"; then
    s="${s}%F{yellow}󰓏%F{reset}"
  fi

  if echo "$git_status" | grep -qE "^A|^\?\?"; then
    s="${s}%F{blue}󰐗%F{reset}"
  fi
  
  if echo "$git_status" | grep -q "^ D"; then
    s="${s}%F{red}󰍶%F{reset}"
  fi

  if [[ "$s" == " " ]]; then
    s=""
  fi

  if [[ -n "$branch" ]]; then
    branch="%F{yellow}<${branch}%F{reset}${s}%F{yellow}>%F{reset}"
  fi
  echo "$branch"
}

local return_code="%(?..%F{red}%? ↵%f)"
local user_host="${PR_USER}%F{cyan}@%F{reset}${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"

update_prompt(){
  PROMPT="%F{green}╭─(%F{reset}${user_host}%F{green})%F{reset} $(parse_git_branch) ${current_dir}
%F{green}╰─%F{green}$PR_PROMPT "
}
precmd_functions+=(update_prompt)
update_prompt

RPROMPT="${return_code}"

source ${ZSH}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh