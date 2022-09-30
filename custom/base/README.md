# Dotfiles setup (base)

Repository of dotfiles intended to be used in a modular system.

Based on an [approach](https://dev.to/bowmanjd/using-multiple-git-repositories-to-store-dotfiles-in-a-modular-fashion-mni) outlined by Jonathan Bowman.

1. Clone this repo to `$XDG_CONFIG_HOME/custom/base`
2. Integrate the touchpoints as needed:

#### `~/.zshrc`
```zsh
for file in $XDG_CONFIG_HOME/custom/*/.zshrc; do source $file; done
```

#### `~/.bashrc`
```bash
for file in "$(find $HOME/.config/custom -name 'bashrc')"; do . $file; done
```

#### `~/.vimrc`
```vim
runtime! ../.xdg/.config/custom/**/*.vim
```

#### `~/.ssh/config`
```ssh
Include ~/.xdg/.config/custom/*/*.ssh
```
