# General stuff
alias zrc="source ~/.zshrc"
alias config="$EDITOR $XDG_CONFIG_HOME" 
alias configdir="cd $XDG_CONFIG_HOME"

# install brew packages from Brewfile
alias brewup="brew bundle --file $XDG_CONFIG_HOME/Brewfile"
brew() {
  # intercept brew unlock command to remove lock files
  if [ "$1" = "unlock" ]; then
    rm -rf "$(brew --prefix)/var/homebrew/locks"
    echo "Forcefully removed all brew locks"
  else
    command brew "$@"
  fi
}

# load git aliases
source $(dirname $0)/git/index.zsh

# count open file descriptors
alias open_file_descriptors="sudo lsof -n | cut -f1 -d' ' | uniq -c | sort | tail"

# editor
alias vi="nvim" # use neovim as default editor
alias vim="nvim"
alias vih="nvim ." # open nvim in current directory

# lazygit
alias lg="lazygit"
alias gg="lazygit"
alias lgf="lazygit --filter" # open lazygit focusing on a specific path

## load utils
source $(dirname $0)/utils.zsh

# project switching
alias select-project=$(dirname $0)/select_project.zsh
alias sp=select-project

alias cd="z" # z is a better cd (zoxide)
alias cat="bat" # bat is a better cat (sharkdp/bat)
alias ls="eza --all --group-directories-first --icons" # eza is a better ls (eza-community/eza)
alias procs="procs --load-config $XDG_CONFIG_HOME/procs/config.toml"

# Move a file or folder to the trash
quick_rm () {
  BASENAME=${1##*/}
  if [ -d $1 ]; then
    mv "$1" "${HOME}/.Trash/${BASENAME}-${RANDOM}"
  fi
}
