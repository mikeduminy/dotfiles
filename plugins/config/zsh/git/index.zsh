local current_folder=$(dirname $0)

if ! type __git_prompt_git > /dev/null; then
    ## if oh-my-zsh git plugin isn't loaded, load a subset of it
    source $current_folder/oh-my-git.zsh
fi

# Rebase current branch onto the latest main
unalias grbm # oh-my-zsh git plugin sets this
alias grbm='gfa; git rebase origin/$(git_main_branch)'

# Open merge tool
alias gmt='gmtl' # oh-my-zsh git plugin replaced gmt with gmtl

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
  git fetch --prune --jobs=10

  _commands=(
    "git branch -v" # show all branches
    "grep '\[gone\]'" # only show branches that have been merged
    "sed 's/^.\{1\}//'" # remove the + from the branch name
    "awk '{print \$1}'" # only keep the branch name
    "xargs git branch -D" # delete the branches
  )

  git_delete_local_merged_branches=$(join_by " | " "${_commands[@]}")
  eval $git_delete_local_merged_branches
}

## Open fzf to select a worktree, open a new terminal workspace at the worktree
alias gwt="$current_folder/select_worktree.zsh"

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

alias gdlf="$current_folder/remove_locked_index.zsh"

alias gpl='git pull'

# Checkout a branch using fzf, excluding the current branch
gcoi() {
  _commands=(
    "git branch" # show all branches
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

