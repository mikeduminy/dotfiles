# Set up base directories for custom config using XDG (Cross Desktop Group)
# standard: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="$HOME/.xdg/data"
export XDG_CONFIG_HOME="$HOME/.xdg/config"
export XDG_STATE_HOME="$HOME/.xdg/state"
export XDG_CACHE_HOME="$HOME/.xdg/cache"
export XDG_RUNTIME_DIR="$HOME/.xdg/runtime"

if [[ $(uname -s) == "Darwin"* ]]; then
  export OS_TYPE="mac"
elif [ -s "/etc/debian_version" ]; then
  # ubuntu, kali, popos, linuxmint, etc
  export OS_TYPE="debian"
# elif [ -s "/etc/arch-release" ]; then
#   export OS_TYPE="arch"
# elif [ -s "/etc/fedora-release" ]; then
#   export OS_TYPE="fedora"
# elif [ -s "/etc/alpine-release" ]; then
#   export OS_TYPE="alpine"
# elif [[ "$(uname -s)" == CYGWIN* || "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]]; then
#   export OS_TYPE="windows"
# else
#   export OS_TYPE="unknown"
fi
