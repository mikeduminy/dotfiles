local liveGrepRelative = function()
  local current_file_path = vim.api.nvim_buf_get_name(0)

  -- remove oil:// prefix if function is run from oil:// buffer
  if current_file_path:sub(1, 6) == "oil://" then
    current_file_path = current_file_path:sub(7)
  end

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

local files = function()
  require("lazyvim.util").telescope("find_files", { cwd = require("lazyvim.util").get_root() })()
end

local notifications = function()
  require("telescope").extensions.notify.notify()
end

local resumePicker = function()
  require("telescope.builtin").resume({ initial_mode = "normal" })
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
    { "<leader>ff", files, desc = "Find Files" },
    { "<leader>fb", openBuffers, desc = "Buffers" },
    { "<leader>fo", prevFiles, desc = "Recent (old files)" },
    { "<leader>f/", liveGrepRelative, desc = "Find in Files (Grep)" },
    { "<leader>fr", resumePicker, desc = "Resume Last Picker" },
    { "<leader>sN", notifications, desc = "Notifications" },
  },
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
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
      file_ignore_patterns = { "neo-tree ", "oil://" },
    },
    pickers = {
      buffers = {
        theme = "dropdown",
        initial_mode = "insert",
        preview = {
          hide_on_startup = true,
        },
        ignore_current_buffer = true,
        show_all_buffers = false, -- ignore unloaded buffers
        sort_lastused = true,
        sort_mru = true,
      },
      live_grep = {
        path_display = { shorten = { len = 4, exclude = { 1, -1 } } },
        mappings = {
          i = {
            -- filter live_grep by file extension
            ["<c-f>"] = require("plugins.search.telescope.custom-pickers").actions.set_extension,
          },
        },
        additional_args = function(opts)
          return { "--smart-case", "--hidden" }
        end,
      },
      old_files = {
        initial_mode = "normal",
      },
    },
    extensions = { "notify" },
  },
}
