-- Pure Lua Tree-sitter installer (Neovim 0.10+ | CLI 0.24+)

local ensure_installed = {
  -- shell
  "bash",
  "zsh",

  -- javascript
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "jsx",
  "typescript",

  -- lua
  "lua",
  "luadoc",
  "luap",

  -- config
  "editorconfig",
  "toml",
  "yaml",

  -- docker
  "dockerfile",

  -- rust
  "rust",

  -- terraform
  "terraform",
  "hcl",

  -- native apps
  "groovy",
  "java",
  "kotlin",
  "objective-c",
  "swift",

  -- git
  "diff",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",

  -- go
  "go",
  "gomod",
  "gowork",
  "gosum",

  -- tools
  "jq",

  -- markdown
  "markdown",
  "markdown_inline",

  -- misc
  "c",
  "html",
  "printf",
  "python",
  "query",
  "regex",
  "xml",
}

vim.api.nvim_create_user_command("TSInstall", function(opts)
  local lang = opts.args:match("^%s*(%S+)%s*$")
  if not lang then
    print("Usage: :TSInstall <language>")
    return
  end
  local install_parser = require("modules.treesitter.install")
  install_parser(lang)
end, { nargs = 1 })
