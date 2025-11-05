#!/usr/bin/env bash

DRY_RUN=${DRY_RUN:-false}

# populate dry run from args
case "$1" in
--dry-run)
  DRY_RUN=true
  ;;
esac

# Load shared environment variables
source shared-env-vars.sh

log_line() {
  echo -e "\e[1;34m--------------------\e[0m"
}

log_step() {
  echo -e "\e[1;34m- $1\e[0m"
}

export DOTFILES_REPO_PATH="$XDG_CONFIG_HOME"

if [ "$OS" = "mac" ]; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

log_line "Running app installations"

# run install scripts for each app, sorted alphabetically (number first)
for app_install_path in $(find "$DOTFILES_REPO_PATH/setup/apps" -type f -name "install" | sort); do
  app_name=$(basename "$(dirname "$app_install_path")")

  # don't install if dry run
  if [ "$DRY_RUN" == "true" ]; then
    log_step "Dry run enabled, skipping installation of: $app_name"
  else
    # run install script
    . "$app_install_path"
    log_step "Done: $app_name"
  fi
done

log_line

unset app_name, app_install_path
