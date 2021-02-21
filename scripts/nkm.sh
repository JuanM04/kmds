#!/bin/bash

#  ———————————————————————————————————————————————————————————————————————————
#  New Killing Machine
#  ———————————————————————————————————————————————————————————————————————————

echo "
 _   _ _  ____  __
| \ | | |/ |  \/  |
|  \| | ' /| |\/| |
| |\  | . \| |  | |
|_| \_|_|\_|_|  |_|
"





# Utilities

function nicelog() {
  echo -e "\n\n$1"
  echo "=================================================="
}

function run-remote() {
  wget -O - $1 | bash
}





nicelog "🔐 Enter password"

sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &





nicelog "📦 Installing Packages..."

if [ "$(command -v apt)" ]; then
  DISTRO="debian"
elif [ "$(command -v pacman)" ]; then
  DISTRO="arch"
else
  echo "This ditro isn't supported. Make sure to install git, zsh, gpg, python3, curl, wget, imagemagick, ffmpeg, libgit2, libssh2, openssl, and other distro-specific dependencies"
  exit 1
fi

if [ $DISTRO = "debian" ]; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git zsh gnupg2 python3 python3-pip curl wget at imagemagick ffmpeg apt-transport-https ca-certificates software-properties-common lsb_release libgit2-dev libssh2-dev openssl-dev
elif [ $DISTRO = "arch" ]; then
  sudo pacman -Syu
  sudo pacman -S --needed --noconfirm git zsh gnupg python python-pip curl wget at zip unzip imagemagick ffmpeg base-devel libgit2 libssh2 openssl
fi

pip install -U youtube-dl psutil





nicelog "📂 Getting KMDS files..."

cd $HOME
git clone https://github.com/JuanM04/kmds.git .kmds
cd .kmds





nicelog "💚 Installing NVM and latest Node version..."

run-remote https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install node
npm install --global yarn
yarn global add blitz degit insect serve vercel
blitz autocomplete





nicelog "🦀 Installing Rust..."

if [ $DISTRO = "debian" ]; then
	run-remote https://sh.rustup.rs
  source $HOME/.cargo/env
elif [ $DISTRO = "arch" ]; then
	sudo pacman -S rust
fi





nicelog "🦀 Installing Rust binaries (including, but no limited to, Alacritty, Starship, Cargo Update)..."

cargo install alacritty bat bottom cargo-update exa fd-find git-delta procs ripgrep starship

if [ $DISTRO = "arch" ]; then
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
  rm -rf paru
fi





nicelog "🖤 Installing Deno..."

run-remote https://deno.land/x/install/install.sh
export PATH="$PATH:/$HOME/.deno/bin"





nicelog "🐋 Installing Docker..."

if [ $DISTRO = "debian" ]; then
  wget -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable"
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io
elif [ $DISTRO = "arch" ]; then
  sudo pacman -S docker docker-compose
fi

sudo usermod -aG docker ${USER}





nicelog "🐱 Installing GitHub CLI..."

if [ $DISTRO = "debian" ]; then
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
  sudo apt-add-repository https://cli.github.com/packages
  sudo apt update
  sudo apt install gh
elif [ $DISTRO = "arch" ]; then
  sudo pacman -S github-cli
fi





nicelog "💻 Zsh and Oh My ZSH!"

chsh -s /usr/bin/zsh
run-remote https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

ZSH_PLUGINS="${HOME}/.oh-my-zsh/custom/plugins"
mkdir -p ${ZSH_PLUGINS}/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting





nicelog "🅿️ FiraCode Nerd Font"

if [ $DISTRO = "debian" ]; then
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
  mkdir -p ${HOME}/.local/share/fonts
  unzip FiraCode.zip -d ${HOME}/.local/share/fonts
  rm FiraCode.zip
  fc-cache -fv
elif [ $DISTRO = "arch" ]; then
  paru -S nerd-fonts-fira-code
fi





nicelog "📝 Installing VSCode..."

if [ $DISTRO = "debian" ]; then
  wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo apt install ./code.deb -y
  rm code.deb
elif [ $DISTRO = "arch" ]; then
  paru -S visual-studio-code-bin
fi

for extension in $(cat dotfiles/.config/Code/extensions.txt)
do
  code --install-extension $extension
done





nicelog "📜 Applying dotfiles..."

cp -rT dotfiles $HOME/
sudo cp jm-keyboard /usr/share/X11/xkb/symbols
mkdir -p ${HOME}/dev/{projects,misc,tests,tools}

if [ "$(command -v localectl)" ]; then
  localectl set-x11-keymap jm-keyboard
fi










echo "


==================================================

NEW KILLING MACHINE SET UP

==================================================
"
read -p "Press [Enter] to use this new ship..."

/usr/bin/zsh
