#!/bin/bash

[[ $(uname -s) == "Darwin"* ]] && IS_MAC=true || IS_MAC=false

function logStep() {
  # log steps in the terminal in blue with a nice header
  echo -e "\e[1;34m--------------------\e[0m"
  echo -e "\e[1;34m- $1\e[0m"
  echo -e "\e[1;34m--------------------\e[0m"
}

# Ensure xdg folders exist
logStep "Ensuring xdg folders exist"
mkdir -p ~/.xdg/data
mkdir -p ~/.xdg/config
mkdir -p ~/.xdg/state
mkdir -p ~/.xdg/cache
mkdir -p ~/.xdg/runtime

# Clone repo
logStep "Cloning dotfiles"
git clone git@github.com:mikeduminy/dotfiles.git ~/.xdg/config

# Setup symlinks
logStep "Setting up symlinks"
ln -s ~/.xdg/config/zsh/.zshrc ~/.zshrc
ln -s ~/.xdg/config/zsh/.zshenv ~/.zshenv
ln -s ~/.xdg/config/zsh/.zprofile ~/.zprofile

# Setup env variables for mac GUI programs (specifically terminal)
logStep "Setting up LaunchAgents"
ln -s ~/.xdg/config/LaunchAgents/xdg-env-launch-agent.plist ~/Library/LaunchAgents/xdg-env-launch-agent.plist

# Homebrew
logStep "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

# Run Brewfile to setup environment and install apps
logStep "Installing applications (password may be required)"
brew bundle install

# Terminal
logStep "Installing wezterm"
brew install --cask "wezterm@nightly"

# Shell
brew install "zsh"

logStep "Changing default shell to installed zsh"
chsh -s /opt/homebrew/bin/zsh

if $IS_MAC; then
  # Mac needs additional setup to change the shell
  sudo dscl . -create /Users/"$USER" UserShell /opt/homebrew/bin/zsh
fi

# close and re-open terminal
reset
logStep "Done! It is time to close this terminal and open wezterm :D"
