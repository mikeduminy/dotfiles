-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--- splits borders should be regular lines (use defaults)
vim.opt.fillchars = ""

-- goto file (gf) settings
_G.resolve_module = require("utils.resolve.resolve_module")

-- goto file (gf) should search these paths
vim.opt.path = ".,src"
vim.opt.suffixesadd = ".js,.jsx,.ts,.tsx"

-- goto file (gf) on a package reference runs this command
vim.opt.includeexpr = "v:lua.resolve_module(v:fname)"

-- default file name pattern with added @-@ to match scoped packages
vim.opt.isfname = "@,48-57,/,.,-,_,+,,,#,$,%,~,=,@-@"

-- larger bottom scroll offset
vim.opt.scrolloff = 12

-- Line wrap (number of columns)
vim.opt.textwidth = 80

-- https://superuser.com/questions/287994/how-to-specify-shell-for-vim
vim.opt.shell = "/bin/zsh"

-- use a tagstack/web-style jumplist navigation
vim.opt.jumpoptions = "stack"

-- Enable LazyVim autoformat
vim.g.autoformat = true
