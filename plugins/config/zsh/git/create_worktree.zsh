#!/bin/zsh

# Script that helps creating and switching to new git worktrees
# 
# 1. Select branch (existing or new)
# 2. Create a worktree as a sibling of the current worktree
# 3. Switch wezterm to the new worktree

for i in "$@"; do
  case $i in
  --help)
    echo "Usage: gwta [--dry-run]"
    echo "  --dry-run: Print the commands that would be run without executing them"
    return
    ;;
  --dry-run)
    DRY_RUN=1
    shift
    ;;
  --debug)
    DEBUG=1
    shift
    ;;
  *)
    shift
    ;;
  esac
done

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

# If repo is not on the main branch, warn and prompt to continue
current_branch=$(git rev-parse --abbrev-ref HEAD)
main_branch=$(git_main_branch)

if [[ $main_branch -ne $current_branch ]] then
  gum log --level warn "Current branch ($current_branch) is not the main branch: $main_branch"
  gum confirm "Continue" || return
fi

# Get the repo root and parent folder to create a sibling worktree in
repo_root=$(git rev-parse --show-toplevel)
repo_parent=$(dirname $repo_root)
repo_parent_name=$(basename $repo_parent)

# Prompt to select an existing branch or create a new one
CHOICE=$(gum choose --limit=1 "Create a new branch" "Select an existing branch" "Cancel")

worktree_path=$repo_parent

case $CHOICE in
  "Create a new branch")
    branch=$(gum input --prompt "Enter a new branch name: ")
    is_new_branch=1
    ;;
  "Select an existing branch")
    branch=$(git branch --all | fzf --prompt "Select branch: " --reverse --keep-right)
    is_new_branch=0
    ;;
  *)
    info "Choice required, exiting"
    return
    ;;
esac

# Trim whitespace around the branch name
branch=$(echo $branch | xargs)

# exit if no branch was selected
if [[ -z $branch ]] then
  info "No branch selected, exiting"
  return
fi

local function create_worktree() {
  branch=$1
  dir=$2
  is_new_branch=$3

  info "Creating worktree for branch $branch in $dir"

  if [[ $DRY_RUN == 1 ]] then
    debug "Dry run, skipping worktree creation, would have run:"
    if [[ $is_new_branch == 1 ]] then
      debug "git worktree add -b $branch $dir"
    else
      debug "git worktree add $dir"
    fi
    debug "Skipping workspace switch"
    return
  fi
  
  if [[ $is_new_branch == 1 ]] then
    git worktree add -b $branch $dir
  else 
    git worktree add $dir $branch
  fi
}

local function switch_workspace() {
  local workspace_name=$1
  local working_dir=$2
  # Check if we're already in the selected worktree
  if [[ $worktree_path == $(pwd) ]] then
    info "Already in workspace: $workspace_name"
    return
  fi

  info "Switching to workspace: $workspace_name"
  __wezterm_switch_workspace "$workspace_name" "$working_dir"
}

# Construct the worktree path and workspace name
worktree_path="$worktree_path/$branch"
workspace_name="$repo_parent_name/$branch"

# Check if the branch already exists and offer to switch to it
branch_exists=$(git branch --all | grep -cE "$branch$")
if [[ $branch_exists -gt 0 ]] then
  info "Branch $branch already exists"

  worktree_exists=$(simple_worktree_list | grep -c "$branch")
  if [[ $worktree_exists -gt 0 ]] then
    info "Worktree already exists for branch: $branch"

    gum confirm "Switch to worktree" && 
      switch_workspace "$workspace_name" "$worktree_path"
    return
  else
    # Branch exists but no worktree, create a worktree
    gum confirm "Create worktree for branch?" &&
      create_worktree $branch $worktree_path 0

    gum confirm "Switch to worktree" && 
      switch_workspace "$workspace_name" "$worktree_path"
    return
  fi
fi

# Branch does not exist, create a new worktree
create_worktree $branch $worktree_path $is_new_branch

# Switch to the new worktree
gum confirm "Switch to new worktree" && 
  switch_workspace "$workspace_name" "$worktree_path"
