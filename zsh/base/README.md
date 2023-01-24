# Dotfiles setup (base)

Repository of dotfiles intended to be used in a modular system.

Based on an [approach](https://dev.to/bowmanjd/using-multiple-git-repositories-to-store-dotfiles-in-a-modular-fashion-mni) outlined by Jonathan Bowman.

1. Clone this repo to `$XDG_CONFIG_HOME/custom/{repo}`
2. Integrate the touchpoints as needed:

#### `~/.zshrc`
```zsh
for file in $XDG_CONFIG_HOME/custom/*/.zshrc; do source $file; done
```
