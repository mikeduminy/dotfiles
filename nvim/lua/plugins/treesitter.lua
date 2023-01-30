return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
    end
  end,
  keys = function(_, keys)
    -- a bug in treesitter might be causing a crash due to default keys in
    -- LazyVim so we need to remove these key bindings
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4000
    return {}
  end,
}
