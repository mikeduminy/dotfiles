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
        ["<C-p>"] = "actions.preview",
        ["<CR>"] = "actions.select",
        ["<Leader>_"] = "actions.select_split",
        ["<Leader>|"] = "actions.select_vsplit",
        ["?"] = "actions.show_help",
        ["R"] = "actions.refresh",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.tcd",
        ["q"] = "actions.close",
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
