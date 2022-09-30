local luacmd = require 'utils.keymaps'.luacmd

local M = {
  ["<leader>zz"] = { luacmd 'require("zen-mode").toggle()', 'Zen-mode Toggle' },
}

return M
