#!/usr/bin/zsh

cd $HOME/.kmds/dotfiles

cp $HOME/.zshrc       .
cp $HOME/.gitconfig   .

cp    $HOME/.config/starship.toml   .config/
cp -r $HOME/.config/alacritty       .config/
cp -r $HOME/.config/qtile           .config/
cp -r $HOME/.config/dunst           .config/
cp -r $HOME/.config/rofi            .config/
cp -r $HOME/.config/systemd         .config/



VSCODE=".config/Code/User"

cp $HOME/$VSCODE/keybindings.json   $VSCODE/keybindings.json
cp $HOME/$VSCODE/settings.json      $VSCODE/settings.json
cp $HOME/$VSCODE/snippets/*         $VSCODE/snippets/
code --list-extensions > .config/Code/extensions.txt





cd ..

if [ -z "$(git status -s)" ]; then
  echo "There are no changes"
  exit 0
fi

git add .

if [ -z "$1" ]; then
  git commit -m "[sync-config] $(date +%Y-%m-%dT%H:%M:%S%z)"
else
  git commit -m "$1"
fi

git push origin main