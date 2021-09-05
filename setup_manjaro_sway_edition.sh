#!bin/sh

# CREATING TEMP DIRECTORY
mkdir $HOME/temp

# INSTALLING APPLICATIONS

sudo pacman -S --noconfirm pamac mpv
sudo pamac install --no-confirm code
sudo pamac build --no-confirm code-marketplace
sudo pamac build --no-confirm microsoft-edge-beta

curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
cd $HOME/temp
git clone https://aur.archlinux.org/1password.git
cd 1password
makepkg -si --noconfirm
cd

# INSTALLING NVM, NODE AND UTILITIES

sh -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh)"
nvm install node
npm install tldr
sudo pamac build --no-confirm angular-cli vercel
# INSTALLING ZSH CONFIGS

mv .config/zsh/.zshrc .config/zsh/.zshrc.backup

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# INSTALLING FONTS

sudo wget -O $HOME/temp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip $HOME/temp/FiraCode.zip -d $HOME/temp/FiraCode
sudo mv $HOME/temp/FiraCode/* /usr/share/fonts/TTF/

# CLEANING UP
sudo rm -r $HOME/temp
