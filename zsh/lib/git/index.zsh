local current_folder=$(dirname $0)

# load git aliases
source $current_folder/oh-my-git.zsh

# Rebase current branch onto the latest main
alias grbm='gfa; git rebase origin/$(git_main_branch)'

# Record which branch a new branch was created from, so grbp can find it
# later even after the parent gets rebased and the commit graph no longer
# shows the relationship. Overrides oh-my-git.zsh's plain alias, which would
# otherwise shadow this function since zsh expands aliases before functions.
unalias gswc 2>/dev/null
gswc() {
  local parent=$(git_current_branch)
  git switch --create "$@" || return
  git config "branch.$(git_current_branch).parentbranch" "$parent"
}

# Manually set/update the recorded parent of a branch, used by grbp.
# Usage: gsetp <parent-branch> [branch (default: current)]
gsetp() {
  if [[ -z "$1" ]]; then
    echo "Usage: gsetp <parent-branch> [branch (default: current)]"
    return 1
  fi

  local parent="$1"
  local branch="${2:-$(git_current_branch)}"

  if ! git show-ref --verify --quiet "refs/heads/$parent"; then
    echo "No local branch named '$parent'"
    return 1
  fi

  git config "branch.$branch.parentbranch" "$parent"
  echo "$branch's parent set to $parent"
}

# Find the parent of the current branch. Prefers the parent recorded by gswc
# (survives the parent being rebased). Falls back to guessing the local
# branch current diverged from most recently (main included as a normal
# candidate) for branches created before that tracking existed.
git_parent_branch() {
  local current=$(git_current_branch)
  local recorded=$(git config --get "branch.$current.parentbranch" 2>/dev/null)
  if [[ -n "$recorded" ]] && git show-ref --verify --quiet "refs/heads/$recorded"; then
    echo "$recorded"
    return
  fi

  local best_branch="" best_count="" branch count

  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    [[ "$branch" == "$current" ]] && continue
    # skip descendants of current (branches created off current, not parents of it)
    git merge-base --is-ancestor "$current" "$branch" 2>/dev/null && continue
    count=$(git rev-list --count "$branch..$current")
    if [[ -z "$best_count" || "$count" -lt "$best_count" ]]; then
      best_count=$count
      best_branch=$branch
    fi
  done

  echo "${best_branch:-$(git_main_branch)}"
}

# Rebase current branch onto its closest parent branch (could be main or another branch)
alias grbp='gfa; git rebase -i $(git_parent_branch)'

# Checkout the main branch
alias gcom='git checkout $(git_main_branch)'

# Open merge tool
alias gmt='git mergetool --no-prompt'

# Open diff tool
alias gdt='git difftool --dir-diff'

# Interactively rebase the current branch onto the common ancestor of the current branch and the main branch
alias grbis='git rebase -i `git merge-base \`git_current_branch\` origin/$(git_main_branch)`'

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
