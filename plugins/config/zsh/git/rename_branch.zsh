#!/bin/zsh

# Load common git functions
source $(dirname $0)/common.zsh

ensure_git_repo || return

current_branch=$(git rev-parse --abbrev-ref HEAD)

# Exit if trying to rename the main branch
main_branch=$(git_main_branch)
if [[ $main_branch == $current_branch ]]; then
  error "Cannot rename the main branch: $main_branch"
  return
fi

# Get the new branch name from the user
new_branch=$(gum input --placeholder "Rename current branch '$current_branch' to: ")

# exit if user cancels
(($? != 0)) && return

# Rename local branch
git branch -m $new_branch

# Check if we've pushed the branch to the remote
remote_branch=$(git ls-remote --heads origin $new_branch)
if [[ -z $remote_branch ]]; then
  info "Branch '$current_branch' has been renamed to '$new_branch' locally (no remote branch was found to be renamed)"
  return
fi

# If so then push the new branch and delete the old one (with confirmation)
gum confirm "Push branch '$new_branch' to the remote and delete '$current_branch'?" || return

git push origin --set-upstream $new_branch
git push origin --delete $current_branch

info "Branch '$current_branch' has been renamed to '$new_branch' locally and on the remote"
