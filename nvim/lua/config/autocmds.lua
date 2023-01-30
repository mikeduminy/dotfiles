-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("Filetype", {
  pattern = {
    "neotree",
    "markdown",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  desc = "Disable mini.indentscope on certain filetypes",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  callback = function()
    vim.cmd.EslintFixAll()
  end,
  desc = "ESLint run fix all on save",
})
