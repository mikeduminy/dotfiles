#!/usr/bin/env bash

function logStep() {
  # log steps in the terminal in blue with a nice header
  echo -e "\e[1;34m--------------------\e[0m"
  echo -e "\e[1;34m- $1\e[0m"
  echo -e "\e[1;34m--------------------\e[0m"
}

# load shared env vars for XDG dirs and OS detection
source <(curl -fsSL https://raw.githubusercontent.com/mikeduminy/dotfiles/main/zsh/shared-env-vars.zsh)

if [ -z "$OS_TYPE" ]; then
  echo "Could not detect OS type, exiting"
  exit 1
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  echo "XDG_CONFIG_HOME is not set, exiting"
  exit 1
fi

# Ensure xdg folders exist
logStep "Ensuring xdg folders exist"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_RUNTIME_DIR"

# Clone repo
logStep "Cloning dotfiles"
git clone git@github.com:mikeduminy/dotfiles.git "$XDG_CONFIG_HOME"

pushd "$XDG_CONFIG_HOME" || exit

# Setup symlinks
logStep "Setting up symlinks"
ln -s "$XDG_CONFIG_HOME"/zsh/.zshrc ~/.zshrc
ln -s "$XDG_CONFIG_HOME"/zsh/.zshenv ~/.zshenv
ln -s "$XDG_CONFIG_HOME"/zsh/.zprofile ~/.zprofile

# Setup env variables for mac GUI programs (specifically terminal)
if [ "$OS_TYPE" = "mac" ]; then
  logStep "Setting up LaunchAgents"
  ln -s "$XDG_CONFIG_HOME"/LaunchAgents/xdg-env-launch-agent.plist ~/Library/LaunchAgents/xdg-env-launch-agent.plist
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  logStep "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
fi

# Run Brewfile to setup environment and install apps
logStep "Installing applications (password may be required)"
brew bundle install

expected_shell=zsh
expected_shell_bin="$(brew --prefix)/bin/$expected_shell"

if [ "$OS_TYPE" = "mac" ]; then
  defaultShell=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')
  if [ "$defaultShell" != "$expected_shell_bin" ]; then
    logStep "Changing default shell to installed $expected_shell"
    chsh -s "$expected_shell_bin"
    # Mac needs additional setup to change the shell
    sudo dscl . -create /Users/"$USER" UserShell "$expected_shell_bin"
  fi
else
  if [ "$SHELL" != "$expected_shell_bin" ]; then
    logStep "Changing default shell to installed $expected_shell"
    chsh -s "$expected_shell_bin"
  fi
fi

# close and re-open terminal
logStep "Done! It is time to close this terminal and open wezterm :D"
