--  ﲉ   ﬤ
-- { filetype = "markdown", icon = "", id = 3, level = "INFO", message = { "Live commands", "   ➜ `Norm <keys>`", "   ➜ `5Reg a`", "   ➜ `G/^$/d`", "   ➜ `%Spattern/replace`" }, render = <function 3>, time = 1707851316, title = { "format", "13:08:36" } }

-- pending = require("notify").pending(),
-- history = #(require("notify").history({ include_hidden = true }) or {}),
-- -- { filetype = "markdown", icon = "", id = 3, level = "INFO", message = { "Live commands", "   ➜ `Norm <keys>`", "   ➜ `5Reg a`", "   ➜ `G/^$/d`", "   ➜ `%Spattern/replace`" }, render = <function 3>, time = 1707851316, title = { "format", "13:08:36" } }
-- noice = #require("noice.message.manager")._history,

-- ## getting cpu usage
-- # Sample every 1 second for 10 samples, then average
-- pidstat -p <pid> 1 10

-- # Read CPU time at start
-- start=$(cat /proc/<pid>/stat | awk '{print $14+$15}')
-- start_total=$(cat /proc/stat | head -1 | awk '{print $2+$3+$4+$5+$6+$7+$8}')
-- sleep 10  # monitoring period
-- # Read CPU time at end
-- end=$(cat /proc/<pid>/stat | awk '{print $14+$15}')
-- end_total=$(cat /proc/stat | head -1 | awk '{print $2+$3+$4+$5+$6+$7+$8}')
-- # Calculate percentage
-- echo "scale=2; 100 * ($end - $start) / ($end_total - $start_total)" | bc

local symbols = {
  status = {
    [0] = "󰚩 ", -- Enabled
    [1] = "󱚧 ", -- Disabled Globally
    [2] = "󱙻 ", -- Disabled for Buffer
    [3] = "󱙺 ", -- Disabled for Buffer filetype
    [4] = "󱙺 ", -- Disabled for Buffer with enabled function
    [5] = "󱚠 ", -- Disabled for Buffer encoding
    [6] = "󱚠 ", -- Buffer is special type
  },
  server_status = {
    [0] = "󰣺 ", -- Connected
    [1] = "󰣻 ", -- Connecting
    [2] = "󰣽 ", -- Disconnected
  },
}

local cached_result = ""
local last_update = 0
local THROTTLE_MS = 100

local neocodeium = "       "
vim.api.nvim_create_autocmd("User", {
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
    -- Use ev.data to update your statusline
    -- As example just print to cmdline
    -- vim.dbglog(ev)

    if package.loaded["neocodeium"] and package.loaded["neocodeium"].get_status then
      local status, server_status = require("neocodeium").get_status()
      -- vim.dbglog("status", status, server_status)
      -- neocodeium = (tostring(status) or "  ") .. ":" .. (tostring(server_status) or "  ")
      server_status = symbols.server_status[server_status]
      neocodeium = ev.data or server_status
    end
    vim.cmd("redrawstatus")
  end,
})

local misc_stats = function()
  local now = vim.uv.now()
  if now - last_update < THROTTLE_MS and cached_result ~= "" then
    return cached_result
  end

  last_update = now

  local noice = package.loaded["noice"] and #require("noice.message.manager")._history or 0
  local pending = package.loaded["notify"] and require("notify").pending() or 0
  local history = package.loaded["notify"]
    and #(require("notify").history({ include_hidden = true }) or {})

  local animate = vim.b.minianimate_disable == true and "   " or "  "

  local notif = {
    pending = pending > 0 and " (" .. tostring(pending) .. ")" or "",
    history = tostring(history),
    noice = tostring(noice),
  }

  -- if package.loaded["neocodeium"] then
  --   local status, server_status = require("neocodeium").get_status()
  --   neocodeium = symbols.status[status] .. symbols.server_status[server_status]
  -- end

  cached_result = neocodeium
    .. animate
    -- .. "   "
    .. notif.noice
    .. ":"
    .. notif.history
    .. notif.pending
  return cached_result
end

-- " ﬤ " .. notif.pending

return {
  provider = misc_stats,
  name = "misc_stats",
}
