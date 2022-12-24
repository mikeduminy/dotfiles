local strcmd = require 'utils.keymaps'.strcmd
local register = require 'utils.keymaps'.register

local troubleNext = function()
  require 'trouble'.next({ skip_groups = true, jump = true })
end

local troublePrev = function()
  require 'trouble'.previous({ skip_groups = true, jump = true })
end

local mappings = {
  ['<leader>x'] = { name = 'Trouble' },
  ['<leader>xx'] = { strcmd 'TroubleToggle', 'Trouble - Toggle' },
  ['<leader>xq'] = { strcmd 'TroubleClose', 'Trouble - Close' },
  ['<leader>xw'] = { strcmd 'Trouble workspace_diagnostics', 'Trouble - Workspace Diagnostics' },
  ['<leader>xd'] = { strcmd 'Trouble document_diagnostics', 'Trouble - Document Diagnostics' },
  ['<leader>xl'] = { strcmd 'Trouble loclist', 'Trouble - Loclist' },
  ['<leader>xf'] = { strcmd 'Trouble quickfix', 'Trouble - Quickfix' },
  ['<leader>xn'] = { troubleNext, 'Trouble - Next Entry' },
  ['<leader>xp'] = { troublePrev, 'Trouble - Prev Entry' },
  gR = { strcmd 'Trouble lsp_references', 'Trouble - References' },
}


local M = {
  'folke/trouble.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  keys = mappings,
  init = function()
    register(mappings)
  end,
  config = true,
}

return M
