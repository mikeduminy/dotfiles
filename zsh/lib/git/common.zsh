source $(dirname $0)/../utils.zsh

# Check if main exists and use instead of master
# Copied from oh-my-zsh's git plugin
# Source - https://github.com/ohmyzsh/ohmyzsh/blob/2a109d30afe4ab164a946c307abc3d2a444a42ad/lib/git.zsh
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# Check if the current directory is a git repository
function is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

function ensure_git_repo() {
  is_git_repo || (error "Not in a git repo" && return 1)
}
