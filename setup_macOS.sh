#!/bin/sh

# CREATING TEMP DIRECTORY
mkdir $HOME/temp

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# INSTALLING APPLICATIONS
brew install --cask balenaetcher microsoft-teams coconutbattery onedrive docker	raycast dolphin	the-unarchiver dozer	tor-browser firefox-developer-edition	visual-studio-code iterm2 vmware-fusion keepingyouawake	whatsapp macs-fan-control mpv

brew install cocoapods gh gnupg neofetch nvm pinentry vercel-cli wget

# INSTALLING NVM, NODE AND UTILITIES
nvm install node
npm install -g tldr

# INSTALLING ZSH PLUGINS
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


# INSTALLING DOTFILES BARE GIT REPOSITORY
git clone -b macos --single-branch --bare https://github.com/kumibrr/dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# INSTALLING FONTS
wget -O $HOME/temp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip $HOME/temp/FiraCode.zip -d $HOME/temp/FiraCode
mv $HOME/temp/FiraCode/*Complete.ttf $HOME/Library/Fonts/

# CLEANING UP
sudo rm -r $HOME/temp


echo "******PLEASE REMEMBER TO ADD YOUR ITERM PROFILE AND SETUP GIT******"