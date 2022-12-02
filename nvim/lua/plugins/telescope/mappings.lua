local luacmd = require('utils.keymaps').luacmd

local findFiles = function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").find_files({ search_dirs = { cwd } })
end

local liveGrep = function()
  local dir = vim.fn.getcwd()
  require("telescope.builtin").live_grep({ search_dirs = { cwd = dir } })
end

local openBuffers = function()
  require("telescope.builtin").buffers({ only_cwd = true })
end

local prevFiles = function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end


local M = {
  ['<leader>f'] = {
    name = 'Telescope - Files',
    b = { openBuffers, 'Search buffers' },
    f = { luacmd 'require("telescope.builtin").git_files()', 'Search git files' },
    g = { liveGrep, "Live grep" },
    k = { findFiles, 'Find files' },
    o = { prevFiles, 'Previous files' },
    q = { luacmd 'require("telescope.builtin").quickfix()', 'Quickfix' },
    r = { luacmd 'require("telescope.builtin").resume()', 'Resume last picker' },
  },
  ['<leader>s'] = {
    name = 'Telescope - Other',
    E = { luacmd 'require("telescope.builtin").reloader()', 'Reload modules' },
    c = { luacmd 'require("telescope.builtin").command_history()', 'Command history' },
    F = { luacmd 'require("telescope.builtin").filetypes()', 'Choose filetype' },
    h = { luacmd 'require("telescope.builtin").help_tags()', 'Search help tags' },
    m = { luacmd 'require("telescope.builtin").keymaps()', 'Keymaps' },
    p = { luacmd 'require("telescope.builtin").pickers()', 'Search pickers' },
    r = { luacmd 'require("telescope.builtin").resume()', 'Resume last picker' },
    R = { luacmd 'require("telescope.builtin").registers()', 'Registers' },
  },
  ['<leader>p'] = { luacmd 'require("telescope.builtin").builtin()', 'Pick from pickers' }
}

return M
