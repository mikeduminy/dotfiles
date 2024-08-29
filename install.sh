#!/bin/bash

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
ln -s ~/.xdg/config/LaunchAgents/xdg-env-launch-agent.plist ~/Library/LaunchAgents/xdg-env-launch-agent.plist

# Homebrew
logStep "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

# Run Brewfile to setup environment and install apps
logStep "Installing applications"
brew bundle install

# close and re-open terminal
reset
logStep "Done! It is time to close this terminal and open wezterm :D"
