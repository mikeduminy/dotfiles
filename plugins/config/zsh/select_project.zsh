#!/bin/zsh

# This script will open a new terminal for the selected project.
# Terminal used: wezterm

# hacky way to switch workspace via the wezterm cli
# source: https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
# watch discussion: https://github.com/wez/wezterm/discussions/3534
# watch issue: https://github.com/wez/wezterm/issues/3542
function wezterm-switch-workspace() {
	args=$(jq -n --arg workspace "$1" --arg cwd "$2" '{"workspace":$workspace,"cwd":$cwd}' | base64)
	printf "\033]1337;SetUserVar=%s=%s\007" switch-workspace $args
}

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
	wezterm-switch-workspace $selected_folder $HOME/$selected_folder
else
	# user cancelled fzf
	return
fi
