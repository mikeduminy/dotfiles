#!/usr/bin/env bash

brew install zsh

expected_shell_bin="$(brew --prefix)/bin/zsh"

if [ "$SHELL" != "$expected_shell_bin" ]; then
  defaultShell=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')
  if [ "$defaultShell" != "$expected_shell_bin" ]; then
    logStep "Changing default shell to installed zsh"
    chsh -s "$expected_shell_bin"
    # Mac needs additional setup to change the shell
    sudo dscl . -create /Users/"$USER" UserShell "$expected_shell_bin"
  fi
fi
