-- Install packer if missing
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path }
end

vim.cmd [[packadd packer.nvim]]

return require 'packer'.startup({ function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim' -- Speed-up startup time

  ---------------------------------------------------------------------
  -- Base plugins
  ---------------------------------------------------------------------
  use {
    'ThePrimeagen/harpoon',
    requires = { { 'nvim-lua/plenary.nvim' } },
  } -- Functions like fancy tabs
  use 'tpope/vim-commentary' -- Code comment support
  use 'tpope/vim-fugitive' -- Git integration
  use 'tpope/vim-repeat' -- Update repeat '.' functionality
  use 'tpope/vim-sensible' -- Defaults
  use 'tpope/vim-sleuth' -- Buffer defaults
  use 'tpope/vim-surround' -- Shortcuts for brackets/quotes/tags
  use 'base16-project/base16-vim' -- Theme provider

  ---------------------------------------------------------------------
  -- Nice-to-have plugins
  ---------------------------------------------------------------------
  use 'Yggdroot/indentLine' -- Visually represent initial line space tabs
  use 'lewis6991/gitsigns.nvim' -- Git indications in the line gutter
  use { 'alvan/vim-closetag', ft = 'HTML' } -- Auto close html tags
  use 'christoomey/vim-tmux-navigator' -- vim/tmux navigation integration
  use 'gpanders/editorconfig.nvim' -- Editorconfig defaults
  use 'glepnir/dashboard-nvim' -- Dashboard plugin
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
  } -- Dashboard plugin
  use {
    'akinsho/bufferline.nvim',
    tag = 'v2.*',
    requires = 'kyazdani42/nvim-web-devicons',
  } -- Visual top "tab" line for buffers
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  } -- Visual bottom "status" line
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  } -- Visual file tree
  use 'windwp/nvim-autopairs' -- Auto closing brackets
  use 'petertriho/nvim-scrollbar' -- Improved scrollbar
  use { 'folke/which-key.nvim', commit = "9c190ea91939eba8c2d45660127e0403a5300b5a~1" } -- Popup for keymap listings
  use 'folke/zen-mode.nvim' -- Distraction-free coding

  ---------------------------------------------------------------------
  -- LSP / IDE
  ---------------------------------------------------------------------

  -- Lua formatting (requires that stylua be installed)
  use { 'ckipp01/stylua-nvim', ft = 'lua' }

  -- List warning/error handling
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  }
  -- Fuzzy find
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
    },
  }
  use 'nvim-telescope/telescope-file-browser.nvim' -- File browser extension for Telescope

  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  -- Sticky context
  use 'nvim-treesitter/nvim-treesitter-context'

  -- Language Server Client
  use {
    'neovim/nvim-lspconfig',
    requires = {
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
    },
  }

  -- LSP progress visualisation
  use 'j-hui/fidget.nvim'

  -- Markdown previewing
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    ft = 'markdown'
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    },
  } })
