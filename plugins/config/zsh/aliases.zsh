# General stuff
alias zrc="source ~/.zshrc"
alias config="$EDITOR $XDG_CONFIG_HOME" 
alias configdir="cd $XDG_CONFIG_HOME"

source $(dirname $0)/git/index.zsh

alias open_file_descriptors="sudo lsof -n | cut -f1 -d' ' | uniq -c | sort | tail"

# editor
alias vi="nvim" # use neovim as default editor
alias vim="nvim"
alias vih="nvim ." # open nvim in current directory

alias lg="lazygit"
# open lazygit focusing on a specific path
alias lgf="lazygit --filter"

# project switching
alias select-project=$(dirname $0)/select_project.zsh
alias sp=select-project

alias cd="z" # z is a better cd (zoxcide)
alias cat="bat" # bat is a better cat (sharkdp/bat)
alias ls="eza --all --group-directories-first --icons" # eza is a better ls (eza-community/eza)
alias procs="procs --load-config $XDG_CONFIG_HOME/procs/config.toml"
