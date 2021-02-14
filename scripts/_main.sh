#!/usr/bin/zsh

SCRIPTS=$HOME/.kmds/scripts

function reload-scripts {
  source $SCRIPTS/_main.sh
}

function edit-scripts {
  nano $SCRIPTS/_main.sh
  reload-scripts
}

function notify {
  if [[ -z $1 ]]; then
    notify-send 'Finished!'
  else
    notify-send "Finished \"$1\""
  fi
}

function sync-config {
  run $SCRIPTS/sync-config.sh
}

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

function yarn-ts {
  deno run --allow-run --allow-net --allow-read $SCRIPTS/yarn-ts.ts $@
}

function replace {
  deno run --allow-read --allow-write $SCRIPTS/replace.ts $@
}

function inotify-consumers {
  run $SCRIPTS/inotify-consumers.sh
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
