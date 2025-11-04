# Set up base directories for custom config using XDG (Cross Desktop Group)
# standard: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="$HOME/.xdg/data"
export XDG_CONFIG_HOME="$HOME/.xdg/config"
export XDG_STATE_HOME="$HOME/.xdg/state"
export XDG_CACHE_HOME="$HOME/.xdg/cache"
export XDG_RUNTIME_DIR="$HOME/.xdg/runtime"

# detect OS type
UNAME_S="$(uname -s)"
case "$UNAME_S" in
Darwin)
  export OS="mac"
  ;;
CYGWIN* | MINGW* | MSYS*)
  export OS="windows"
  ;;
*)
  if [[ -f "/etc/debian_version" ]]; then
    export OS="linux"
    export OS_BASE="debian"
  elif [[ -f "/etc/arch-release" ]]; then
    export OS="linux"
    export OS_BASE="arch"
  elif [[ -f "/etc/fedora-release" ]]; then
    export OS="linux"
    export OS_BASE="fedora"
  elif [[ -f "/etc/alpine-release" ]]; then
    export OS="linux"
    export OS_BASE="alpine"
  else
    export OS="unknown"
    echo "Warning: Could not detect OS type"
    exit 1
  fi
  ;;
esac
