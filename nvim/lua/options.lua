local resolve_module = require 'utils.resolve_module'
local opt = vim.opt
local g = vim.g

-----------------------------------------------------------------------
-- General
-----------------------------------------------------------------------
opt.modifiable = true
opt.shell = '/bin/zsh' -- https://superuser.com/questions/287994/how-to-specify-shell-for-vim
opt.fileencoding = 'utf-8'
opt.linebreak = true -- Break lines at word (requires Wrap lines)
opt.showbreak = '+++' -- Wrap-broken line prefix
opt.textwidth = 80 -- Line wrap (number of cols)
opt.showmatch = true -- Highlight matching brace
opt.visualbell = true -- Use visual bell (no beeping)
opt.cursorline = true -- Highlight current line
opt.hlsearch = true -- Highlight all search results
opt.smartcase = true -- Enable smart-case search
opt.ignorecase = true -- Always case-insensitive
opt.backupcopy = 'yes'
opt.swapfile = true
opt.smartcase = true
opt.laststatus = 2
opt.incsearch = true
opt.ignorecase = true
opt.scrolloff = 12
opt.number = true -- line numbers and distances
opt.relativenumber = true -- Show relative line numbers
opt.undolevels = 1000 -- Number of undo levels
opt.undofile = true
opt.errorbells = false
opt.jumpoptions = 'stack' -- use a browser-like jumplist
opt.cmdheight = 0 -- hide the cmdline

-- splits
--- ensure splits always happen right and below
opt.splitright = true
opt.splitbelow = true
--- splits borders should be regular lines (use defaults)
opt.fillchars = ''

-- vim.g.netrw_liststyle = 3 -- tree-style explorer
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

-- goto file (gf) settings
_G.resolve_module = resolve_module --
opt.path = '.,src' -- goto file (gf) should search these paths
opt.suffixesadd = '.js,.jsx,.ts,.tsx'
opt.includeexpr = 'v:lua.resolve_module(v:fname)' -- goto file (gf) on a package reference runs this command
opt.isfname = '@,48-57,/,.,-,_,+,,,#,$,%,~,=,@-@' -- default file name pattern with added @-@ to match scoped packages

-----------------------------------------------------------------------
-- Neovide settings
-----------------------------------------------------------------------
if (g.neovide == true) then
  g.neovide_refresh_rate = 60
  g.neovide_refresh_rate_idle = 5
  g.neovide_transparency = 0.95
  g.neovide_floating_blue_amount_x = 2.0
  g.neovide_floating_blue_amount_y = 2.0
  g.neovide_scroll_animation_length = 0.3
  g.neovide_confirm_quit = true
  g.neovide_remember_window_size = true
  g.neovide_input_use_logo = true
  g.neovide_cursor_animation_length = 0.05
  g.neovide_cursor_trail_length = 0.1
end
