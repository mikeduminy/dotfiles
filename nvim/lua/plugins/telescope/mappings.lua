local luacmd = require('utils.keymaps').luacmd

local findFiles = function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").find_files({ search_dirs = { cwd } })
end

local liveGrep = function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").live_grep({ search_dirs = { cwd } })
end


local M = {
  ['<leader>f'] = {
    name = 'Telescope',
    f = { luacmd 'require("telescope.builtin").git_files()', 'Search git files' },
    g = { liveGrep, "Live grep" },
    b = { luacmd 'require("telescope.builtin").buffers()', 'Search buffers' },
    h = { luacmd 'require("telescope.builtin").help_tags()', 'Search help tags' },
  },
  ['<leader>k'] = { findFiles, 'Find files' },
  ['<leader>r'] = { luacmd 'require("telescope.builtin").resume()', 'Telescope - Resume last picker' },
  ['<leader>p'] = { luacmd 'require("telescope.builtin").pickers()', 'Telescope - Search pickers' },
  ['<leader>qf'] = { luacmd 'require("telescope.builtin").quickfix()', 'Telescope - Quickfix' },
  ['<leader>km'] = { luacmd 'require("telescope.builtin").keymaps()', 'Telescope - Keymaps' },
  ['<leader>ch'] = { luacmd 'require("telescope.builtin").command_history()', 'Telescope - Command history' },
  ['<leader>RR'] = { luacmd 'require("telescope.builtin").registers()', 'Telescope - Registers' },
  ['<leader>RE'] = { luacmd 'require("telescope.builtin").reloader()', 'Telescope - Reload modules' },
}

return M
