#!/usr/bin/zsh

cd $HOME/.kmds/dotfiles

cp $HOME/.zshrc       .
cp $HOME/.gitconfig   .

cp $HOME/.config/starship.toml            .config
cp $HOME/.config/alacritty/alacritty.yml  .config/alacritty



VSCODE=".config/Code/User"

cp $HOME/$VSCODE/keybindings.json   $VSCODE/keybindings.json
cp $HOME/$VSCODE/settings.json      $VSCODE/settings.json
cp $HOME/$VSCODE/snippets/*         $VSCODE/snippets/
code --list-extensions > .config/Code/extensions.txt





cd ..
git commit -am "[sync-config] $(date +%Y-%m-%dT%H:%M:%S%z)"
git push origin main