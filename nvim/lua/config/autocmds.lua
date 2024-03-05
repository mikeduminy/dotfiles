-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local file = require("utils.file")

vim.api.nvim_create_autocmd("Filetype", {
  pattern = {
    "neotree",
    "markdown",
    "oil",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  desc = "Disable mini.indentscope on certain filetypes",
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(data)
    local bufsize = file.get_buf_size(data.buf)
    if bufsize then
      local max_file_size = 1024 * 1024 -- 1MiB
      if bufsize > max_file_size then
        vim.b.miniindentscope_disable = true
      end
    end
  end,
  desc = "Disable mini.indentscope on large files",
})
