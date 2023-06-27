local file = require("utils.file")

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    local function is_large_file(_lang, bufnr)
      return file.is_large_file(bufnr)
    end

    if opts.context_commentstring then
      opts.context_commentstring.disable = is_large_file
    end
    opts.highlight.disable = is_large_file
    opts.indent.disable = is_large_file
    opts.incremental_selection.disable = is_large_file

    return opts
  end,
}
