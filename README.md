# Mike's XDG config

This repo uses the [XDG Base Direction Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to organise config files. The official documentation is fairly sparse, so to get a better understanding of the system I'd recommend looking at the [archlinux wiki](https://wiki.archlinux.org/title/XDG_Base_Directory).

> This is just a recommendation. Feel free to deviate, but remember to update
the values for the XDG environment variables. The defaults are defined in
`.zshenv`.

NOTE: Only intended to be used on a Mac.

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
brew update
brew tap homebrew/cask-fonts
```
5. Install main tools
```sh
brew install \
neovim  \
ripgrep \
stylua  \
lazygit \
gnu-sed \
font-jetbrains-mono-nerd-font \
starship \
fd \
bat \
eza \
procs \
sd \
zoxide \
dust \
tokei \
hyperfine

```
6. Install quality-of-life tools
```sh
brew install \
bluesnooze

brew install --cask \
wezterm \
1password \
xcodes \
insomnia \
raycast \
cleanshot \
microsoft-edge \
beyond-compare \
displaylink
```

## Software (installed by installer)
- [WezTerm](https://wezfurlong.org/wezterm/) - terminal emulator
- [Neovim](https://neovim.io/) - new vim
- [ripgrep](https://github.com/BurntSushi/ripgrep) - fast file search
- [stylua](https://github.com/JohnnyMorganz/StyLua) - lua formatter
- [gnu-sed](https://formulae.brew.sh/formula/gnu-sed) - text manipulation 
- [LazyGit](https://github.com/jesseduffield/lazygit) - terminal UI for git with
VI bindings
- [Starship](https://starship.rs/) - custom shell prompt
- [fd](https://github.com/sharkdp/fd) - faster find
- [bat](https://github.com/sharkdp/bat) - cat with syntax highlighting
- [eza](https://github.com/eza-community/eza) - better ls
- [procs](https://github.com/dalance/procs) - modern ps
- [sd](https://github.com/chmln/sd) - better, more intuitive sed
- [zoxide](https://github.com/ajeetdsouza/zoxide) - better cd
- [dust](https://github.com/bootandy/dust) - newer, faster du
- [tokei] - code line counter
- [hyperfine](https://github.com/sharkdp/hyperfine) - benchmarking tool

## Quality-of-life software (installed by installer)
- [Bluesnooze](https://github.com/odlp/bluesnooze) - sleeping Mac = bluetooth off
- [1Password](https://1password.com/) - password manager
- [XCodes](https://www.xcodes.app/) - XCode version manager
- [Insomnia](https://insomnia.rest/) - REST GUI
- [Raycast](https://www.raycast.com/) - replacement for Mac Spotlight
- [CleanShot X](https://cleanshot.com/) - better screenshots
- [Microsoft Edge](https://www.microsoft.com/en-us/edge) - personal Browser
- [Beyond Compare](https://www.scootersoftware.com/download.php) - 3-way merge
- [DisplayLink Manager](https://www.synaptics.com/products/displaylink-graphics/downloads/macos) - external display support through Dell dock 
