# Conditionally log if MIKE_DEBUG is set
[[ ! -z $MIKE_DEBUG ]] && echo "loading: $0"

if [ -z "$HOME_BREW_PREFIX" ]; then
  # avoid loading homebrew multiple times
  eval "$('/opt/homebrew/bin/brew' shellenv)"
fi
