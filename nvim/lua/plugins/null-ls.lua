return {
  "nvimtools/none-ls.nvim",
  opts = function()
    local builtins = require("null-ls").builtins
    return {
      sources = {
        builtins.formatting.stylua,
        builtins.code_actions.shellcheck,
        builtins.diagnostics.shellcheck,
      },
    }
  end,
}
