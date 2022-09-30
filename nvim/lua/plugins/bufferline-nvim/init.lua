require('bufferline').setup {
  options = {
    mode = 'buffers',
    always_show_bufferline = true,
    diagnostics = true,
    left_mouse_command = 'buffer %d',
    offsets = {
      {
        filetype = 'neo-tree',
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = 'Directory',
        text_align = 'left',
      },
    },
    groups = {
      items = {
        require('bufferline.groups').builtin.pinned:with { icon = '' },
      },
    },
  },
}
