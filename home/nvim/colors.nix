-- Port of your base16-gruvbox-dark-medium Vimscript color config into Lua

-- Enable true color support
vim.opt.termguicolors = true

-- Run base16-shell script if available (for terminal color support)
if vim.fn.has('gui_running') == 0 and vim.g.base16_shell_path then
  local script = vim.g.base16_shell_path .. '/base16-gruvbox-dark-medium.sh'
  -- run silently
  vim.fn.jobstart({'sh', '-c', script}, {detach = true})
end

-- GUI colors
local gui = {
  gui00 = '282828', gui01 = '3c3836', gui02 = '504945', gui03 = '665c54',
  gui04 = 'bdae93', gui05 = 'd5c4a1', gui06 = 'ebdbb2', gui07 = 'fbf1c7',
  gui08 = 'fb4934', gui09 = 'fe8019', gui0A = 'fabd2f', gui0B = 'b8bb26',
  gui0C = '8ec07c', gui0D = '83a598', gui0E = 'd3869b', gui0F = 'd65d0e',
}
for k,v in pairs(gui) do vim.g['base16_'..k] = v end

-- Cterm colors
local cterm = {
  cterm00 = '00', cterm03 = '08', cterm05 = '07', cterm07 = '15',
  cterm08 = '01', cterm0A = '03', cterm0B = '02', cterm0C = '06',
  cterm0D = '04', cterm0E = '05',
}
for k,v in pairs(cterm) do vim.g['base16_'..k] = v end

-- Extended 256-color cterms
if vim.g.base16colorspace == '256' then
  local ext = {cterm01='18', cterm02='19', cterm04='20', cterm06='21', cterm09='16', cterm0F='17'}
  for k,v in pairs(ext) do vim.g['base16_'..k] = v end
else
  local ext = {cterm01='10', cterm02='11', cterm04='12', cterm06='13', cterm09='09', cterm0F='14'}
  for k,v in pairs(ext) do vim.g['base16_'..k] = v end
end

-- Neovim terminal colors
if vim.fn.has('nvim') == 1 then
  for i=0,15 do
    vim.g['terminal_color_'..i] = '#'..gui['gui0'..string.format('%X',i)] or gui.gui05
  end
  vim.g.terminal_color_background = gui.gui00
  vim.g.terminal_color_foreground = gui.gui05
  if vim.o.background == 'light' then
    vim.g.terminal_color_background = gui.gui07
    vim.g.terminal_color_foreground = gui.gui02
  end
end

-- Base16 colorscheme setup
vim.highlight.create('Normal', {guifg = nil, guibg = nil})
vim.cmd('hi clear')
vim.cmd('syntax reset')
vim.g.colors_name = 'base16-gruvbox-dark-medium'

-- Helper to define highlights
local function hi(group, args)
  vim.api.nvim_set_hl(0, group, args)
end

-- Define highlights (example for a few groups; expand as needed)
hi('Directory',     {fg='#'..gui.gui0D})
hi('Error',         {fg='#'..gui.gui00, bg='#'..gui.gui08})
hi('Search',        {fg='#'..gui.gui01, bg='#'..gui.gui0A})
