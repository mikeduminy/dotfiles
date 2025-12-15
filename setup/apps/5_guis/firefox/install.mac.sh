#!/usr/bin/env bash

if ! test -d /Applications/Firefox.app; then
  echo "Firefox is not installed. Installing Firefox..."
  brew install --cask firefox
else
  echo "Firefox is already installed. Skipping installation."
  exit 0
fi
