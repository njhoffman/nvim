local state = require("synshade.state")
-- local utils = require("synshade.utils")

--- Create an `:h augroup` for autocommands used by this plugin
---
---@return number # handle for created augroup
local function create_augroup()
  return vim.api.nvim_create_augroup("_synshade", { clear = true })
end

--- Triggered by SynshadeFocusChangeEvents.focus
---
--- Restore the default highlight namespace
---
---@param event table arguments from the associated `:h nvim_create_autocmd` setup
local on_focus_or_close = function(event)
  if not check_enabled() then
    return
  end

  local winid = vim.api.nvim_get_current_win()
  if win_should_ignore_tint(winid) then
    return
  end

  if is_close_event(event) then
    handle_close_event()
  else
    synshade.untint(winid)
  end
end

--- Triggered by SynshadeFocusChangeEvents.unfocus
---
--- Set the synshade highlight namespace
---
---@param _ table? arguments from the associated `:h nvim_create_autocmd` setup
local on_unfocus = function(_)
  if not check_enabled() then
    return
  end

  local winid = vim.api.nvim_get_current_win()
  if win_should_ignore_tint(winid) then
    return
  end

  synshade.tint(winid)
end

--- Triggered by `:h ColorScheme`
---
--- Redefine highlights in both namespaces based on colors in new colorscheme
---
---@param _ table arguments from the associated `:h nvim_create_autocmd` setup
local on_colorscheme = function(_)
  if not check_enabled() then
    return
  end

  __.setup_all(true)
end

--- Ensure the passed function runs after `:h VimEnter` has run
---
---@param func function to call only after `VimEnter` is done
local function on_or_after_vimenter(func)
  if vim.v.vim_did_enter == 1 then
    func()
  else
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = func,
      once = true,
    })
  end
end

--- Handle triggering focus events after a window closes
---
--- See #38 for more context, but sometimes when a window is closed
--- the `:h WinEnter` event will not be triggered appropriately
local function handle_close_event()
  vim.schedule(function()
    synshade.untint(vim.api.nvim_get_current_win())
  end)
end

--- Check if the event is for a window closing
---
---@param event table Arguments from the associated `:h nvim_create_autocmd` setup
local function is_close_event(event)
  return event and event.event == "WinClosed"
end

--- Setup autocommands to swap (or reconfigure) synshade highlight namespaces
---
--- `__.user_config.focus_change_events.focus`: Tint the window
---  `__.user_config.focus_change_events.unfocus`: Untint the window
--- `ColorScheme`: When changing colorschemes, reconfigure the namespaces
local function setup_autocmds()
  if state.setup_autocmds then
    return
  end

  local augroup = create_augroup()
  local focus_events = state.user_config.focus_change_events.focus

  if not vim.tbl_contains(focus_events, "WinClosed") then
    table.insert(focus_events, "WinClosed")
  end

  vim.api.nvim_create_autocmd(state.user_config.focus_change_events.focus, {
    group = augroup,
    pattern = { "*" },
    callback = on_focus_or_close,
  })

  vim.api.nvim_create_autocmd(state.user_config.focus_change_events.unfocus, {
    group = augroup,
    pattern = { "*" },
    callback = on_unfocus,
  })

  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = augroup,
    pattern = { "*" },
    callback = on_colorscheme,
  })

  state.setup_autocmds = true
end

return setup_autocmds
