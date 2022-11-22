require 'impatient'

require 'setup'
require 'options'
require 'keybindings'

if not vim.g.vscode then
  require 'plugins'
else
  require 'plugins.vscode'
end
