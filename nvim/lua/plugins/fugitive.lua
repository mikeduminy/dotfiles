local register = require 'utils.keymaps'.register

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
    vim.cmd.bdelete(fugitiveBuffer)
  else
    -- open fugitive
    vim.cmd.Git()
  end
end

local mappings = {
  ['<leader>gg'] = { toggleGitFugitive, 'Open Git Fugitive' },
}

local M = {
  'tpope/vim-fugitive',
  cmd = 'Git',
  init = function()
    register(mappings)
  end
}

return M
