# Join an array with a delimiter
function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

# Log functions
function _log() {
  # use gum if available
  if [ -n "$(command -v gum)" ]; then
    gum log --level "$1" "$2"
  else
    echo "[$1] $2"
  fi
}

alias info="_log info $1"
alias error="_log error $1"
alias warn="_log warn $1"
alias debug="_log debug $1"
alias fatal="_log fatal $1"
