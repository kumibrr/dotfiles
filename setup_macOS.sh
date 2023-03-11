#!/bin/sh

# CREATING TEMP DIRECTORY
mkdir $HOME/temp

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap homebrew/cask-versions

# INSTALLING APPLICATIONS
brew install --cask balenaetcher coconutbattery docker the-unarchiver firefox visual-studio-code iterm2 keepingyouawake macs-fan-control mpv

brew install cocoapods gh gnupg fastfech volta pinentry vercel-cli wget

# INSTALLING NVM, NODE AND UTILITIES
volta install node
volta install corepack
volta install tldr
volta install @angular/cli
pnpm setup

# INSTALLING ZIMFW
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# INSTALLING DOTFILES BARE GIT REPOSITORY
git clone -b macOS --single-branch --bare https://github.com/kumibrr/dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# INSTALLING FONTS
wget -O $HOME/temp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip $HOME/temp/FiraCode.zip -d $HOME/temp/FiraCode
mkdir $HOME/temp/meslo
wget -O $HOME/temp/meslo/MesloLGS%20NF%20Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -O $HOME/temp/meslo/MesloLGS%20NF%20Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -O $HOME/temp/meslo/MesloLGS%20NF%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -O $HOME/temp/meslo/MesloLGS%20NF%20Bold%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

mv $HOME/temp/FiraCode/*Complete.ttf $HOME/Library/Fonts/
mv $HOME/temp/meslo/*.ttf $HOME/Library/Fonts/


# CLEANING UP
rm -r $HOME/temp

echo "******OPEN A NEW TERMINAL AND RUN 'zimfw install******"
echo "******PLEASE REMEMBER TO ADD YOUR ITERM PROFILE AND SETUP GIT******"
