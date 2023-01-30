return {
  "neovim/nvim-lspconfig",
  opts = {
    autoformat = false,
    servers = {
      jsonls = {
        settings = {
          json = {
            format = {
              enable = true,
            },
          },
        },
      },
      tsserver = {
        init_options = {
          -- support large TS projects
          maxTsServerMemory = 8192,
        },
      },
      eslint = {},
    },
  },
}
