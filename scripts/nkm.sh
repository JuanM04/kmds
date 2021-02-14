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

PACKAGES="git zsh gnupg2 python3 python3-pip curl wget imagemagick ffmpeg apt-transport-https ca-certificates software-properties-common dirmngr libgit2-dev libssh2-dev openssl-dev"

# Checks if i'm in a Debian-based distro
if [ ! "$(command -v apt)" ]; then
  echo "This ditro isn't Debian-based. Make sure to install: "
  echo "$PACKAGES"
  exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt install $PACKAGES -y
pip3 install -U youtube-dl





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
yarn global add blitz degit serve vercel





nicelog "🖤 Installing Deno..."

run-remote https://deno.land/x/install/install.sh
export PATH="$PATH:/$HOME/.deno/bin"





nicelog "🦀 Installing Rust..."

run-remote https://sh.rustup.rs
source $HOME/.cargo/env





nicelog "🦀 Installing Rust binaries (including, but no limited to, Alacritty, Starship, Cargo Update)..."

cargo install alacritty bat cargo-update exa fd-find git-delta procs ripgrep starship





nicelog "🐋 Installing Docker..."

if [$(command -v lsb_release)]; then
  wget -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable"
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker ${USER}
else
  echo "\`lsb_release\` is missing"
fi





nicelog "🐱 Installing GitHub CLI..."

wget -O gh.deb https://github.com/cli/cli/releases/download/v1.5.0/gh_1.5.0_linux_amd64.deb
sudo apt install ./gh.deb -y
rm gh.deb
sudo apt update
sudo apt upgrade -y





nicelog "💻 Zsh and Oh My ZSH!"

chsh -s /usr/bin/zsh
run-remote https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

ZSH_PLUGINS=".oh-my-zsh/custom/plugins"
mkdir -p ${ZSH_PLUGINS}/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting





nicelog "🅿️ FiraCode Nerd Font"

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
mkdir -p ${HOME}/.fonts/
unzip FiraCode.zip -d ${HOME}/.fonts/
rm FiraCode.zip
fc-cache -fv





nicelog "📝 Installing VSCode..."

wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install ./code.deb -y
rm code.deb

for extension in $(cat dotfiles/.config/Code/extensions.txt)
do
  code --install-extension $extension
done





nicelog "📜 Applying dotfiles..."

cp -rT dotfiles $HOME/
sudo sh -c "cat us-jm >> /usr/share/X11/xkb/symbols/us"
mkdir -p ${HOME}/dev/{projects,misc,tests,tools}










echo "\\n\\n"
echo "=================================================="
echo "\\nNEW KILLING MACHINE SET UP\\n"
echo "=================================================="
echo ""
read -p "Press [Enter] to use this new ship..."

/usr/bin/zsh