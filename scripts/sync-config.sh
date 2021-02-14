#!/usr/bin/zsh

DOTFILES=$HOME/.kmds/dotfiles

cp $HOME/.zshrc       $DOTFILES
cp $HOME/.gitconfig   $DOTFILES

cp $HOME/.config/starship.toml            $DOTFILES/.config
cp $HOME/.config/alacritty/alacritty.yml  $DOTFILES/.config/alacritty



VSCODE=".config/Code/User"

cp $HOME/$VSCODE/keybindings.json   $DOTFILES/$VSCODE/keybindings.json
cp $HOME/$VSCODE/settings.json      $DOTFILES/$VSCODE/settings.json
cp $HOME/$VSCODE/snippets/*         $DOTFILES/$VSCODE/snippets/
code --list-extensions > $DOTFILES/.config/Code/extensions.txt





cd $HOME/.kmds
git commit -am "[sync-config] $(date +%Y-%m-%dT%H:%M:%S%z)"
git push origin main