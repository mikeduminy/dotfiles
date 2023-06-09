return {
  "neovim/nvim-lspconfig",
  opts = {
    autoformat = true,
    servers = {
      tsserver = {
        init_options = {
          -- support large TS projects
          maxTsServerMemory = 8192,
          disableAutomaticTypingAcquisition = true,
        },
        preferences = {
          includeCompletionsForModuleExports = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        },
      },
    },
    setup = {
      tsserver = function(_, opts)
        opts.capabilities.documentFormattingProvider = false
      end,
      -- eslint = function(_, opts)
      --   opts.capabilities.documentFormattingProvider = false
      -- end,
    },
  },
}
