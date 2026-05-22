local ABI_VERSION = "15" -- Change to "15" or "latest" if your Neovim uses tree-sitter >= 0.24

local log_to_file = require("modules.treesitter.utils").log_to_file

local function install_parser(lang)
  -- Resolve config or create default fallback
  local PARSER_CONFIGS = require("modules.treesitter.parsers")
  local cfg = PARSER_CONFIGS[lang] or { repo = "https://github.com/tree-sitter/tree-sitter-" .. lang .. ".git" }
  if not cfg.parsers then
    cfg.parsers = { { name = lang } }
  end

  local ext = vim.fn.has("win32") == 1 and ".dll" or (vim.fn.has("mac") == 1 and ".dylib" or ".so")
  local base_dir = vim.fn.stdpath("data") .. "/tree-sitter"
  local parser_dir = base_dir .. "/parser"
  vim.fn.mkdir(parser_dir, "p")

  -- Add to runtimepath for current session
  local rtp = vim.opt.rtp:get()
  if not vim.tbl_contains(rtp, base_dir) then
    vim.opt.rtp:append(base_dir)
  end

  local tmp_dir = vim.fn.tempname() .. "_ts_" .. lang
  local success = true

  -- 1. Clone repository
  log_to_file(("Cloning %s ..."):format(cfg.repo))
  local clone = vim.system({ "git", "clone", cfg.repo, tmp_dir }):wait()
  if clone.code ~= 0 then
    vim.fn.delete(tmp_dir, "rf")
    log_to_file("Clone failed. Check URL and network.")
    return
  end

  -- 2. Checkout specific ref if provided
  if cfg.ref then
    log_to_file(("Checking out ref: %s"):format(cfg.ref))
    local checkout = vim.system({ "git", "-C", tmp_dir, "checkout", cfg.ref }):wait()
    if checkout.code ~= 0 then
      vim.fn.delete(tmp_dir, "rf")
      log_to_file(("Checkout failed for ref: %s"):format(cfg.ref))
      return
    end
  end

  -- 3. Generate & Build each parser
  for _, p in ipairs(cfg.parsers) do
    local parser_name = p.name
    local grammar_path = p.grammar
    local build_dir = p.build_dir or "."
    local output_path = parser_dir .. "/" .. parser_name .. ext

    -- Skip if already exists
    if vim.uv.fs_stat(output_path) then
      log_to_file(("Skipping %s: already installed."):format(parser_name))
      -- vim.treesitter.language.register({ parser_name }, parser_name)
      goto continue
    end

    -- Generate C source
    log_to_file(("Generating %s ..."):format(parser_name))
    local gen_cmd = { "tree-sitter", "generate", "--abi", ABI_VERSION }
    if grammar_path then
      table.insert(gen_cmd, grammar_path)
    end
    local gen = vim.system(gen_cmd, { cwd = tmp_dir }):wait()
    if gen.code ~= 0 then
      log_to_file(("Generation failed for %s. Grammar may require ABI > %s"):format(parser_name, ABI_VERSION))
      success = false
      break
    end

    -- Compile shared library
    log_to_file(("Building %s ..."):format(parser_name))
    local build_cmd = { "tree-sitter", "build", "-o", output_path, build_dir }
    local build = vim.system(build_cmd, { cwd = tmp_dir }):wait()
    if build.code ~= 0 then
      log_to_file(("Build failed for %s. Ensure C compiler & tree-sitter CLI are in PATH."):format(parser_name))
      success = false
      break
    end

    log_to_file(("Successfully installed %s."):format(parser_name))
    -- vim.treesitter.language.register({ parser_name }, parser_name)

    ::continue::
  end

  -- Add this to install_parser() after successful build:
  local queries_dir = tmp_dir .. "/queries"
  log_to_file(("Check if parser has queries: %s"):format(queries_dir))
  if vim.uv.fs_stat(queries_dir) then
    local target_queries = base_dir .. "/queries/" .. lang
    vim.fn.mkdir(target_queries, "p")
    vim.fn.system("cp -r " .. queries_dir .. "/* " .. target_queries .. "/")
    log_to_file(("Installed queries for %s"):format(lang))
  end

  -- 4. Cleanup
  vim.fn.delete(tmp_dir, "rf")
  if not success then
    log_to_file("Installation aborted due to errors.")
  end
end

return install_parser
