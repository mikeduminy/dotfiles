#################################################################
# Base shell entrypoint, loaded in all modes of zsh             #
# .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout         #
# ^^^^^^^                                                       #
#################################################################

# uncomment the following line to output when this file is loaded
# echo "loading: $0"
# Drop any inherited FPATH (e.g. stale tmux server env pointing at a removed
# Homebrew zsh Cellar version). Homebrew zsh's compiled-in default fpath omits
# the dir with compinit/add-zsh-hook/colors/etc, so re-add it explicitly
# instead of relying on it coming back on its own.
unset FPATH
typeset -U fpath
fpath=(/opt/homebrew/share/zsh/functions $fpath)

# Sometimes $PATH isn't initialised by the time this file runs, so to be able to
# use builtin functions like dirname we ensure that `/usr/bin` is in $PATH
export PATH="$PATH:/usr/bin"

# Load shared environment variables
script_source="$HOME/.zshenv"
if [[ -f "${BASH_SOURCE:-}" ]]; then
  script_source="${BASH_SOURCE}"
elif [[ -n "$ZSH_EVAL_CONTEXT" ]]; then
  # Zsh specific way to get the current script file
  script_source="${(%):-%N}"
fi
if [[ -z "$script_source" ]]; then
  # fallback to default location
  script_source="$HOME/.zshenv"
fi

script_dir=$(dirname "$(realpath "$script_source")")
shared_env="$(realpath "$script_dir/../setup/shared-env-vars.sh")"
source "$shared_env"

source "$XDG_CONFIG_HOME/zsh/lib/zshenv.zsh"
if [ -f "$XDG_CONFIG_HOME/zsh/priv/zshenv.zsh" ]; then
  source "$XDG_CONFIG_HOME/zsh/priv/zshenv.zsh"
fi

unset script_source script_dir shared_env file

eval "$('/opt/homebrew/bin/brew' shellenv)"

