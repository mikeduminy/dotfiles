local register = require 'utils.keymaps'.register
local luacmd = require 'utils.keymaps'.luacmd

local mappings = {
  ["<leader>zz"] = { luacmd 'require("zen-mode").toggle()', 'Zen-mode Toggle' },
}

local M = {
  'folke/zen-mode.nvim', -- Distraction-free coding
  keys = mappings,
  init = function()
    register(mappings)
  end,
  config = true
}

return M
