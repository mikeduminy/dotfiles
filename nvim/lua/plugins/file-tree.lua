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
        follow_current_file = { enabled = true },
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
        local firstArg = vim.fn.argv(0)
        ---@diagnostic disable-next-line: param-type-mismatch not actually a mismatch
        local stat = vim.loop.fs_stat(firstArg)
        if stat and stat.type == "directory" then
          require("oil")
        end
      end
    end,
    opts = {
      use_default_keymaps = false,
      keymaps = {
        ["-"] = "actions.parent",
        ["<C-p>"] = "actions.preview",
        ["<CR>"] = "actions.select",
        ["<Leader>_"] = "actions.select_split",
        ["<Leader>|"] = "actions.select_vsplit",
        ["<esc>"] = "actions.close",
        ["?"] = "actions.show_help",
        ["R"] = "actions.refresh",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.tcd",
        ["q"] = "actions.close",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
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
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
