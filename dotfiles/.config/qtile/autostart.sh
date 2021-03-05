#!/usr/bin/zsh

picom &
nitrogen --restore &
dunst &

if [ "$(command -v discord)" ]; then
  discord &
fi
if [ "$(command -v telegram-desktop)" ]; then
  telegram-desktop &
fi
if [ "$(command -v brave)" ]; then
  brave &
fi
