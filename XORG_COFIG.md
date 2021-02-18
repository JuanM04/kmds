# How to use my Xorg WM

> All packages are from `pacman`. Make sure to use the correct package manager.

1. Install all
```bash
sudo pacman -S xorg xorg-xinit qtile nitrogen picom dunst rofi
paru -S nerd-fonts-hack escrotum-git
```

2. Copy the xinit file
```bash
cp /etc/X11/xinit/xinitrc .xinitrc
```

3. Modify the lasts lines from `.xinitrc`
```diff
+ xrandr --output HDMI-0 --mode "1920x1080" --rate 144
+ setxkbmap -layout jm-keyboard

twm &
- xclock -geometry 50x50-1+1 &
- xterm -geometry 80x50+494+51 &
- xterm -geometry 80x20+494-0 &
- exec xterm -geometry 80x66+0+0 -name login
+ exec qtile
```

4. Run `startx`

### Optional

- Install [`ttf-google-fonts-git`](https://aur.archlinux.org/packages/ttf-google-fonts-git/)