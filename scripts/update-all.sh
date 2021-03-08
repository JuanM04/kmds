#!/usr/bin/zsh

# Sync config
zsh "$HOME/.kmds/scripts/sync-config.sh"

# Sync Obsidian
VAULTS=("Personal Workspace")

for vault in $VAULTS; do
  cd "$HOME/Documents/Obsidian Vaults/$vault"

  if [ -z "$(git status -s)" ]; then
    echo "There are no changes in $vault"
  else
    git add .
    git commit -m "[sync-obsidian] $(date +%Y-%m-%dT%H:%M:%S%z)"
    git push origin main
  fi
done

# Update dependencies
sudo pacman -Syu
sudo pacman -Rns $(pacman -Qtdq)
paru -Syu --ignore ttf-google-fonts-git
yarn global upgrade --latest