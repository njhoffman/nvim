---@diagnostic disable
--luacheck: ignore

local ok, lush = pcall(require, 'lush')
local ok_main, hl_main = pcall(require, 'colorschemes.nord-nick.main')
local ok_plugins, hl_plugins = pcall(require, 'colorschemes.nord-nick.plugins')
local ok_nord, nord = pcall(require, 'colorschemes.nord-nick.nord-nvim')

if not ok or not ok_nord or not ok_plugins or not ok_main then
  vim.notify('Problem loading nord-nick ', 1)
else
  local plugins = lush.extends({ nord }).with(hl_plugins)
  local main = lush.extends({ plugins }).with(hl_main)
  return main
end
