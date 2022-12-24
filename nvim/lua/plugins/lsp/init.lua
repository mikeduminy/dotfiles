local M =
{
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/nvim-lsp-installer',

    -- Code completion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',

    -- Snippets for code completion
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- LSP progress visualisation
    'j-hui/fidget.nvim',
  },
  lazy = false,
  config = function()
    -- main lsp setup
    require 'plugins.lsp.nvim-lsp'

    -- code completion
    require 'plugins.lsp.nvim-cmp'

    -- LSP Progress Visualisation
    require 'fidget'.setup {}
  end
}

return M
