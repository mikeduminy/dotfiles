#################################################################
# Shell file loaded in login shells                             #
# .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout         #
#            ^^^^^^^^^                                          #
#################################################################

# uncomment the following line to output when this file is loaded
# echo "loading: $0"

current_dir=$(dirname "${BASH_SOURCE:-$0}")
source "$current_dir/../setup/shared-env-vars.sh"
