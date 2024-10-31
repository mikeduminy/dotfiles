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
source $current_folder/oh-my-git.zsh
source $current_folder/../utils.zsh

local function is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# Returns a list of worktrees in the format: <home-relative folder> <branch>
local function simple_worktree_list() {
  git worktree list | awk '{print $1" "$3}' | sed "s|$HOME/||"
}

# Check if we're in a git repo, if not, exit
is_git_repo || (error "Not in a git repo" && return)

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

worktree_args=()
worktree_path="$repo_parent"

case $CHOICE in
  "Create a new branch")
    branch=$(gum input --prompt "Enter a new branch name: ")
    # Trim whitespace around the branch name
    branch=$(echo $branch | xargs)
    worktree_path="$worktree_path/$branch"

    worktree_args+=("-b=$branch")
    worktree_args+=("$worktree_path")
    ;;
  "Select an existing branch")
    branch=$(git branch --all | fzf --prompt "Select branch: " --reverse --keep-right)
    # Trim whitespace around the branch name
    branch=$(echo $branch | xargs)
    worktree_path="$worktree_path/$branch"

    worktree_args+=("$worktree_path $existing_branch")
    ;;
  *)
    info "Choice required, exiting"
    return
    ;;
esac

# exit if no branch was selected
if [[ -z $branch ]] then
  info "No branch selected, exiting"
  return
fi

# Create the worktree
info "Creating worktree for branch: $branch in $repo_parent"

echo "worktree_args: ${worktree_args[@]}"

if [[ $DRY_RUN == 1 ]] then
  debug "Dry run, skipping worktree creation, would have run:"
  debug "git worktree add ${worktree_args[@]}"
  debug "Skipping workspace switch"
  return
else
  git worktree add ${worktree_args[@]}
fi

info "Created worktree: $worktree_path"

# Switch to the new worktree
gum confirm "Switch to new worktree" || return

workspace_name="$repo_parent_name/$branch"
info "Switching to workspace: $workspace_name"
__wezterm_switch_workspace "$workspace_name" "$worktree_path"

