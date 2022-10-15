local telescope = require 'telescope'
local keymaps = require 'utils.keymaps'
local trouble = require 'trouble.providers.telescope'
local nmap = keymaps.nmap
local luacmd = keymaps.luacmd

-----------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------
telescope.setup {
  defaults = {
    mappings = {
      i = { ['<c-t>'] = trouble.open_with_trouble },
      n = { ['<c-t>'] = trouble.open_with_trouble },
    },
    file_ignore_patterns = { '.git/' },
    cache_picker = {
      num_pickers = 10,
      limit_entries = 1000,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      theme = 'dropdown',
    },
    git_files = {
      theme = 'dropdown',
    },
    live_grep = {},
    buffers = {
      theme = 'dropdown',
    },
    help_tags = {
      theme = 'dropdown',
    },
  },
}
telescope.load_extension 'fzf'
