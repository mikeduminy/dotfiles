# Conditionally log if MIKE_DEBUG is set
[[ ! -z $MIKE_DEBUG ]] && echo "loading: $0"

eval "$(/opt/homebrew/bin/brew shellenv)"
