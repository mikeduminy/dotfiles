local liveGrepRelative = function()
  local current_file_path = vim.fn.expand("%:p:h")

  vim.ui.input({ prompt = "Live grep in folder: ", default = current_file_path, completion = "dir" }, function(input)
    if input == nil then
      return
    end

    require("telescope.builtin").live_grep({ search_dirs = { input } })
  end)
end

local openBuffers = function()
  require("telescope.builtin").buffers({ only_cwd = true })
end

local prevFiles = function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end

local MAX_SIZE = 128 * 1024 -- 128kb

local function custom_mime_hook(filepath, bufnr, opts)
  local is_image = function(filepath)
    local image_extensions = { "png", "jpg" } -- Supported image formats
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(image_extensions, extension)
  end
  if is_image(filepath) then
    -- ## Uncomment to support image preview
    -- local term = vim.api.nvim_open_term(bufnr, {})
    -- local function send_output(_, data, _)
    --   for _, d in ipairs(data) do
    --     vim.api.nvim_chan_send(term, d .. '\r\n')
    --   end
    -- end

    -- vim.fn.jobstart(
    --   {
    --     'catimg', filepath -- Terminal image viewer command
    --   },
    --   { on_stdout = send_output, stdout_buffered = true })
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Image cannot be previewed")
  else
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
  end
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>fb", openBuffers, desc = "Buffers" },
    { "<leader>fr", prevFiles, desc = "Recent" },
    { "<leader>f/", liveGrepRelative, desc = "Find in Files (Grep)" },
    {
      "<leader>fN",
      function()
        require("telescope").extensions.notify.notify()
      end,
      desc = "Notifications",
    },
    {
      "<leader>fR",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume Last Picker",
    },
  },
  opts = {
    defaults = {
      -- enable the following if telescope hangs when previewing large files
      -- buffer_previewer_maker = custom_buffer_preview_maker,
      preview = {
        filesize_limit = MAX_SIZE,
        treesitter = false,
        mime_hook = custom_mime_hook,
      },
    },
    pickers = {
      live_grep = {
        path_display = { shorten = { len = 2, exclude = { 1, -1 } } },
        mappings = {
          i = {
            -- filter live_grep by file extension
            ["<c-f>"] = require("plugins.telescope.custom-pickers").actions.set_extension,
          },
        },
      },
    },
    extensions = { "notify" },
  },
}

-- -- might need these backup funtions
-- local function custom_buffer_preview_maker(filepath, bufnr, opts)
--   opts = opts or {}
--
--   -- disable in large files
--   vim.loop.fs_stat(filepath, function(_, stat)
--     if not stat then return end
--     if stat.size > MAX_SIZE then
--       return
--     else
--       require 'telescope.previewers'.buffer_previewer_maker(filepath, bufnr, opts)
--     end
--   end)
-- end
--
