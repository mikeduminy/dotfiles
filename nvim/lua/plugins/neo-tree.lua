return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        -- disable fuzzy finder (allow vi text search)
        ["/"] = "noop",
        -- disable help (allow vi text search)
        ["?"] = "noop",

        -- remap for help
        ["h"] = "show_help",

        -- disable split keys (allow leap motions)
        ["s"] = "noop",
        ["S"] = "noop",

        -- remap split keys
        ["sh"] = "open_split",
        ["sv"] = "open_vsplit",
      },
    },
  },
}
