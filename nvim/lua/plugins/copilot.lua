return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        -- lazyvim extra auto-connects copilot to cmp for LSP servers
        -- but these filetypes have no LSP servers
        filetypes = {
          zsh = true,
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", {
        mappings = {
          reset = {
            -- the default <C-l> mapping is used by Navigator
            normal = "<C-r>",
            insert = "<C-r>",
          },
        },
      }, opts)
      return opts
    end,
  },
}
