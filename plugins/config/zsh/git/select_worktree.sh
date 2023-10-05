#!/usr/bin/env bash

# This script will change the current working directory to the selected git worktree.
# In order for that to work this script needs to be sourced.
# eg. source select_worktree.sh

selected_worktree_dir=""
current_dir=$(pwd)

function is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# Returns a list of worktrees in the format: <folder basename> <branch>
function simple_worktree_list() {
  git worktree list | awk '{sub(".*/", "", $1); print $1" "$3}'
}

# Returns the path to the worktree with the given folder name
function find_path_to_worktree() {
  git worktree list | grep "$1" | awk '{print $1}'
}

function git_work_tree_change_cwd() {
  is_git_repo || return

  local worktrees_count_str
  worktrees_count_str=$(simple_worktree_list | wc -l | awk '{print $1}')
  local worktrees_count_int=$((worktrees_count_str + 0))
  if [[ $worktrees_count_int -lt 2 ]]; then
    echo "Only one worktree found. Nothing to change to."
    return
  fi

  local selected_worktree
  selected_worktree=$(simple_worktree_list | fzf --reverse --prompt "Select worktree: " --keep-right)
  selected_worktree_dir_name=$(echo "$selected_worktree" | awk '{print $1}')
  local retval=$?
  if [ $retval -eq 0 ]; then
    selected_worktree_dir=$(find_path_to_worktree "$selected_worktree_dir_name")
  else
    # user cancelled
    return
  fi
}

git_work_tree_change_cwd

if [[ -d "$selected_worktree_dir" ]]; then
  folder=$(basename "$selected_worktree_dir")
  if [[ "$selected_worktree_dir" == "$current_dir" ]]; then
    echo "Already in $folder"
  else
    echo "Switching to worktree: $folder"
    cd "$selected_worktree_dir" || return
  fi
else
  # The directory does not exist or no worktree was selected
  return
fi
