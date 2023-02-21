if ! type __git_prompt_git > /dev/null; then
    ## if oh-my-zsh git plugin isn't loaded, load a subset of it
    source $(dirname $0)/oh-my-git.zsh
fi

## Replacement aliases
unalias grbm # oh-my-zsh sets this
alias grbm='gfa; git rebase origin/$(git_main_branch)'
alias gmt='gmtl' # git plugin replaced gmt with gmtl
alias gdt='git difftool'


## Copy latest commit hash to clipboard
alias gtop='git log -1 --format="%H" | cat | xargs echo -n | pbcopy'

## Delete local branches that no longer exist on remote (probably due to merge)
alias gdlb="git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D"

