DEBUG_MODE = false # Set to true to enable/disable debug messages

def debug(msg)
  if DEBUG_MODE
    puts "DEBUG: #{msg}"
  end
end

# Check if the application is installed outside of the cask app directory
# This is useful for applications that are installed manually or through other means
# It checks if the application is installed in the /Applications directory
# and returns true if it is, false otherwise
#
# @param application [String] The name of the application to check
# @return [Boolean] true if the application is installed, false otherwise
def isAppInstalled(application)
  debug("Checking if #{application} is installed...")
  if IS_MAC
    root_application_installed = system "test -d /Applications/#{application}.app"
    debug("#{application} is #{root_application_installed ? 'installed' : 'not installed'} in /Applications")
  else
    root_application_installed = system "which #{application} > /dev/null 2>&1"
    debug("#{application} is #{root_application_installed ? 'installed' : 'not installed'} in PATH")
  end
  root_application_installed
end

# Setup MAC OS GUI apps
cask_args appdir: "~/Applications", require_sha: true
IS_MAC = OS.mac? # Check if the OS is macOS

# Terminal 
if IS_MAC
  # todo: find a way to install on linux via this file
  cask "wezterm@nightly", greedy: true, args: { no_quarantine: true, force: true }
end

# Shell and prompt
brew "zsh"
brew "zsh-vi-mode" # vi mode for zsh
brew "starship"    # shell prompt
brew "eza"         # better ls
brew "zoxide"      # better cd
brew "tmux"        # terminal multiplexer

# Neovim
brew "neovim"
cask "font-jetbrains-mono-nerd-font" # font for terminal and editor
brew "fzf"                           # fuzzy finder
brew "fd"                            # faster find
brew "ripgrep"                       # faster grep
brew "sd"                            # faster sed
brew "stylua"                        # lua formatter

# Source control
brew "git"
brew "git-delta" # better git diff
brew "lazygit"   # terminal UI for git

# CLIs
brew "gnu-sed"   # text manipulation
brew "bat"       # cat with syntax highlighting 
brew "procs"     # modern ps
brew "dust"      # newer, faster du
brew "tokei"     # code line counter
brew "hyperfine" # benchmarking tool
brew "jq"        # json parser
brew "htop"      # system monitor
brew "xdg-ninja" # XDG compliance checker
brew "gum"       # glamorous shell scripts 

# GUI Apps
if IS_MAC 
  cask "bluesnooze"         # bluetooth autosleep
  cask "cleanshot"          # screen capture
  cask "colemak-dh"         # colemak dh keyboard layout
  cask "karabiner-elements" # keyboard remapping
  cask "bartender"
  # todo: find a way to install on linux via this file
  cask "1password"      # password manager
  # todo: find a way to install on linux via this file
  cask "beyond-compare" # file comparison tool
end

if !isAppInstalled("firefox")
  # firefox might be installed manually, if so we want to skip this
  cask "firefox" # browser
end

# VSCode
if IS_MAC 
  cask "visual-studio-code"
  vscode "asvetliakov.vscode-neovim"  # neovim integration
  vscode "dbaeumer.vscode-eslint"     # eslint integration
  vscode "esbenp.prettier-vscode"     # prettier integration
  vscode "github.copilot"             # github copilot
  vscode "github.copilot-chat"        # github copilot chat
  vscode "ms-vsliveshare.vsliveshare" # MS live share
end

# vi: ft=ruby
