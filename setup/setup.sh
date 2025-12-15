#!/usr/bin/env bash

DRY_RUN=${DRY_RUN:-false}
DEBUG=${DEBUG:-false}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# populate dry run from args
case "$1" in
--dry-run)
  DRY_RUN=true
  ;;
esac

# Load shared environment variables
source "$SCRIPT_DIR/shared-env-vars.sh"

log_line() {
  echo -e "\e[1;34m--------------------\e[0m"
}

log_step() {
  echo -e "\e[1;34m$1\e[0m"
}

export DOTFILES_REPO_PATH="$XDG_CONFIG_HOME"

if [ "$OS" = "mac" ]; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

log_line "Running app installations"

# run install scripts for each app, sorted alphabetically (number first)
for app_dir in $(find "$DOTFILES_REPO_PATH/setup/apps" -type d -mindepth 2 | sort); do
  app_name=$(basename "$app_dir")

  # Determine which install script to use (precedence: OS-specific > generic)
  app_install_path=""
  if [ -f "$app_dir/install.$OS.sh" ]; then
    app_install_path="$app_dir/install.$OS.sh"
  elif [ -f "$app_dir/install.sh" ]; then
    app_install_path="$app_dir/install.sh"
  fi

  # Make app_install_path relative to script directory
  if [ -n "$app_install_path" ]; then
    app_install_path="${app_install_path#"$SCRIPT_DIR"/}"
  fi

  # Skip if no install script found
  if [ -z "$app_install_path" ]; then
    echo "No installation found for $app_dir, skipping."
    continue
  fi

  # don't install if dry run
  if [ "$DRY_RUN" == "true" ]; then
    log_step "- Dry run enabled, skipping installation of: $app_name ($app_install_path)"
  else
    # run install script (use absolute path for sourcing)
    . "$SCRIPT_DIR/$app_install_path"
    log_step "Done: $app_name"
  fi
done

log_line

unset app_name, app_install_path
