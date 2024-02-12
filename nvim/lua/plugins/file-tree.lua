return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
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
        ["<S-k>"] = "actions.parent",
        ["<S-j>"] = {
          callback = function()
            -- only allow this keybinding to open directories
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            if entry and entry.type == "directory" then
              oil.select()
            end
          end,
        },
        ["<C-p>"] = "actions.preview",
        ["<CR>"] = "actions.select",
        ["<Leader>_"] = "actions.select_split",
        ["<Leader>|"] = "actions.select_vsplit",
        ["R"] = "actions.refresh",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        ["g?"] = "actions.show_help",
        ["<C-t>"] = "actions.select_tab",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return (name == "..")
        end,
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
