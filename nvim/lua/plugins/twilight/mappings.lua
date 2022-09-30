local luacmd = require 'utils.keymaps'.luacmd

local M = {
  ["<leader>zt"] = { luacmd "require('twilight').toggle()", 'Twilight Toggle' },
}

return M
