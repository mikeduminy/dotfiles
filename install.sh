#!/bin/bash

[[ $(uname -s) == "Darwin"* ]] && IS_MAC=true || IS_MAC=false

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

# homebrew
logStep "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

# fonts
brew tap homebrew/cask-fonts

# list of brew packages to install
brew_libs=(
	"fzf"                           # fuzzy finder
	"ripgrep"                       # faster grep
	"stylua"                        # lua formatter
	"lazygit"                       # git tui
	"gnu-sed"                       # text manipulation
	"neovim"                        # editor
	"font-jetbrains-mono-nerd-font" # font
	"bluesnooze"                    # bluetooth manager for mac
	"ranger"                        # file manager
	"starship"                      # shell prompt
	"fd"                            # faster find
	"bat"                           # cat with syntax highlighting
	"eza"                           # better ls
	"procs"                         # modern ps
	"sd"                            # better, more intuitive sed
	"zoxide"                        # better cd
	"dust"                          # newer, faster du
	"tokei"                         # code line counter
	"hyperfine"                     # benchmarking tool
	"git-delta"                     # better git diff
	"zsh"                           # zsh shell
)

logStep "Installing brew packages"
for lib in "${brew_libs[@]}"; do
	brew install "$lib"
done

brew_casks=(
	"wezterm"        # terminal
	"1password"      # password manager
	"xcodes"         # xcode version manager
	"insomnia"       # rest api client
	"raycast"        # productivity search tool
	"cleanshot"      # screenshot tool
	"microsoft-edge" # browser
	"beyond-compare" # file comparison tool
	"displaylink"    # dell dock driver
)

logStep "Installing brew casks"
for cask in "${brew_casks[@]}"; do
	brew install --cask "$cask"
done

if $IS_MAC; then
	logStep "Changing default shell to installed zsh"
	chsh -s /opt/homebrew/bin/zsh
	# set zsh as default shell for mac
	sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh
fi

logStep "Cloning tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm $XDG_DATA_HOME/tmux/plugins/tpm

# close and re-open terminal
reset
logStep "Done! It is time to close this terminal and open wezterm :D"
