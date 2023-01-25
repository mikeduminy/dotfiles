# Mike's XDG config

This repo uses the [XDG Base Direction Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to organise config files. The official documentation is fairly sparse, so to get a better understanding of the system I'd recommend looking at the [archlinux wiki](https://wiki.archlinux.org/title/XDG_Base_Directory).

Intended to be used on a Mac.

## Requirements

- bash
- zsh
- git

## Quickstart
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mikeduminy/dotfiles/HEAD/install.sh)"
```

## Getting started (manual)

1. Clone this repo into `~/.xdg/config`
2. Link the zsh config files from this repo to the root ones
````
ln -s ~/.xdg/config/zsh/.zshrc ~/.zshrc
ln -s ~/.xdg/config/zsh/.zshenv ~/.zshenv
ln -s ~/.xdg/config/zsh/.zprofile ~/.zprofile
``````
3. If you are on Mac then for GUI programs launched from outside the terminal to detect your XDG config home you may also need to run this. This script is only run on log-in so log out and in to see it apply.
```sh
ln -s ~/.xdg/config/LaunchAgents/xdg-env-launch-agent.plist ~/Library/LaunchAgents/xdg-env-launch-agent.plist
```
4. Install homebrew (if you don't have it)
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
5. Install tools
```sh
brew install wezterm \
  neovim  \
  ripgrep \
  stylua  \
  lazygit \
  gnu-sed
```

## Custom installation
The above is just a recommendation. Feel free to deviate, but remember to update
the values for the XDG environment variables. The defaults are defined in
`.zshenv`.
