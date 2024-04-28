# source: https://github.com/wez/wezterm/blob/main/assets/shell-integration/wezterm.sh#L432C1-L445C2
# This function emits an OSC 1337 sequence to set a user var
# associated with the current terminal pane.
# It requires the `base64` utility to be available in the path.
__wezterm_set_user_var() {
  if hash base64 2>/dev/null ; then
    if [[ -z "${TMUX}" ]] ; then
      printf "\033]1337;SetUserVar=%s=%s\007" "$1" `echo -n "$2" | base64`
    else
      # <https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it>
      # Note that you ALSO need to add "set -g allow-passthrough on" to your tmux.conf
      printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$1" `echo -n "$2" | base64`
    fi
  fi
}

# source: https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
# watch discussion: https://github.com/wez/wezterm/discussions/3534
# watch issue: https://github.com/wez/wezterm/issues/3542
__wezterm_send_custom_user_event() {
  __wezterm_set_user_var custom-user-event $1
}

# hacky way to switch workspace via the wezterm cli
__wezterm_switch_workspace() {
  _workspace=$1
  _cwd=$2

	args=$(jq -n \
    --arg cmd "switch-workspace" \
    --arg workspace "$_workspace" \
    --arg cwd "$_cwd" \
    '{"cmd":$cmd,"workspace":$workspace,"cwd":$cwd}'
  )
  __wezterm_send_custom_user_event $args
}

