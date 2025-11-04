#################################################################
# Shell file loaded in interactive shells                       #
# .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout         #
#                         ^^^^^^                                #
#################################################################

export LANG=en_US.UTF-8

if [ -n "$PROFILE_SHELL" ]; then
  # start profiling
  zmodload zsh/zprof
fi


if [ -z "$HOME_BREW_PREFIX" ]; then
  # avoid loading homebrew multiple times
  eval "$(/opt/homebrew/bin/brew shellenv)"
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

# oh-my-zsh plugins
plugins=(
  yarn
)

## Plugin configuration - start
zstyle ':omz:plugins:yarn' global-path no

zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh

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
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

#################################################################
# Custom config                                                 #
#################################################################

# Load additional custom zsh stuff
for file in $XDG_CONFIG_HOME/plugins/*/zsh/.zshrc; do source $file; done

# Setup wezterm (must be after loading nested zshrcs)
source $XDG_CONFIG_HOME/wezterm/init.zsh

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"



# only source if the file exists
[ -f ~/.keprc ] && source ~/.keprc

if [ -n "$PROFILE_SHELL" ]; then
  # stop profiling
  zprof
fi

export PATH=$HOME/.local/bin:$PATH
