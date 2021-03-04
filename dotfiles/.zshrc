DEV=$HOME/dev
export p=$DEV/projects

export GOPATH="$DEV/tools/go"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.deno/bin"
export PATH="$PATH:$GOPATH/bin"
#export PATH="$PATH:$DEV/tools/flutter/bin"
#export PATH="$PATH:$HOME/.pub-cache/bin"
#export PATH="$PATH:$HOME/Android/Sdk/platform-tools"

export EDITOR="vim"

#===========#
# Oh My Zsh #
#===========#
export ZSH=$HOME/.oh-my-zsh

plugins=(
  command-not-found
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
alias config="nano ~/.zshrc && source ~/.zshrc"
alias copy="xclip"
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

if [ "$(command -v btm)" ]; then
  unalias -m 'top'
  alias top="btm"
fi

if [ "$(command -v bat)" ]; then
  unalias -m 'cat'
  alias cat='bat -pp --theme="Nord"'
  export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Nord'"
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
  alias ps="procs"
fi

alias git-clean="git clean -dfX"
alias git-undo="git reset --soft HEAD~1"

alias yarn-upgrade="yarn upgrade-interactive --latest"

#=========#
# Scripts #
#=========#
SCRIPTS="$HOME/.kmds/scripts"
alias inotify-consumers="run $SCRIPTS/inotify-consumers.sh"
alias mp3-tags="deno run --allow-run --unstable $SCRIPTS/mp3-tags.ts"
alias replace="deno run --allow-read --allow-write $SCRIPTS/replace.ts"
alias secrets-manager="run $SCRIPTS/secrets-manager.sh"
alias setup-rpi="deno run --allow-read --allow-write --unstable $SCRIPTS/setup-rpi.ts"
alias sync-config="run $SCRIPTS/sync-config.sh"
alias yarn-ts="deno run --allow-run --allow-net --allow-read $SCRIPTS/yarn-ts.ts"

function cdc {
  take $1
  code .
}

function ytdl {
  local OUT="$HOME/Downloads/%(title)s.%(ext)s"

  if [[ $1 = "--mp3" ]]
  then
    youtube-dl -x --audio-format "mp3" -o $OUT $2
  else
    youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" -o $OUT $1
  fi
}

function quick-mount {
  sudo mkdir /media/$USER/$2
  sudo mount $1 /media/$USER/$2
}

function quick-unmount {
  sudo umount /media/$USER/$1
  sudo rm -rf /media/$USER/$1
}

function wsl-mount {
  sudo mkdir /mnt/$1
  sudo mount -t drvfs "$1:" /mnt/$1
}

function wsl-unmount {
  sudo umount /mnt/$1
  sudo rm -rf /mnt/$1
}

function matecocido {
  echo "notify-send 'Matecocido!'" | at now + 4 minutes
}

function update-all {
  sudo pacman -Syu
  sudo pacman -Rns $(pacman -Qtdq)
  paru -Syu
  yarn global upgrade --latest
}

#========#
# Others #
#========#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# blitz autocomplete setup
BLITZ_AC_ZSH_SETUP_PATH=$HOME/.cache/@blitzjs/cli/autocomplete/zsh_setup
test -f $BLITZ_AC_ZSH_SETUP_PATH
source $BLITZ_AC_ZSH_SETUP_PATH

# When using Xorg
if [[ $(command -v startx) ]] && [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  startx
fi
