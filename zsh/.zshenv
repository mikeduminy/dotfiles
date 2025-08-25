#################################################################
# Base shell entrypoint                                         #
#   Loaded first in non-interactive and interactive shells      #
#################################################################


# uncomment the following line to output when this file is loaded
# echo "loading: $0"

source ~/.xdg/config/zsh/shared-env-vars.zsh

# Sometimes $PATH isn't initialised by the time this file runs, so to be able to
# use builtin functions like dirname we ensure that `/usr/bin` is in $PATH
export PATH="$PATH:/usr/bin"

# We use brew for package management on both linux and macOS so we need an
# abstraction layer to handle differences in install locations
if [[ "$OS_TYPE" = "mac" ]]; then
  export BREW_LOCATION="/opt/homebrew"
else
  export BREW_LOCATION="/home/linuxbrew/.linuxbrew"
fi

# export MIKE_DEBUG=true

# zsh needs some additional set up in the system files
# so for now keep loading this here
for file in $XDG_CONFIG_HOME/plugins/*/zsh/.zshenv; do source $file; done
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
