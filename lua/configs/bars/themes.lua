--- Theme system for bars.nvim statusline.
--- Provides pre-defined style configurations with optional per-theme highlights.

local M = {}

--- Available themes.
M.available = { "slashed", "minimal", "stealth", "bubble", "rainbow", "pure", "feline" }

--- Get the statusline config for a given theme name.
---@param name string
---@return table? config
function M.get(name)
  local sl_config = require("configs.bars.statusline")

  if name == "slashed" or name == "default" then
    return sl_config.default
  end

  if sl_config[name] then
    return sl_config[name]
  end

  return nil
end

--- Apply a theme at runtime by swapping the default component list.
--- Resets base highlights and applies theme-specific highlights if defined.
---@param name string
function M.apply(name)
  local config = M.get(name)

  if not config then
    vim.notify("Unknown statusline theme: " .. name, vim.log.levels.WARN)
    return
  end

  -- Reset base highlights to known-good state.
  local highlights = require("configs.bars.highlights")
  highlights.setup()

  -- Apply theme-specific highlights on top.
  if type(config.highlights) == "function" then
    config.highlights(highlights.colors)
  end

  -- Swap components.
  local statusline = require("bars.statusline")
  statusline.config.default.components = config.components

  -- Force re-render on all windows.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    pcall(vim.api.nvim_win_del_var, win, "_bars_statusline_style")
  end

  vim.cmd("redrawstatus!")
  vim.notify("Statusline theme: " .. name, vim.log.levels.INFO)
end

--- Register user commands for theme switching.
function M.setup_commands()
  vim.api.nvim_create_user_command("StatuslineTheme", function(opts)
    if vim.g.statusline_backend ~= "bars" then
      vim.notify("StatuslineTheme requires bars backend (use :StatuslineSwitch bars)", vim.log.levels.WARN)
      return
    end
    M.apply(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return M.available
    end,
    desc = "Switch statusline theme",
  })
end

return M
