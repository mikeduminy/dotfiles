-- Partial copy and adjustment of used parsers from: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/lua/nvim-treesitter/parsers.lua

-- @
return {
  -- Example: Multi-parser repo with explicit paths
  typescript = {
    repo = "https://github.com/tree-sitter/tree-sitter-typescript.git",
    ref = nil, -- nil = default branch, or use "v0.21.1", "main", or commit hash
    parsers = {
      { name = "typescript", grammar = "typescript/src/grammar.json", build_dir = "typescript" },
      { name = "tsx", grammar = "tsx/src/grammar.json", build_dir = "tsx" },
    },
  },

  markdown = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-markdown.git",
    ref = nil,
    parsers = {
      {
        name = "markdown",
        grammar = "tree-sitter-markdown/src/grammar.json",
        build_dir = "tree-sitter-markdown/",
      },
      {
        name = "markdown_inline",
        grammar = "tree-sitter-markdown-inline/src/grammar.json",
        build_dir = "tree-sitter-markdown-inline/",
      },
    },
  },

  cpp = {
    repo = "https://github.com/tree-sitter/tree-sitter-cpp.git",
    ref = nil,
    parsers = {
      { name = "cpp", grammar = "src/grammar.json", build_dir = "./" },
    },
  },

  -- Example: Custom repo with pinned branch
  fish = {
    repo = "https://github.com/ram02z/tree-sitter-fish.git",
    ref = "main",
  },

  -- Example: Simple custom repo (defaults to single parser)
  dockerfile = {
    repo = "https://github.com/camdencheek/tree-sitter-dockerfile.git",
    ref = nil,
  },

  cmake = {
    repo = "https://github.com/uyha/tree-sitter-cmake",
  },

  csv = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-csv",
    parsers = {
      { name = "csv", grammar = "csv/src/grammar.json", build_dir = "csv" },
      { name = "tsv", grammar = "tsv/src/grammar.json", build_dir = "tsv" },
      { name = "psv", grammar = "psv/src/grammar.json", build_dir = "psv" },
    },
  },

  diff = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-diff",
  },

  editorconfig = {
    repo = "https://github.com/ValdezFOmar/tree-sitter-editorconfig",
  },

  git_config = {
    repo = "https://github.com/the-mikedavis/tree-sitter-git-config",
  },

  git_rebase = {
    repo = "https://github.com/the-mikedavis/tree-sitter-git-rebase",
  },

  gitattributes = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-gitattributes",
  },

  gitcommit = {
    repo = "https://github.com/gbprod/tree-sitter-gitcommit.git",
  },

  gitignore = {
    repo = "https://github.com/shunsambongi/tree-sitter-gitignore.git",
  },

  gomod = {
    repo = "https://github.com/camdencheek/tree-sitter-go-mod.git",
  },

  gosum = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-go-sum.git",
  },

  gotmpl = {
    repo = "https://github.com/ngalaiko/tree-sitter-go-template.git",
  },

  gowork = {
    repo = "https://github.com/omertuc/tree-sitter-go-work.git",
  },

  helm = {
    repo = "https://github.com/ngalaiko/tree-sitter-go-template",
    parsers = { { name = "helm", grammar = "dialects/helm/src/grammar.json", build_dir = "dialects/helm" } },
  },

  gpg = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-gpg-config.git",
  },

  htmldjango = {
    repo = "https://github.com/interdependence/tree-sitter-htmldjango.git",
  },

  http = {
    repo = "https://github.com/rest-nvim/tree-sitter-http.git",
  },

  javadoc = {
    repo = "https://github.com/rmuir/tree-sitter-javadoc.git",
  },

  jq = {
    repo = "https://github.com/flurie/tree-sitter-jq.git",
  },

  json5 = {
    repo = "https://github.com/Joakker/tree-sitter-json5.git",
  },

  latex = {
    repo = "https://github.com/latex-lsp/tree-sitter-latex.git",
  },

  lua = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-lua.git",
  },

  luadoc = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-luadoc.git",
  },

  make = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-make.git",
  },

  matlab = {
    repo = "https://github.com/acristoffers/tree-sitter-matlab.git",
  },

  nginx = {
    repo = "https://github.com/opa-oz/tree-sitter-nginx.git",
  },

  proto = {
    repo = "https://github.com/coder3101/tree-sitter-proto.git",
  },

  ssh_config = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-ssh-config.git",
  },

  tmux = {
    repo = "https://github.com/Freed-Wu/tree-sitter-tmux.git",
  },

  toml = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-toml.git",
  },

  vim = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-vim.git",
  },

  vimdoc = {
    repo = "https://github.com/neovim/tree-sitter-vimdoc.git",
  },

  xml = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-xml.git",
    parsers = {
      { name = "xml", grammar = "xml/src/grammar.json", build_dir = "xml" },
      { name = "dtd", grammar = "dtd/src/grammar.json", build_dir = "dtd" },
    },
  },

  vue = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-vue.git",
    parsers = {
      { name = "vue", grammar = "src/grammar.json", build_dir = "./" },
    },
  },

  yaml = {
    repo = "https://github.com/tree-sitter-grammars/tree-sitter-yaml",
    ref = nil,
  },

  zsh = {
    repo = "https://github.com/georgeharker/tree-sitter-zsh.git",
  },
}
