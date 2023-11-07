#!/bin/zsh

# This script will open a new terminal for the selected project.
# Terminal used: wezterm

# Load wezterm helper functions
source $XDG_CONFIG_HOME/wezterm/api.zsh

# List of project roots, all are assumed to be below $HOME
project_roots=(${(s/:/)PROJECT_ROOTS})

# 1. Get all project folders without trailing slash
project_folders=$(fd --min-depth 1 --max-depth 1 -t directory . ${project_roots[@]} | xargs realpath)

# 1.1. Add any additional project folders we don't want to expand
project_folders+=(${(s/:/)PROJECT_FOLDERS})

# 2. Select a project using fzf (all paths are relative to $HOME)
selected_folder=$(printf '%s\n' "${project_folders[@]}" | sed "s|$HOME/||" | fzf --layout reverse --height 50%)
local retval=$?
if (($retval == 0)); then
	# 3. Switch to the workspace by communicating with wezterm
	wezterm-switch-workspace "$selected_folder" "$HOME/$selected_folder"
else
	# user cancelled fzf
	return
fi
