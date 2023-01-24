#!/bin/bash

# todo: add logging of steps

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

# neovim + deps
brew install neovim \
  ripgrep \
  stylua \
  lazygit

# close and re-open terminal
