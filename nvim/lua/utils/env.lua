local env = vim.fn.environ()

local M = {
  debug = env.DEBUG == '1'
}

return M
