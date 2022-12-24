local M = {
  'Yggdroot/indentLine',
  init = function()
    vim.g.vim_json_conceal = 0
    vim.g.markdown_syntax_conceal = 0
    vim.g.indentLine_fileTypeExclude = { 'dashboard' }
  end
}

return M
