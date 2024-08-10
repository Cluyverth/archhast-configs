# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=15000
SAVEHIST=15000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/byakkott/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"
fastfetch

alias SC='~/Documents/CarlaProject/start_carla.sh'
alias doc='cd ~/Documents'
alias down='cd ~/Downloads'
function goto() {
  cd "$1" && ls
}
