local M = {
  'gpanders/editorconfig.nvim',
  init = function()
    vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
  end
}

return M
