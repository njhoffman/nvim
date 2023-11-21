-- https://raw.githubusercontent.com/roobert/action-hints.nvim/main/lua/action-hints/init.lua

local config = require('action-hints.config')
local utils = require('action-hints.utils')
local state = require('action-hints.state')

local setup = function(options)
  config.setup(options)
  local display = require('action-hints.display')
  local providers = require('action-hints.providers')
  display.set_highlights(config.values)

  -- create augroup named ActionHints
  local augroup = vim.api.nvim_create_augroup('ActionHints', { clear = true })
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    group = augroup,
    desc = 'ActionHints highlights setup',
    pattern = { 'termguicolors' },
    callback = function()
      display.set_highlights(config.values)
    end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = augroup,
    desc = 'ActionHints providers update',
    callback = function()
      utils.throttle(display.clear_virtual_text, 100, {}, 'clear')
      state.is_cleared = true
      utils.debounce(providers.update, 500)(config.values)
    end,
  })
end

return { setup = setup }
