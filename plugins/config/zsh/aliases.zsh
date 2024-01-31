# General stuff
alias zrc="source ~/.zshrc"
alias config="$EDITOR $XDG_CONFIG_HOME" 
alias configdir="cd $XDG_CONFIG_HOME"

source $(dirname $0)/git/index.zsh

alias open_file_descriptors="sudo lsof -n | cut -f1 -d' ' | uniq -c | sort | tail"
alias lg="lazygit"

alias vi="nvim"
alias vim="nvim"
alias vih="nvim ." # open nvim in current directory

alias select-project=$(dirname $0)/select_project.zsh
alias sp=select-project

alias cd="z"
alias cat="bat"
alias ls="eza"
alias procs="procs --load-config $XDG_CONFIG_HOME/procs/config.toml"
