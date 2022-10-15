local strcmd = require 'utils.keymaps'.strcmd

local function toggleGitFugitive()
  local fugitiveBuffer = -1
  for _, win in pairs(vim.fn.getwininfo()) do
    if vim.api.nvim_buf_get_option(win.bufnr, "filetype") == "fugitive" then
      fugitiveBuffer = win.bufnr
      break
    end
  end

  if fugitiveBuffer > -1 then
    -- close fugitive
    vim.cmd("bd " .. fugitiveBuffer)
  else
    -- open fugitive
    vim.cmd("Git")
  end
end

local M = {
  ['<leader>gg'] = { toggleGitFugitive, 'Open Git Fugitive' },
}

return M
