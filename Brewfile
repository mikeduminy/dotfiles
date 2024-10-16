# Setup MAC OS GUI apps
cask_args appdir: "~/Applications", require_sha: true

isMac = OS.mac? # Check if the OS is macOS

# Terminal 
cask "wezterm@nightly", greedy: true, args: { no_quarantine: true }

# Shell and prompt
brew "zsh"
brew "starship" # shell prompt
brew "eza"      # better ls
brew "zoxide"   # better cd

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

# GUI Apps
if isMac 
  cask "bluesnooze" # bluetooth autosleep
  cask "raycast"    # command palette
  cask "cleanshot"  # screen capture
end
cask "1password"      # password manager
cask "insomnia"       # REST client
cask "microsoft-edge" # browser
cask "beyond-compare" # file comparison tool
cask "displaylink"    # dell dock driver (needs admin privileges)

# VSCode
cask "visual-studio-code"
vscode "asvetliakov.vscode-neovim"  # neovim integration
vscode "dbaeumer.vscode-eslint"     # eslint integration
vscode "esbenp.prettier-vscode"     # prettier integration
vscode "github.copilot"             # github copilot
vscode "github.copilot-chat"        # github copilot chat
vscode "ms-vsliveshare.vsliveshare" # MS live share
