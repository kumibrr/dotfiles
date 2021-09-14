# base config for oh my zsh
source /usr/share/oh-my-zsh/zshrc

# #p10k instant prompt to make terminal open a bit snappier
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/oh-my-zsh/plugins/nvm/nvm.plugin.zsh
source /usr/share/oh-my-zsh/plugins/npm/npm.plugin.zsh

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Source manjaro config
source ~/.zshrc

# fix for comment color on manjaro zsh theme
ZSH_HIGHLIGHT_STYLES[comment]='fg=blue'

# user-defined overrides
[ -d ~/.config/zsh/config.d/ ] && source ~/.config/zsh/config.d/*

# Fix for foot terminfo not installed on most servers
alias ssh="TERM=xterm-256color ssh"

# Fix vscode from terminal to enable wayland features
alias code="/opt/visual-studio-code/code --no-sandbox --new-window -enable-features=UseOzonePlatform --ozone-platform=wayland"
