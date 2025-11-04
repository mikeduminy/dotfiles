#################################################################
# Base shell entrypoint, loaded in all modes of zsh             #
# .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout         #
# ^^^^^^^                                                       #
#################################################################

# uncomment the following line to output when this file is loaded
# echo "loading: $0"

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

# zsh needs some additional set up in the system files
# so for now keep loading this here
for file in $XDG_CONFIG_HOME/plugins/*/zsh/.zshenv; do source $file; done

unset script_source script_dir shared_env file

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
