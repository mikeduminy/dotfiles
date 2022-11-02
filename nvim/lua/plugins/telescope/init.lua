local telescope = require 'telescope'
local previewers = require 'telescope.previewers'
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

telescope.setup {
  defaults = {
    mappings = {
      i = { ['<c-t>'] = trouble.open_with_trouble },
      n = { ['<c-t>'] = trouble.open_with_trouble },
    },
    file_ignore_patterns = { '.git/' },
    cache_picker = {
      num_pickers = 10,
      limit_entries = 1000,
    },
    buffer_previewer_maker = custom_buffer_preview_maker,
  },
  pickers = {
    find_files = {
      hidden = true,
      theme = 'dropdown',
    },
    git_files = {
      theme = 'dropdown',
    },
    live_grep = {},
    buffers = {
      theme = 'dropdown',
    },
    help_tags = {
      theme = 'dropdown',
    },
  },
}

telescope.load_extension 'fzf'
