#!/bin/zsh

# This script is used to remove a stuck git index.lock file that is preventing you from doing anything with git.
# It works by finding the index.lock file and removing it.
# It also checks if the file is still locked and if it is, it will kill the process that is locking it.
#
# It can be run from anywhere in a git repository and works in worktrees as well.

local current_folder=$(dirname $0)

# Load common git functions
source $current_folder/common.zsh

ensure_git_repo || return

local index_lock_file=$(git rev-parse --git-path index.lock)
if [[ -f $index_lock_file ]]; then
  echo "Found index.lock file: $index_lock_file"
  echo "Removing.."
  rm -f $index_lock_file
  if [[ -f $index_lock_file ]]; then
    echo "Failed to remove lock file, attempting to kill process"
    local pid
    pid=$(lsof -t $index_lock_file)
    if [[ -n $pid ]]; then
      echo "Killing process $pid"
      kill $pid
    else
      echo "No process found for lock file"
    fi
  else
    echo "Removed successfully"
  fi
else
  echo "No index.lock file found"
fi
