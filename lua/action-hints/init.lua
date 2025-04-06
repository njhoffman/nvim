-- https://raw.githubusercontent.com/roobert/action-hints.nvim/main/lua/action-hints/init.lua

local config = require("action-hints.config")
local utils = require("action-hints.utils")
local state = require("action-hints.state")
local display = require("action-hints.display")
local providers = require("action-hints.providers")

local clear = function()
  display.clear_virtual_text()
  state.current = { references = 0, definitions = 0, codeactions = 0 }
  state.available = { references = false, definitions = false, codeactions = false }
  state.is_cleared = true
end

local setup = function(options)
  config.setup(options)
  display.set_highlights(config.values)

  -- create augroup named ActionHints
  local augroup = vim.api.nvim_create_augroup("ActionHints", { clear = true })
  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    group = augroup,
    desc = "ActionHints highlights setup",
    pattern = { "termguicolors" },
    callback = function()
      display.set_highlights(config.values)
    end,
  })

  vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = augroup,
    pattern = "*:i",
    desc = "ActionHints providers insert clear",
    callback = function()
      clear()
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = augroup,
    desc = "ActionHints providers update",
    callback = function()
      clear()
      if vim.api.nvim_get_mode().mode == "n" then
        utils.debounce(providers.update, 1000)(config.values)
        -- providers.update(config.values)
      end
    end,
  })
end

return { setup = setup }
