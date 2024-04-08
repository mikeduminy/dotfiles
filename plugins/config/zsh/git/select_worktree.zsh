#!/bin/zsh

# Load wezterm helper functions
source $XDG_CONFIG_HOME/wezterm/api.zsh

local function is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# Returns a list of worktrees in the format: <home-relative folder> <branch>
local function simple_worktree_list() {
  git worktree list | awk '{print $1" "$3}' | sed "s|$HOME/||"
}

# Returns the path to the worktree with the given folder name
local function find_path_to_worktree() {
  git worktree list | grep "$1" | awk '{print $1}' | head -n 1
}

is_git_repo || return

local worktrees_count_str
worktrees_count_str=$(simple_worktree_list | wc -l | awk '{print $1}')
local worktrees_count_int=$((worktrees_count_str + 0))

# No worktrees found
[[ $worktrees_count_int -lt 2 ]] && echo "No worktrees found." && return;

local selected_worktree
selected_worktree=$(simple_worktree_list | (fzf --reverse --prompt "Select worktree: " --keep-right))

# check if user cancelled fzf
(($? != 0)) && return

selected_worktree_dir_name=$(echo "$selected_worktree" | awk '{print $1}')
selected_worktree_dir=$(find_path_to_worktree "$selected_worktree_dir_name")

# The directory does not exist or no worktree was selected
[ ! -d "$selected_worktree_dir" ] && echo "Worktree directory does not exist: $selected_worktree_dir" && return;

# No need to switch if we're already in the selected worktree
[[ "$selected_worktree_dir" == $(pwd) ]] && echo "Already in $selected_worktree_dir_name" && return;

echo "Switching to worktree: $selected_worktree_dir_name"
wezterm-switch-workspace "$selected_worktree_dir_name" "$HOME/$selected_worktree_dir_name"

