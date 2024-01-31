return {
  "ahmedkhalf/project.nvim",
  opts = function(plugin, _opts)
    -- get list of projects from env
    local project_roots_str = os.getenv("PROJECT_ROOTS")
    if project_roots_str == nil then
      return _opts
    end

    -- can be nil (sad sad)
    _opts.patterns = _opts.patterns or {}

    -- convert to list
    local project_roots = vim.split(project_roots_str, ":")

    for _, v in ipairs(project_roots) do
      -- remove empty strings
      if v ~= "" then
        -- get basename
        local parent_folder = require("utils.file").basename(v)
        table.insert(_opts.patterns, ">" .. parent_folder)
      end
    end

    return _opts
  end,
}
