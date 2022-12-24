local cmd = vim.cmd
local g = vim.g

-- vim.opt.termguicolors = true
-- vim.cmd('highlight VertSplit ctermfg='..M.colors.base01)
-- :highlight VertSplit ctermfg=8 ctermbg=0 guifg=#282a2e guibg=#1d1f21

local base16_project_theme = os.getenv 'BASE16_THEME'
if base16_project_theme and g.colors_name ~= 'base16-' .. base16_project_theme then
  cmd 'let base16colorspace=256'
  cmd('colorscheme base16-' .. base16_project_theme)
end

local M = {}

local function guiColorsEnabled()
  return vim.opt.termguicolors:get() == true
end

local function getColor(index)
  local hex = string.upper(string.format('%02x', index))
  if guiColorsEnabled() then
    return '#' .. vim.api.nvim_get_var('base16_gui' .. hex)
  end
  local cterm_color = vim.api.nvim_get_var('base16_cterm' .. hex)
  return tonumber(cterm_color)
end

function M.getType()
  if guiColorsEnabled() then
    return 'gui'
  else
    return 'cterm'
  end
end

function M.getColors()
  return {
    base00 = getColor(0), -- Default Background
    base01 = getColor(1), -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = getColor(2), -- Selection Background
    base03 = getColor(3), -- Comments, Invisibles, Line Highlighting
    base04 = getColor(4), -- Dark Foreground (Used for status bars)
    base05 = getColor(5), -- Default Foreground, Caret, Delimiters, Operators
    base06 = getColor(6), -- Light Foreground (Not often used)
    base07 = getColor(7), -- Light Background (Not often used)
    base08 = getColor(8), -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = getColor(9), -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = getColor(10), -- Classes, Markup Bold, Search Text Background
    base0B = getColor(11), -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = getColor(12), -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = getColor(13), -- Functions, Methods, Attribute IDs, Headings
    base0E = getColor(14), -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = getColor(15), -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  }
end

return M
