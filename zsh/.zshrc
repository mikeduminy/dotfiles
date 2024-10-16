if [ -n "$PROFILE_SHELL" ]; then
  # start profiling
  zmodload zsh/zprof
fi

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
  ZSH="$ZSH" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# oh-my-zsh cache
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"

# Location for custom plugins (oh-my-zsh adds "/plugins")
export ZSH_CUSTOM="$XDG_DATA_HOME"

# Install zsh-vi-mode
if [ ! -d $ZSH_CUSTOM/plugins/zsh-vi-mode ]; then
  echo "Installing zsh-vi-mode..."
  git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode > /dev/null
  echo "Done."
  # TODO: periodically check for updates or switch to a plugin manager
fi

# oh-my-zsh plugins
plugins=(
  git
  yarn
  zsh-vi-mode
)

## Plugin configuration - start
### zsh-vi-mode
function rebindHistorySearch () {
  # manually set this because zsh-vi-mode overrides it
  bindkey -M viins '^R' fzf-history-widget
}

zvm_after_init_commands=(rebindHistorySearch)
ZVM_VI_EDITOR=nvim
ZVM_VI_SURROUND_BINDKEY=s-prefix
ZVM_VI_HIGHLIGHT_FOREGROUND=#c8d3f5
ZVM_VI_HIGHLIGHT_BACKGROUND=#2d3f76
ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline

# drastically speed up vi mode
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=false

### yarn
zstyle ':omz:plugins:yarn' global-path no

## Plugin configuration - end

source $ZSH/oh-my-zsh.sh

#################################################################
# Custom config                                                 #
#################################################################

# Load additional custom zsh stuff
for file in $XDG_CONFIG_HOME/plugins/*/zsh/.zshrc; do source $file; done

#################################################################
# Theme                                                         #
#################################################################

base16_shell_path="$XDG_DATA_HOME/base16-shell/base16-shell.plugin.zsh"
if [ -e "$base16_shell_path" ]; then
  export BASE16_THEME_DEFAULT="tomorrow-night"
  export BASE16_CONFIG_PATH="$XDG_DATA_HOME/base16-project"
  source "$XDG_DATA_HOME/base16-shell/base16-shell.plugin.zsh"
fi
unset base16_shell_path

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

# Setup wezterm
source $XDG_CONFIG_HOME/wezterm/init.zsh

# only load brew shellenv if it is not loaded, check for the presence of HOMEBREW_PREFIX
if [ -z "$HOME_BREW_PREFIX" ]; then
  eval "$('/opt/homebrew/bin/brew' shellenv)"
fi

source ~/.keprc

if [ -n "$PROFILE_SHELL" ]; then
  # stop profiling
  zprof
fi
