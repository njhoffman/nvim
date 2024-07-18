--- Default module configuration values
---
---@type SynshadeUserConfiguration
default_config = {
  tint = -40,
  saturation = 0.7,
  transforms = nil,
  tint_background_colors = false,
  highlight_ignore_patterns = {},
  window_ignore_function = nil,
  focus_change_events = {
    focus = { "WinEnter" },
    unfocus = { "WinLeave" },
  },
}

--- Setup `state.user_config` by overriding defaults with user values
local function setup_user_config()
  state.user_config =
    vim.tbl_extend("force", __.default_config, get_user_config(state.user_config or {}))

  vim.validate({
    tint = { state.user_config.tint, "number" },
    saturation = { state.user_config.saturation, "number" },
    transforms = {
      state.user_config.transforms,
      function(val)
        if type(val) == "string" then
          return __.transforms[val]
        elseif type(val) == "table" then
          for _, v in ipairs(val) do
            if type(v) ~= "function" then
              return false
            end
          end

          return true
        elseif val == nil then
          return true
        end

        return false
      end,
      "'synshade' passed invalid value for option 'transforms'",
    },
    tint_background_colors = { state.user_config.tint_background_colors, "boolean" },
    highlight_ignore_patterns = {
      state.user_config.highlight_ignore_patterns,
      function(val)
        for _, v in ipairs(val) do
          if type(v) ~= "string" then
            return false
          end
        end

        return true
      end,
      "'synshade' passed invalid value for option 'highlight_ignore_patterns'",
    },
    window_ignore_function = { state.user_config.window_ignore_function, "function", true },
    focus_change_events = {
      state.user_config.focus_change_events,
      function(val)
        if type(val) ~= "table" then
          return false
        end

        if not val.focus or not val.unfocus then
          return false
        end

        for _, v in ipairs(val.focus) do
          if type(v) ~= "string" then
            return false
          end
        end

        for _, v in ipairs(val.unfocus) do
          if type(v) ~= "string" then
            return false
          end
        end

        return true
      end,
      "'synshade' passed invalid value for option 'focus_change_events'",
    },
  })

  state.user_config.transforms = get_transforms()
end

--- Swap old configuration keys to new ones, handle cases `tbl_extend` does not (nested config values)
---
---@param user_config table old style user configuration
---@return SynshadeUserConfiguration # modified user configuration to follow new format
local function get_user_config(user_config)
  local new_config = vim.deepcopy(user_config)

  -- Copy over old configuration values here before calling `tbl_extend` later
  new_config.tint = user_config.amt or user_config.tint
  new_config.tint_background_colors = user_config.bg ~= nil and user_config.bg
    or user_config.tint_background_colors
  new_config.highlight_ignore_patterns = user_config.ignore or user_config.highlight_ignore_patterns
  new_config.window_ignore_function = user_config.ignorefunc or user_config.window_ignore_function

  if new_config.focus_change_events then
    new_config.focus_change_events.focus = new_config.focus_change_events.focus
      or __.default_config.focus_change_events.focus
    new_config.focus_change_events.unfocus = new_config.focus_change_events.unfocus
      or __.default_config.focus_change_events.unfocus
  end

  return new_config
end

--- Determine if a window should be ignored or not, triggered on `WinLeave`
---
---@param winid number window handle
---@return boolean # whether or not the window should be ignored for tinting
local function win_should_ignore_tint(winid)
  return state.user_config.window_ignore_function
      and state.user_config.window_ignore_function(winid)
    or false
end

--- Determine if a highlight group should be ignored or not
---
---@param hl_group_name string name of the highlight group
---@return boolean # whether or not the group should be ignored
local function hl_group_is_ignored(hl_group_name)
  for _, pat in ipairs(state.user_config.highlight_ignore_patterns) do
    if string.find(hl_group_name, pat) then
      return true
    end
  end

  return false
end
