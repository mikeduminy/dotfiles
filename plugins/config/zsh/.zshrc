# Conditionally log if MIKE_DEBUG is set
[[ ! -z $MIKE_DEBUG ]] && echo "loading: $0"

## defaults
export LANG="en_US.UTF-8"
export EDITOR='nvim'

if [[ "$(command -v nvim)" ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim +Man!' # use nvim as man pager
  export MANWIDTH=999
fi

if [[ $PROJECT_ROOTS != *"$HOME/Source:"* ]]; then
  export PROJECT_ROOTS="$HOME/Source:$PROJECT_ROOTS"
fi

if [[ $PROJECT_FOLDERS != *"$XDG_CONFIG_HOME:"* ]]; then
  export PROJECT_FOLDERS="$XDG_CONFIG_HOME:$PROJECT_FOLDERS"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

[ -s ~/.bun/_bun ] && source ~/.bun/_bun

if type zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

## FZF options
export FZF_COMPLETION_OPTS='--border --info=inline'
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
eval "$(fzf --zsh)"

# bun completions
[ -s "/Users/michael-james.duminy/.bun/_bun" ] && source "/Users/michael-james.duminy/.bun/_bun"

## load paths
source $(dirname $0)/paths.zsh

## load utils
source $(dirname $0)/utils.zsh

## load aliases
source $(dirname $0)/aliases.zsh
