#!/bin/zsh

# Script that helps deleting git worktrees for the current repo
# 
# 1. List all worktrees
# 2. Select a worktree to delete
# 3. Delete the worktree

# Load wezterm helper functions
source $XDG_CONFIG_HOME/wezterm/api.zsh

local current_folder=$(dirname $0)

# Load common git functions
source $current_folder/common.zsh

ensure_git_repo || return

# Returns a list of worktrees in the format: <home-relative folder> <branch>
local function simple_worktree_list() {
  git worktree list | awk '{print $1" "$3}' | sed "s|$HOME/||"
}

# If there are no worktrees, exit
worktrees_count_str=$(simple_worktree_list | wc -l | awk '{print $1}')
worktrees_count_int=$((worktrees_count_str + 0))
if [[ $worktrees_count_int -lt 2 ]] then
  error "No worktrees found."
  return
fi

# Select a worktree to delete
selected_worktree=$(simple_worktree_list | (fzf --reverse --prompt "Select worktree: " --keep-right) | awk '{print $1}')
if [[ $selected_worktree == "" ]] then
  error "No worktree selected"
  return
fi

info "Deleting worktree: $selected_worktree"
git worktree remove $HOME/$selected_worktree
if [[ $? -ne 0 ]] then
  error "Failed to delete worktree: $selected_worktree"
  return
fi

info "Deleted worktree: $selected_worktree"
