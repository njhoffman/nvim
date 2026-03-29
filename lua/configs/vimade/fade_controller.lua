local M = {}

-- State: { [bufnr] = { level = number, source = string } }
local state = {}

local clamp = function(val)
  return math.max(0, math.min(1, val))
end

-- Parse a level value that can be absolute or relative.
-- Accepts: number (0.5), string ("+0.2", "-0.1"), or nil.
-- Relative strings are applied against `current`.
M.parse_level = function(value, current)
  if value == nil then
    return current or 1
  end
  if type(value) == "number" then
    return clamp(value)
  end
  if type(value) == "string" then
    local sign = value:sub(1, 1)
    if sign == "+" or sign == "-" then
      local delta = tonumber(value)
      if delta and current then
        return clamp(current + delta)
      end
    end
    local num = tonumber(value)
    if num then
      return clamp(num)
    end
  end
  return current or 1
end

-- Sync state to buffer variables so other plugins can read it.
local sync_to_bufvar = function(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    state[bufnr] = nil
    return
  end
  local entry = state[bufnr]
  if entry then
    vim.b[bufnr].fadelevel = entry.level
    vim.b[bufnr].fade_source = entry.source
  else
    vim.b[bufnr].fadelevel = nil
    vim.b[bufnr].fade_source = nil
  end
end

-- Restore state from buffer variables (survives module reload).
local restore_from_bufvar = function(bufnr)
  if state[bufnr] then
    return
  end
  local level = vim.b[bufnr].fadelevel
  local source = vim.b[bufnr].fade_source
  if level then
    state[bufnr] = { level = level, source = source or "restored" }
  end
end

-- Get the current fade state for a buffer.
-- Returns { level = number, source = string } or nil.
M.get = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  restore_from_bufvar(bufnr)
  return state[bufnr]
end

-- Set the fade level for a buffer.
-- `level` can be absolute (0.5) or relative ("+0.2", "-0.1").
-- `source` is an optional string tag ("split", "cmdline", "api", etc.).
M.fade = function(bufnr, level, source)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local current = state[bufnr] and state[bufnr].level or 1
  local resolved = M.parse_level(level, current)
  state[bufnr] = { level = resolved, source = source or "api" }
  sync_to_bufvar(bufnr)
  M._trigger_update()
end

-- Restore a buffer to full opacity.
M.unfade = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  state[bufnr] = nil
  sync_to_bufvar(bufnr)
  M._trigger_update()
end

-- Public API for plugins to call.
-- Applies a tint/fade to a buffer with an optional source tag.
M.fadetint = function(bufnr, level, source)
  M.fade(bufnr, level, source or "plugin")
end

-- Force vimade to re-evaluate immediately (bypasses polling interval).
M._trigger_update = function()
  local ok, vimade = pcall(require, "vimade")
  if ok and vimade.update then
    vim.schedule(function()
      vimade.update()
    end)
  end
end

-- Build a fadelevel function compatible with vimade's fadelevel option.
-- `cfg` is a table of scenario -> level mappings:
--   { dimmed = 0.5, popup = 0.6, split = 0.7, cmdline = 0.2, ... }
M.make_fadelevel = function(cfg)
  cfg = cfg or {}
  local default_level = cfg.dimmed or 0.45

  return function(style, _state)
    local win = style.win
    if not win then
      return default_level
    end

    -- If the buffer has an explicit API-set level, use it.
    local explicit = state[win.bufnr]
    if explicit then
      return explicit.level
    end

    -- Active window: only fade if in cmdline mode.
    if win.is_active_win then
      if vim.fn.getcmdtype() ~= "" then
        return cfg.cmdline or default_level
      end
      return 1
    end

    -- Inactive window: determine scenario.
    local globals_ok, globals = pcall(require, "vimade.state.globals")
    if globals_ok and globals.current then
      local current = globals.current
      local cur_winid = current.winid
      if cur_winid and cur_winid > 0 then
        local ok, cur_cfg = pcall(vim.api.nvim_win_get_config, cur_winid)
        if ok and cur_cfg.relative and cur_cfg.relative ~= "" then
          return cfg.popup or default_level
        end
      end
    end

    -- Check if the inactive window is a split (not a popup).
    if win.win_config and win.win_config.relative == "" then
      return cfg.split or default_level
    end

    return default_level
  end
end

-- Clean up state for deleted buffers.
M._cleanup = function()
  for bufnr, _ in pairs(state) do
    if not vim.api.nvim_buf_is_valid(bufnr) then
      state[bufnr] = nil
    end
  end
end

-- Reset all state (for testing/debug).
M._reset = function()
  state = {}
end

-- Expose state for debugging.
M._state = function()
  return state
end

return M
