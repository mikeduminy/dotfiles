return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          init_options = {
            -- support large TS projects
            maxTsServerMemory = 8192,
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        ensure_installed = {
          "json-lsp",
          "lua-language-server",
          "stylua",
          "typescript-language-server",
        },
      })
    end,
  },
}
