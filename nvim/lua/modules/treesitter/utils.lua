local LOG_FILE = vim.fn.stdpath("data") .. "/ts-install.log"

local function log_to_file(msg)
  print(msg)

  local f = io.open(LOG_FILE, "a")
  if f then
    f:write(msg .. "\n")
    f:close()
  end
end

return {
  log_to_file,
}
