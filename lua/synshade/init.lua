local colors = require("synshade.colors")
local transforms = require("synshade.transforms")
local state = require("synshade.state")
local utils = require("synshade.utils")

---@class SynshadeHlGroupInfo
---@field hl_group_name string the highlight group name, pass to `:h nvim_get_hl_by_name` for more highlight information

---@alias SynshadeTransformFunction function(r: number, g: number, b: number, SynshadeHlGroupInfo): number, number, number
---@alias SynshadeWindowIgnoreFunction function(winid: number):boolean

---@class SynshadeFocusChangeEvents
---@field focus table<string> events that trigger focus
---@field unfocus table<string> events that trigger unfocus

---@class SynshadeUserConfiguration
---@field tint number? amount to tint, negative dims positive brightens
---@field saturation number? saturation to preserve, must be betwee, 0.0 and 1.0
---@field transforms table<SynshadeTransformFunction>|string|nil functions called in order to transform a color
---@field tint_background_colors boolean? whether backgrounds of colors should be tinted or not
---@field highlight_ignore_patterns table<string>? highlight group names to not tint
---@field window_ignore_function SynshadeWindowIgnoreFunction? granular control over whether tint touches a window _at all_
---@field focus_change_events SynshadeFocusChangeEvents?

--- Setup everything required for this module to run
---
---@param skip_config boolean? skip re-doing user configuration setup, useful when re-enabling, etc.
local setup_all = function(skip_config)
  if not skip_config then
    setup_user_config()
  end

  setup_namespaces()
  setup_autocmds()

  -- Used to in two scenarios:
  --   1. When the editor is opened with multiple windows/splits
  --   2. When the plugin is explicitly enabled
  vim.schedule(synshade_unfocused_windows)
end

--- Setup user configuration, highlight namespaces, and autocommands
---
--- Triggered by:
---   `:h VimEnter`
---
---@param _ table arguments from the associated `:h nvim_create_autocmd` setup
__.setup_callback = function(_)
  __.setup_all(false)
end

--- Enable this plugin
---
---@public
synshade.enable = function()
  if __.enabled or not state.user_config then
    return
  end

  __.enabled = true

  -- Reconfigure autocommands, setup highlight namespaces, etc.
  --
  -- Skip user config setup as this has already happened
  __.setup_all(true)
end

--- Disable this plugin
---
---@public
synshade.disable = function()
  if not __.enabled or not state.user_config then
    return
  end

  -- Disable autocommands
  create_augroup()
  __.setup_autocmds = false

  restore_default_highlight_namespaces()

  __.enabled = false
end

--- Toggle the plugin being enabled and/or disabled
---
---@public
synshade.toggle = function()
  if __.enabled then
    synshade.disable()
  else
    synshade.enable()
  end
end

--- Setup the plugin - can be called infinite times but will only do setup once
---
---@public
---@param user_config SynshadeUserConfiguration see `:h synshade-setup`
synshade.setup = function(user_config)
  if not utils.verify_version() then
    return
  end

  if state.user_config then
    return
  end

  state.user_config = user_config

  on_or_after_vimenter(__.setup_callback)
end

return synshade
