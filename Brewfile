# Setup MAC OS GUI apps
tap "homebrew/cask"
cask_args appdir: "~/Applications", require_sha: true

isMac = OS.mac? # Check if the OS is macOS
# isWezterm = system("wezterm --version") # Check if wezterm is installed

# Terminal 
cask "wezterm@nightly", greedy: true, args: { no_quarantine: true }

# Shell and prompt
system "sudo chsh -s /opt/homebrew/bin/zsh"
brew "zsh"
if isMac
  ## Mac needs additional setup to change the shell
  system "sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh"
end
brew "starship" # shell prompt
brew "eza"      # better ls
brew "zoxide"   # better cd

# Neovim
brew "neovim"
brew "font-jetbrains-mono-nerd-font" # font for terminal and editor
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

# GUI Apps
if isMac 
  brew "bluesnooze" # bluetooth autosleep
  cask "xcodes"     # Xcode version manager
  cask "raycast"    # command palette
  cask "cleanshot"  # screen capture
end
cask "1password"      # password manager
cask "insomnia"       # REST client
cask "microsoft-edge" # browser
cask "beyond-compare" # file comparison tool
cask "displaylink"    # dell dock driver

# VSCode
cask "visual-studio-code"
vscode "asvetliakov.vscode-neovim"  # neovim integration
vscode "dbaeumer.vscode-eslint"     # eslint integration
vscode "esbenp.prettier-vscode"     # prettier integration
vscode "github.copilot"             # github copilot
vscode "github.copilot-chat"        # github copilot chat
vscode "ms-vsliveshare.vsliveshare" # MS live share
