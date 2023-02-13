local file = require("utils.file")

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
    end

    local function is_large_file(_lang, bufnr)
      return file.is_large_file(bufnr)
    end

    opts.context_commentstring.disable = is_large_file
    opts.highlight.disable = is_large_file
    opts.indent.disable = is_large_file
    opts.incremental_selection = is_large_file
  end,
  keys = function(_, _keys)
    -- a bug in treesitter might be causing a crash due to default keys in
    -- LazyVim so we need to remove these key bindings
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4000
    return {}
  end,
}
