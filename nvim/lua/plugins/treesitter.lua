local file = require("utils.file")

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    local max_file_size = 1024 * 1024
    local function is_large_file(_lang, bufnr)
      local bufsize = file.get_buf_size(bufnr)
      if bufsize and bufsize > max_file_size then
        vim.notify("File is too large to enable treesitter", vim.log.levels.WARN)
        return true
      end
      return false
    end

    if opts.context_commentstring then
      opts.context_commentstring.disable = is_large_file
    end
    opts.highlight.disable = is_large_file
    opts.indent.disable = is_large_file
    opts.incremental_selection.disable = is_large_file

    opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed, { "groovy" })
    return opts
  end,
}
