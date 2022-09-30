local strcmd = require 'utils.keymaps'.strcmd

local M = {
  ["[b"] = { strcmd 'BufferLineCycleNext', 'Next Buffer' },
  ["]b"] = { strcmd 'BufferLineCyclePrev', 'Previous Buffer' }
}

return M
