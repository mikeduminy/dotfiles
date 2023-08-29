if ! type __git_prompt_git > /dev/null; then
    ## if oh-my-zsh git plugin isn't loaded, load a subset of it
    source $(dirname $0)/oh-my-git.zsh
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
alias gdlb="git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D"

