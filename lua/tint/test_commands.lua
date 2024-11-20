local utils = require("tint.utils")
local tint = require("tint")

local setup_tint = function(cfg)
  cfg = cfg or {}
  local winid = vim.api.nvim_get_current_win()
  local bufid = vim.fn.winbufnr(winid)
  vim.dbglog(string.rep("-", total_width, ""))
  local msg = "tint setup " .. tostring(winid) .. ":" .. tostring(bufid)
  local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
  vim.dbglog(spacers .. msg .. spacers)
  tint.setup(cfg)
end

local toggle_tint = function(winid)
  winid = winid or vim.api.nvim_get_current_win()
  vim.dbglog(string.rep("-", total_width, ""))
  local bufid = vim.fn.winbufnr(winid)
  local is_tinted = tint.is_tinted(winid)
  if is_tinted then
    local msg = "untinting " .. tostring(winid) .. ":" .. tostring(bufid)
    local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
    vim.dbglog(spacers .. msg .. spacers)
    tint.untint(winid)
  else
    local msg = "tinting " .. tostring(winid) .. ":" .. tostring(bufid)
    local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
    vim.dbglog(spacers .. msg .. spacers)
    tint.tint(winid)
  end
end

return { toggle_tint = toggle_tint, setup_tint = setup_tint }
