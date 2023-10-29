-- https://raw.githubusercontent.com/roobert/action-hints.nvim/main/lua/action-hints/init.lua

local config = require('action-hints.config')
local display = require('action-hints.display')

local setup = function(options)
  config.setup(options)
  display.set_highlights()
  vim.api.nvim_command([[autocmd OptionSet termguicolors lua require("action-hints.display").set_highlights()]])
  vim.api.nvim_command([[autocmd CursorMoved * lua require("action-hints.providers").update()]])
  vim.api.nvim_command([[autocmd CursorMovedI * lua require("action-hints.providers").update()]])
end

return { setup = setup }
