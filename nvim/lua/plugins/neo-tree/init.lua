local plugin = require 'neo-tree'

vim.g.neo_tree_remove_legacy_commands = 1

local rebalanceWindows = function(args)
  if (args.position == 'left' or args.position == 'right') then
    vim.cmd('wincmd =')
  end
end

plugin.setup({
  event_handlers = {
    { event = 'neo_tree_window_after_open', handler = rebalanceWindows },
    { event = 'neo_tree_window_after_close', handler = rebalanceWindows },
  },
  use_popups_for_input = false,
  close_if_last_window = false,
  enable_git_status = false,
  enable_diagnostics = true,
  sort_case_insensitive = false,
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- disable fuzzy finder
      ["/"] = "noop",
      ['<esc>'] = "esc",
    },
  },
  filesystem = {
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta"
      },
      always_show = { -- remains visible even if other settings would normally hide it
        ".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
        "thumbs.db",
        ".git"
      },
    },
    -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    follow_current_file = true,
    -- when true, empty folders will be grouped together
    group_empty_dirs = false,
    -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    hijack_netrw_behavior = "open_default",
    -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    use_libuv_file_watcher = true,
  },
  buffers = {
    -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    follow_current_file = true,
    -- when true, empty folders will be grouped together
    group_empty_dirs = true,
    show_unloaded = true,
  },
  source_selector = {
    statusline = false,
    winbar = false,
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
      width = "100%",
      right_padding = 0,
    },
  },
})
