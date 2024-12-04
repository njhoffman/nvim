--  ﲉ   ﬤ  

local misc_stats = function()
  local notif = {
    pending = require("notify").pending(),
    history = #(require("notify").history({ include_hidden = true }) or {}),
    -- { filetype = "markdown", icon = "", id = 3, level = "INFO", message = { "Live commands", "   ➜ `Norm <keys>`", "   ➜ `5Reg a`", "   ➜ `G/^$/d`", "   ➜ `%Spattern/replace`" }, render = <function 3>, time = 1707851316, title = { "format", "13:08:36" } }
    noice = #require("noice.message.manager")._history,
  }

  local animate = vim.b.minianimate_disable == true and " " or ""

  -- nums.tags = nums.tags + 1
  return animate
    .. " "
    .. notif.history
    .. ":"
    .. notif.noice
    .. " "
    .. (notif.pending > 0 and "x" .. notif.pending or "")
end

return {
  name = "misc_stats",
  provider = misc_stats,
}
