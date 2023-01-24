# echo "loading: $0"

## defaults
export LANG="en_US.UTF-8"
export EDITOR='nvim'

# xdg stuff
# export ASDF_DATA_DIR="${XDG_DATA_HOME}"/asdf
# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
# export HISTFILE="$XDG_STATE_HOME"/zsh/history

if [[ "$(command -v nvim)" ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim +Man!' # use nvim as man pager
  export MANWIDTH=999
fi

## load aliases
source $(dirname $0)/aliases.zsh
