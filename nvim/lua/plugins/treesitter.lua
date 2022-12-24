local M = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context', -- Sticky context
  },
  build = ':TSUpdate',
  config = function()
    require 'nvim-treesitter.configs'.setup({
      ensure_installed = {
        'bash',
        'css',
        'help',
        'html',
        'java',
        'javascript',
        'lua',
        'markdown',
        'rust',
        'toml',
        'tsx',
        'vim',
        'yaml',
      },
      sync_install = false,
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          -- disable in large files
          local file = vim.api.nvim_buf_get_name(bufnr)
          --  n = file size in bytes
          --  0 = directory, so do nothing
          -- -1 = file not found, so do nothing
          -- -2 = file size too big to fit into Number
          local fileSize = vim.fn.getfsize(file)
          return fileSize == -2 or fileSize > 512 * 1024
        end
      },
    })
  end
}

return M
