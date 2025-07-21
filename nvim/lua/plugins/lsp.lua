--- Executes an LSP server command.
--- @param command string
--- @param args? lsp.LSPAny[]
local function execLspCommand(command, args)
  return function()
    vim.lsp.buf.execute_command({ command = command, arguments = args or nil })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>tsr", execLspCommand("typescript.restartTsServer") },
      { "<leader>tsl", execLspCommand("typescript.openTsServerLog") },
    },
    opts = {
      capabilities = {
        general = {
          positionEncodings = { "utf-8" },
        },
      },
      servers = {
        -- tsserver = {
        --   init_options = {
        --     -- support large TS projects
        --     maxTsServerMemory = 8192,
        --     -- disableAutomaticTypingAcquisition = true,
        --   },
        --   preferences = {
        --     includeCompletionsForModuleExports = false,
        --     includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --   },
        -- },
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 12 * 1024,
              },
            },
          },
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim" },
}
