local current_folder=$(dirname $0)

# load git aliases
source $current_folder/oh-my-git.zsh

# Rebase current branch onto the latest main
alias grbm='gfa; git rebase origin/$(git_main_branch)'

# Checkout the main branch
alias gcom='git checkout $(git_main_branch)'

# Open merge tool
alias gmt='git mergetool --no-prompt'

# Open diff tool
alias gdt='git difftool --dir-diff'

# Interactively rebase the current branch onto the common ancestor of the current branch and the main branch
alias grbis='git rebase -i `git merge-base \`current_branch\` origin/$(git_main_branch)`'

# Fetch all remotes and prune deleted branches
alias gfa='git fetch --tags --force && git fetch --all --prune --jobs=10'

## Copy latest commit hash to clipboard
alias gtop='git log -1 --format="%H" | cat | xargs echo -n | pbcopy'

## Delete local branches that no longer exist on remote (probably due to merge)
gdlb() {
  # Fetch all remotes and prune deleted branches
  echo "Fetching all remotes and pruning deleted branches..."
  gfa

  _commands=(
    "git branch -v" # show all branches
    "grep '\[gone\]'" # only show branches that have been merged
    "sed 's/^.\{1\}//'" # remove the + from the branch name
    "awk '{print \$1}'" # only keep the branch name
  )

  git_list_local_merged_branches=$(join_by " | " "${_commands[@]}")
  branches=$(eval $git_list_local_merged_branches)

  if [ -n "$branches" ]; then
    echo "The following branches will be deleted:"
    echo "$branches"
    if gum confirm "Do you want to proceed?"; then
      echo "$branches" | xargs git branch -D
    else
      echo "Operation cancelled."
    fi
  else
    echo "No branches to delete."
  fi
}

alias grnb="$current_folder/rename_branch.zsh"

## Open fzf to select a worktree, open a new terminal workspace at the worktree
alias gwt="$current_folder/select_worktree.zsh"

## Select a branch or create a new one, then create a worktree
alias gwta="$current_folder/create_worktree.zsh"

## Delete a worktree
alias gwtd="$current_folder/delete_worktree.zsh"

## Open fzf to select a branch and check it out
gch() {
  selected_branch=$(git branch --all | fzf)
  if [ $? -eq 0 ]; then
    trimmed_branch=$(echo $selected_branch | xargs)
    echo "Checking out $trimmed_branch"
    git checkout $trimmed_branch
  fi
}

## Search git history for a string
gfind() {
  if [ -z "$1" ]; then
    echo "Usage: gfind <search_term> <optional: path>"
    return 1
  fi
  git log -S"$1" -p -- $2
}

# Delete locked index file (can sometimes happen)
alias gdlf="$current_folder/remove_locked_index.zsh"

# Pull
alias gpl='git pull'

# Update and pull
alias gup='gfa && gpl'

# Checkout a branch using fzf, excluding the current branch
gcoi() {
  _commands=(
    "git branch --sort='-authordate'" # show all branches in order of last commit
    'grep -v "^\*"' # exclude the current branch
    "fzf --height=20% --reverse --info=inline" # interactive search
    "xargs git checkout" # checkout the selected branch
  )

  cmd=$(join_by " | " "${_commands[@]}")
  eval $cmd
}

# Open git history for a folder, default to entire repo, or provide a path to
# search for the folder
ghist() {
  if [ -z "$1" ]; then
    root=$(git rev-parse --show-toplevel)
  else 
    root=$(grealpath $1)
  fi 

  folder=$(fd -t=d --base-directory=$root | fzf)

  if [ $? -eq 0 ]; then
    abs_path="$root/$folder"
    rel_path=$(grealpath --relative-to=$PWD "$abs_path")
    echo "Searching git history in $rel_path"
    git log -- $rel_path
  fi
}

# Checkout a recent branch from the git reflog using fzf
gcr() {
  git reflog | grep checkout | awk '{print $NF}' | awk '!x[$0]++' | head -n 10 | \
    fzf --height=20 --border --header='Select branch to checkout' | xargs git checkout
}
