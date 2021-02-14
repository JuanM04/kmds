DEV=$HOME/dev
export p=$DEV/projects

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.deno/bin"
#export PATH="$PATH:$DEV/tools/flutter/bin"
#export PATH="$PATH:$HOME/.pub-cache/bin"
#export PATH="$PATH:$HOME/Android/Sdk/platform-tools"

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

#===========#
# Oh My Zsh #
#===========#
export ZSH=$HOME/.oh-my-zsh

plugins=(
  colored-man-pages
  command-not-found
  copyfile
  docker
  docker-compose
  git
  pip
  python
  systemd
  ubuntu
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

#=========#
# Aliases #
#=========#
alias config="nano ~/.zshrc && source ~/.zshrc && reload-scripts && sync-config"
alias copy="xclip -selection clipboard"
alias run="zsh"

function = {
  insect "$@"
}

#alias python="python3"
#alias pip="pip3"

alias organit="python3 ~p/organit/scripts/organit.py"

if [ "$(command -v exa)" ]; then
  unalias -m 'll'
  unalias -m 'l'
  unalias -m 'la'
  unalias -m 'ls'
  alias ls='exa -G  --color auto --icons -a -s type'
  alias ll='exa -l --color always --icons -a -s type'
fi

if [ "$(command -v bat)" ]; then
  unalias -m 'cat'
  alias cat='bat -pp --theme="Nord"'
fi

if [ "$(command -v rg)" ]; then
  unalias -m 'grep'
  alias grep="rg" 
fi

if [ "$(command -v fd)" ]; then
  unalias -m 'find'
  alias find="fd"
fi

if [ "$(command -v ps)" ]; then
  unalias -m 'ps'
  alias find="procs"
fi

#=========#
# Scripts #
#=========#
source $HOME/.kmds/scripts/_main.sh

#========#
# Others #
#========#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# blitz autocomplete setup
BLITZ_AC_ZSH_SETUP_PATH=$HOME/.cache/@blitzjs/cli/autocomplete/zsh_setup
test -f $BLITZ_AC_ZSH_SETUP_PATH
source $BLITZ_AC_ZSH_SETUP_PATH;