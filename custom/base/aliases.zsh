# General stuff
alias zrc="source ~/.zshrc"
alias config="$EDITOR $XDG_CONFIG_HOME" 
alias configdir="cd $XDG_CONFIG_HOME"

source $(dirname $0)/git/index.zsh

alias open_file_descriptors="sudo lsof -n | cut -f1 -d' ' | uniq -c | sort | tail"
