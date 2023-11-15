# Conditionally log if MIKE_DEBUG is set
[[ ! -z $MIKE_DEBUG ]] && echo "loading: $0"

source $(dirname $0)/paths.zsh
