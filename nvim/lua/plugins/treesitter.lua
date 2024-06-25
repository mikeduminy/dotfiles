local file = require("utils.file")

local max_file_size = 512 * 1024 -- 512kb
local function is_large_file(_lang, bufnr)
  local bufsize = file.get_buf_size(bufnr)
  if bufsize and bufsize > max_file_size then
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    vim.notify_once("File is too large to enable treesitter: " .. buf_name, vim.log.levels.WARN)
    return true
  end
  return false
end

return {
  {
    -- configured in lazyvim
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local modules =
        { "context_commentstring", "highlight", "indent", "incremental_selection", "autotag", "textobjects" }

      for _, mod in ipairs(modules) do
        if opts[mod] then
          opts[mod].disable = is_large_file
        end
      end

      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed, { "groovy" })
      return opts
    end,
  },
  {
    -- configured in lazyvim.plugins.extras.editor.illuminate
    "RRethy/vim-illuminate",
    opts = {
      large_file_cutoff = 2000,
      should_enable = function(bufnr)
        return not is_large_file(nil, bufnr)
      end,
    },
  },
}
