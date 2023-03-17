return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- swap e and E
    { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<BS>",
      function()
        require("neo-tree.command").execute({ position = "current", reveal = true, dir = vim.loop.cwd() })
      end,
      desc = "Open NeoTree in current window",
      remap = true,
    },
  },
  opts = {
    filesystem = {
      filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      bind_to_cwd = true,
      cwd_target = { current = "tab" },
    },
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
      position = "left",
    },
  },
}
