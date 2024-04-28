#!/bin/zsh

# This script will open a new terminal for the selected project.
# Terminal used: wezterm

# Load wezterm helper functions
source $XDG_CONFIG_HOME/wezterm/api.zsh

# List of project roots, all are assumed to be below $HOME
project_roots=(${(s/:/)PROJECT_ROOTS})

# 1. Get all project folders without trailing slash
project_folders=($(fd --min-depth 1 --max-depth 1 -t directory . ${project_roots[@]} | xargs realpath))

# 1.1. Add any additional project folders we don't want to expand
project_folders+=(${(s/:/)PROJECT_FOLDERS})

# 2. Construct a list of project folders and their git branch
selection_list=()
for folder in "${project_folders[@]}"; do
  # change to project folder
  cd $folder || continue

  # shorten folder path
  local short_folder=$(echo $folder | sed "s|$HOME/||")

  # get git branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ $? -eq 0 ]; then
    selection_list+=("$short_folder [$branch]")
  else
    selection_list+=("$short_folder")
  fi

  # return to previous folder
  cd - > /dev/null
done

# 2. Select a project using fzf (all paths are relative to $HOME)
selected_item=$(printf '%s\n' "${selection_list[@]}" | fzf --layout reverse --height 50%)
local retval=$?
if (($retval == 0)); then
  # 2.1. Get the selected folder from the selected item
  selected_folder=$(echo $selected_item | awk '{print $1}')
	# 3. Switch to the workspace by communicating with wezterm
	__wezterm_switch_workspace "$selected_folder" "$HOME/$selected_folder"
else
	# user cancelled fzf
	return
fi
