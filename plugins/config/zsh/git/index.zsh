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
alias gdt='git difftool'

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
