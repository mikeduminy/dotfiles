# echo "loading: $0"

## defaults
export LANG="en_US.UTF-8"
export EDITOR='nvim'

if [[ "$(command -v nvim)" ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim +Man!' # use nvim as man pager
  export MANWIDTH=999
fi

export PROJECT_ROOTS="$HOME/Source:$PROJECT_ROOTS"
export PROJECT_FOLDERS="$XDG_CONFIG_HOME:$PROJECT_FOLDERS"

# Completions
[ -s ~/.bun/_bun ] && source ~/.bun/_bun
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## load utils
source $(dirname $0)/utils.zsh

## load aliases
source $(dirname $0)/aliases.zsh
