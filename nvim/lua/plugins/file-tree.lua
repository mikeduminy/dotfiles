return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      -- swap e and E
      { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      -- {
      --   "<BS>",
      --   function()
      --     require("neo-tree.command").execute({ position = "current", reveal = true, dir = vim.loop.cwd() })
      --   end,
      --   desc = "Open NeoTree in current window",
      --   remap = true,
      -- },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      filesystem = {
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
        follow_current_file = true,
        -- hijack_netrw_behavior = "open_current",
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
  },
  {
    "stevearc/oil.nvim",
    init = function()
      -- If we're opening a directory, open oil
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("oil")
        end
      end
    end,
    opts = {
      columns = {
        "icon",
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["sv"] = "actions.select_vsplit",
        ["sh"] = "actions.select_split",
        ["st"] = "actions.select_tab",
        ["<esc>"] = "actions.close",
        ["R"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
    },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        { desc = "Open parent directory" },
      },
    },
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
