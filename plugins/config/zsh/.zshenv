# Conditionally log if MIKE_DEBUG is set
[[ ! -z $MIKE_DEBUG ]] && echo "loading: $0"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
