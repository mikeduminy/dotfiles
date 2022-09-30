local strcmd = require 'utils.keymaps'.strcmd

local troubleNext = function()
  require 'trouble'.next({ skip_groups = true, jump = true })
end

local troublePrev = function()
  require 'trouble'.previous({ skip_groups = true, jump = true })
end

local M = {
  ['<leader>x'] = {
    name = 'Trouble',
    x = { strcmd 'TroubleToggle', 'Trouble - Toggle' },
    q = { strcmd 'TroubleClose', 'Trouble - Close' },
    w = { strcmd 'Trouble workspace_diagnostics', 'Trouble - Workspace Diagnostics' },
    d = { strcmd 'Trouble document_diagnostics', 'Trouble - Document Diagnostics' },
    l = { strcmd 'Trouble loclist', 'Trouble - Loclist' },
    f = { strcmd 'Trouble quickfix', 'Trouble - Quickfix' },
    n = { troubleNext, 'Trouble - Next Entry' },
    p = { troublePrev, 'Trouble - Prev Entry' },
  },
  gR = { strcmd 'Trouble lsp_references', 'Trouble - References' },
}

return M
