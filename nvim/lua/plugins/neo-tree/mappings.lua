local strcmd = require 'utils.keymaps'.strcmd
local vmap = require 'utils.keymaps'.vmap

local M = {
  ['<leader>t'] = { name = 'Neotree' },
  ['<leader>tt'] = { strcmd 'Neotree toggle', 'Toggle Neotree', mode = 'n' },
  ['<leader>tb'] = { strcmd 'Neotree toggle buffers', 'Toggle Neotree Buffers', mode = 'n' },
}

-- visual mapping is not supported right now with above structure
-- https://github.com/folke/which-key.nvim/issues/267
vmap('<leader>tt', strcmd 'Neotree toggle')
vmap('<leader>tb', strcmd 'Neotree toggle buffers')

return M
