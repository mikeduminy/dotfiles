-----------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)


-----------------------------------------------------------------------
-- Plugins
-----------------------------------------------------------------------

local plugins = {
  -----------------------------------------------------------------------
  -- Base plugins
  -----------------------------------------------------------------------
  'tpope/vim-commentary', -- Code comment support
  require 'plugins.fugitive', -- Git integration
  'tpope/vim-repeat', -- Update repeat '.' functionality
  'tpope/vim-sensible', -- Defaults
  'tpope/vim-sleuth', -- Buffer defaults
  'tpope/vim-surround', -- Shortcuts for brackets/quotes/tags
  'base16-project/base16-vim', -- Theme provider
  { 'folke/which-key.nvim', lazy = true }, -- loaded in mappings

  -----------------------------------------------------------------------
  -- Nice-to-have plugins
  -----------------------------------------------------------------------
  require 'plugins.harpoon', -- File hopper
  require 'plugins.indentline', -- Visually represent initial line space tabs
  require 'plugins.gitsigns', -- Git indications in the line gutter
  require 'plugins.editorconfig', -- Editorconfig defaults
  require 'plugins.dashboard', -- Dashboard plugin
  require 'plugins.lualine', -- Visual bottom 'status' line
  require 'plugins.neo-tree', -- Visual file tree
  require 'plugins.zen-mode', -- Distraction-free coding
  { 'kyazdani42/nvim-web-devicons', lazy = true, config = true },
  { 'alvan/vim-closetag', ft = 'HTML' }, -- Auto close html tags
  { 'windwp/nvim-autopairs', config = true }, -- Auto closing brackets
  {
    'iamcco/markdown-preview.nvim', -- Markdown previewing
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = 'markdown'
  },
  require 'plugins.trouble', -- List warning/error handling
  require 'plugins.telescope', -- Fuzzy find

  -- Syntax highlighting
  require 'plugins.treesitter',

  -- Language Server Client
  require 'plugins.lsp',
}

local opts = {
  defaults = {
    lazy = false, -- todo: configure lazy true
  },
  checker = {
    enabled = false,
    concurrency = 1,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }
    }
  }
}

require 'lazy'.setup(plugins, opts)
