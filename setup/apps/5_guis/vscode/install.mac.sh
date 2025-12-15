#!/usr/bin/env bash

if ! test -d /Applications/Visual\ Studio\ Code.app; then
  echo "Visual Studio Code is not installed. Installing Visual Studio Code..."
  brew install --cask visual-studio-code
else
  echo "Visual Studio Code is already installed. Skipping installation."
  exit 0
fi
