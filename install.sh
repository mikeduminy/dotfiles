#!/bin/bash

# todo: add logging of steps

# Ensure xdg folders exist
mkdir -p ~/.xdg/data
mkdir -p ~/.xdg/config
mkdir -p ~/.xdg/state
mkdir -p ~/.xdg/cache
mkdir -p ~/.xdg/runtime

# Clone repo
git clone git@github.com:mikeduminy/dotfiles.git ~/.xdg/config

# Setup symlinks
ln -s ~/.xdg/config/zsh/.zshrc ~/.zshrc
ln -s ~/.xdg/config/zsh/.zshenv ~/.zshenv
ln -s ~/.xdg/config/zsh/.zprofile ~/.zprofile

# Setup env variables for mac GUI programs (specifically terminal)
ln -s ~/.xdg/config/LaunchAgents/xdg-env-launch-agent.plist ~/Library/LaunchAgents/xdg-env-launch-agent.plist

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# terminal 
brew install wezterm

# fuzzy finder
brew install fzf

# faster grep
brew install ripgrep

# neovim + deps
brew install neovim \
  stylua \
  lazygit \
  gnu-sed

# close and re-open terminal
