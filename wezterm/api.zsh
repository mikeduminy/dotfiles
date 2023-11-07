# source: https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
# watch discussion: https://github.com/wez/wezterm/discussions/3534
# watch issue: https://github.com/wez/wezterm/issues/3542
function wezterm-send-user-event() {
	printf "\033]1337;SetUserVar=%s=%s\007" custom-user-event $1
}

# hacky way to switch workspace via the wezterm cli
function wezterm-switch-workspace() {
	args=$(jq -n --arg cmd "switch-workspace" --arg workspace "$1" --arg cwd "$2" '{"cmd":$cmd,"workspace":$workspace,"cwd":$cwd}' | base64)
  wezterm-send-user-event $args
}

