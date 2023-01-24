-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--- splits borders should be regular lines (use defaults)
vim.opt.fillchars = ""

-- goto file (gf) settings
_G.resolve_module = require("utils.resolve_module")
vim.opt.path = ".,src" -- goto file (gf) should search these paths
vim.opt.suffixesadd = ".js,.jsx,.ts,.tsx"
vim.opt.includeexpr = "v:lua.resolve_module(v:fname)" -- goto file (gf) on a package reference runs this command
vim.opt.isfname = "@,48-57,/,.,-,_,+,,,#,$,%,~,=,@-@" -- default file name pattern with added @-@ to match scoped packages

vim.opt.scrolloff = 12
vim.opt.textwidth = 80 -- Line wrap (number of columns)
vim.opt.shell = "/bin/zsh" -- https://superuser.com/questions/287994/how-to-specify-shell-for-vim
