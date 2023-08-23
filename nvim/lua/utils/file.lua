local M = {}

function M.readable(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

function M.is_directory(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end

function M.get_file_extension(url)
  return url:match("^.+(%..+)$")
end

function M.read(file_path)
  return vim.fn.readfile(file_path)
end

function M.get_current_file(opts)
  if opts and opts.relative then
    -- get current file relative to cwd
    return vim.fn.expand("%:~:.")
  end

  return vim.fn.expand("%")
end

function M.get_current_dir(opts)
  if opts and opts.absolute then
    -- get current dir relative to cwd
    return vim.fn.expand("%:~:.:h")
  end

  return vim.fn.expand("%:h")
end

function M.is_large_file(bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 50000
end

function M.get_root()
  return require("lazyvim.util").get_root()
end

return M
