# echo "loading: $0"

## defaults
export LANG="en_US.UTF-8"
export EDITOR='nvim'

if [[ "$(command -v nvim)" ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim +Man!' # use nvim as man pager
  export MANWIDTH=999
fi

## load aliases
source $(dirname $0)/aliases.zsh
