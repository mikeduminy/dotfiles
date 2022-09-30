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

-----------------------------------------------------------------------
-- Keymaps
-----------------------------------------------------------------------
nmap('<leader>k', function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").find_files({ search_dirs = { cwd } })
end)
nmap('<leader>ff', luacmd 'require("telescope.builtin").git_files()')
nmap('<leader>fg', function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").live_grep({ search_dirs = { cwd } })
end)
nmap('<leader>fb', luacmd 'require("telescope.builtin").buffers()')
nmap('<leader>fh', luacmd 'require("telescope.builtin").help_tags()')
nmap('<leader>r', luacmd 'require("telescope.builtin").resume()')
nmap('<leader>p', luacmd 'require("telescope.builtin").pickers()')
nmap('<leader>qf', luacmd 'require("telescope.builtin").quickfix()')
nmap('<leader>km', luacmd 'require("telescope.builtin").keymaps()')
nmap('<leader>ch', luacmd 'require("telescope.builtin").command_history()')
nmap('<leader>RR', luacmd 'require("telescope.builtin").registers()')
nmap('<leader>RE', luacmd 'require("telescope.builtin").reloader()')
