#################################################################
# Base shell entrypoint						# 
#   Loaded first in non-inerative and interactive shells        #
#################################################################

# uncomment the following line to output when this file is loaded
# echo "loading: $0"

# Set up base directories for custom config using XDG (Cross Desktop Group)
# standard: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="$HOME/.xdg/data"
export XDG_CONFIG_HOME="$HOME/.xdg/config"
export XDG_STATE_HOME="$HOME/.xdg/state"
export XDG_CACHE_HOME="$HOME/.xdg/cache"
export XDG_RUNTIME_DIR="$HOME/.xdg/runtime"


# Added by Toolbox App
export PATH="$PATH:~/Library/Application Support/JetBrains/Toolbox/scripts"
