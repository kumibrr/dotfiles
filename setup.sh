#!/bin/sh
sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper -n --gpg-auto-import-keys dup --from packman --allow-vendor-change

# Installing Microsoft needed programs (edge must be installed for msteams)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo zypper addrepo https://packages.microsoft.com/yumrepos/edge microsoft-edge-beta
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

sudo zypper refresh

sudo zypper -n install -l microsoft-edge-beta code

# Installing github CLI
sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
sudo zypper -n --gpg-auto-import-keys ref
sudo zypper -n install gh

# Installing NVM, node
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh)"

nvm install node

# Installing tldr
npm install -g tldr

# Installing 1Password
mkdir $HOME/temp
wget -O $HOME/temp/1password.rpm https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm
sudo rpm -i $HOME/temp/1password.rpm

#Installing zsh, oh_my_zsh and oh_my_zsh plugins
sudo zypper -n install zsh git alacritty

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

chsh -s /bin/zsh

# Installing dotfiles bare git repository
git clone --bare https://github.com/kumibrr/dotfiles-linux.git $HOME/dotfiles

mv $HOME/.bashrc $HOME/.bashrc.original
mv $HOME/.zshrc $HOME/.zshrc.original
mv $HOME/.p10k.zsh $HOME/.p10k.zsh.original
chmod +x $HOME/.config/sway/layout.py
pip install i3ipc
pip install pyxdg

/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout

/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Installing sway extensions
sudo zypper -n install make
git clone https://github.com/nwg-piotr/nwg-bar.git $HOME/temp/ngwbar
cd $HOME/temp/ngwbar
sudo make install
cd $HOME

#Installing fonts
sudo wget -O /usr/share/fonts/truetype/'MesloLGS NF Regular.ttf' https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo wget -O /usr/share/fonts/truetype/'MesloLGS NF Bold.ttf' https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
sudo wget -O /usr/share/fonts/truetype/'MesloLGS NF Italic.ttf' https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo wget -O /usr/share/fonts/truetype/'MesloLGS NF Bold Italic.ttf' https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo wget -O $HOME/temp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip $HOME/temp/FiraCode.zip -d $HOME/temp/FiraCode
sudo mv $HOME/temp/FiraCode/* /usr/share/fonts/truetype/

# Commenting default opensuse wallpaper for sway

#Cleaning up
sudo rm -r $HOME/temp

# Color rojo: #CE2E42
