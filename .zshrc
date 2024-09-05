setopt prompt_subst

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export TERMINAL='alacritty'
export NVM_DIR="$HOME/.nvm"
export GDK_BACKEND='x11'

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Custom Prompt
local PR_USER PR_USER_OP PR_PROMPT PR_HOST

if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
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
  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  local git_status=$(git status --porcelain 2>/dev/null)
  if echo "$git_status" | grep -q "^ M"; then
    branch="${branch}*"
  fi
  if echo "$git_status" | grep -qE "^ A|^\?\?"; then
    branch="${branch}+"
  fi
  if echo "$git_status" | grep -q "^ D"; then
    branch="${branch}-"
  fi

  if [[ -n "$branch" ]]; then
    branch="%F{yellow}<${branch}>%F{reset}"
  fi
  echo "$branch"
}

local return_code="%(?..%F{red}%? ↵%f)"
local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"

update_prompt(){
  PROMPT="╭─${user_host} ${current_dir} $(parse_git_branch)
╰─$PR_PROMPT "
}
precmd_functions+=(update_prompt)
update_prompt

RPROMPT="${return_code}"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
