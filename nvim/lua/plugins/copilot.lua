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
}
