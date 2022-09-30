#################################################################
# Interactive shell entrypoint                                  #
#################################################################

export ZSH="$XDG_DATA_HOME/oh-my-zsh"

#################################################################
# oh-my-zsh setup                                               #
#################################################################

# Conditionally install oh-my-zsh if it's missing
if [ ! -d $ZSH ]; then
  # Specifying the ZSH env variable informs oh-my-zsh where to install
  # https://github.com/ohmyzsh/ohmyzsh/issues/9543#issuecomment-1045984890
  ZSH="$ZSH" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# oh-my-zsh cache
export ZDOTDIR="$XDG_CACHE_HOME"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"

# Location for custom plugins (oh-my-zsh adds "/plugins")
export ZSH_CUSTOM="$XDG_DATA_HOME"

# oh-my-zsh theme
ZSH_THEME="robbyrussell"

# oh-my-zsh plugins
plugins=(git vi-mode history-substring-search zsh-navigation-tools)

# vi-mode options
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

source $ZSH/oh-my-zsh.sh

#################################################################
# Custom config                                                 #
#################################################################

# Load additional custom zsh stuff
for file in $XDG_CONFIG_HOME/custom/*/.zshrc; do source $file; done

#################################################################
# Theme                                                         #
#################################################################

base16_shell_path="$XDG_DATA_HOME/base16-shell/base16-shell.plugin.zsh"
if [ -e "$base16_shell_path" ]; then
  export BASE16_THEME_DEFAULT="tokyo-city-dark"
  export BASE16_CONFIG_PATH="$XDG_DATA_HOME/base16-project"
  source "$XDG_DATA_HOME/base16-shell/base16-shell.plugin.zsh"
fi
unset base16_shell_path
