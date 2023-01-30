return {
  "nvim-treesitter/nvim-treesitter",
  keys = function(_, keys)
    -- a bug in treesitter might be causing a crash due to default keys in
    -- LazyVim so we need to remove these key bindings
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4000
    return {}
  end,
}
