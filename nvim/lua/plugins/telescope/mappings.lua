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
    b = { luacmd 'require("telescope.builtin").buffers()', 'Search buffers' },
    c = { luacmd 'require("telescope.builtin").command_history()', 'Command history' },
    E = { luacmd 'require("telescope.builtin").reloader()', 'Reload modules' },
    f = { luacmd 'require("telescope.builtin").git_files()', 'Search git files' },
    F = { luacmd 'require("telescope.buildin").filetypes()', 'Choose filetype' },
    g = { liveGrep, "Live grep" },
    h = { luacmd 'require("telescope.builtin").help_tags()', 'Search help tags' },
    k = { findFiles, 'Find files' },
    m = { luacmd 'require("telescope.builtin").keymaps()', 'Keymaps' },
    o = { luacmd 'require("telescope.builtin").oldfiles()', 'Previous files' },
    p = { luacmd 'require("telescope.builtin").builtin()', 'Pick from pickers' },
    P = { luacmd 'require("telescope.builtin").pickers()', 'Search pickers' },
    q = { luacmd 'require("telescope.builtin").quickfix()', 'Quickfix' },
    r = { luacmd 'require("telescope.builtin").resume()', 'Resume last picker' },
    R = { luacmd 'require("telescope.builtin").registers()', 'Registers' },
  },
}

return M
