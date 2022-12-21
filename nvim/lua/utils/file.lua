local M = {}

function M.readable(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

function M.is_directory(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end

function M.get_file_extension(url)
  return url:match '^.+(%..+)$'
end

function M.read(file_path)
  return vim.fn.readfile(file_path)
end

function M.get_current_file(opts)
  if opts and opts.absolute then
    return vim.fn.expand '%'
  end

  -- get current file relative to cwd
  return vim.fn.expand '%:~:.'
end

return M
