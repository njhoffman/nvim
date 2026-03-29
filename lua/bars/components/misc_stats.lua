--- Misc stats component.
--- Shows neocodeium status, animate toggle, and noice/notify counts.
--- Throttled at a configurable interval (default 100ms).
---@module "bars.components.misc_stats"


local M = {}

---@type table<integer, string>
local symbols = {
  status = {
    [0] = "󰚩 ",
    [1] = "󱚧 ",
    [2] = "󱙻 ",
    [3] = "󱙺 ",
    [4] = "󱙺 ",
    [5] = "󱚠 ",
    [6] = "󱚠 ",
  },
  server_status = {
    [0] = "󰣺 ",
    [1] = "󰣻 ",
    [2] = "󰣽 ",
  },
}

local cached_result = ""
local last_update = 0
local THROTTLE_MS = 100

local neocodeium = "       "

--- Registers autocmds for neocodeium status updates.
--- Call once during setup to enable live neocodeium status in the statusline.
--- Safe to call multiple times (uses a named augroup).
M.setup = function()
  ---|fS

  local group = vim.api.nvim_create_augroup("BarsMiscStats", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = {
      "NeoCodeiumLabelUpdated",
      "NeoCodeiumServer*",
      "NeoCodeium*Enabled",
      "NeoCodeium*Disabled",
      "NeoCodeiumCompletionCleared",
      "NeoCodeiumCompletionDisplayed",
      "NeoCodeiumBufEnabled",
      "NeoCodeiumBufDisabled",
      "NeoCodeiumEnabled",
      "NeoCodeiumDisabled",
    },
    callback = function(ev)
      if package.loaded["neocodeium"] and package.loaded["neocodeium"].get_status then
        local status, server_status = require("neocodeium").get_status()
        server_status = symbols.server_status[server_status]
        neocodeium = ev.data or server_status
      end
      vim.cmd("redrawstatus")
    end,
  })

  ---|fE
end

--- Returns the misc stats for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local now = vim.uv.now()

  if now - last_update < THROTTLE_MS and cached_result ~= "" then
    return cached_result
  end

  last_update = now

  local noice_count = package.loaded["noice"] and #require("noice.message.manager")._history or 0
  local pending = package.loaded["notify"] and require("notify").pending() or 0
  local history = package.loaded["notify"]
      and #(require("notify").history({ include_hidden = true }) or {})
    or 0

  local animate = vim.b.minianimate_disable == true and "   " or "  "

  local pending_str = pending > 0 and " (" .. tostring(pending) .. ")" or ""

  cached_result = neocodeium
    .. animate
    .. tostring(noice_count)
    .. ":"
    .. tostring(history)
    .. pending_str

  return cached_result

  ---|fE
end

return M
