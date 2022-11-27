local telescope = require 'telescope'
local previewers = require 'telescope.previewers'
local action_layout = require 'telescope.actions.layout'
local trouble = require 'trouble.providers.telescope'

local MAX_SIZE = 128 * 1024 -- 128kb

local function custom_buffer_preview_maker(filepath, bufnr, opts)
  opts = opts or {}

  -- disable in large files
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > MAX_SIZE then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local function custom_mime_hook(filepath, bufnr, opts)
  local is_image = function(filepath)
    local image_extensions = { 'png', 'jpg' } -- Supported image formats
    local split_path = vim.split(filepath:lower(), '.', { plain = true })
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

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<c-t>'] = trouble.open_with_trouble,
        ["<C-u>"] = false, -- clear the prompt instead of scrolling
        ["<M-p>"] = action_layout.toggle_preview,
      },
      n = {
        ['<c-t>'] = trouble.open_with_trouble,
        ["<M-p>"] = action_layout.toggle_preview,
      },
    },
    file_ignore_patterns = { '.git/' },
    cache_picker = {
      num_pickers = 10,
      limit_entries = 1000,
    },
    layout_strategy = 'bottom_pane',
    buffer_previewer_maker = custom_buffer_preview_maker,
    preview = {
      filesize_limit = MAX_SIZE,
      mime_hook = custom_mime_hook,
      treesitter = false,
    }
  },
  pickers = {
    find_files = {
      hidden = true,
      theme = 'ivy',
    },
    git_files = {
      prompt_prefix = 'Git>',
      theme = 'ivy',
    },
    live_grep = {
      theme = "ivy",
    },
    buffers = {
      theme = 'dropdown',
      initial_mode = 'normal',
      preview = {
        hide_on_startup = true,
      },
    },
    help_tags = {
      theme = 'ivy',
    },
    old_files = {
      theme = 'ivy',
      initial_mode = 'normal',
    }
  },
}

telescope.load_extension 'fzf'
