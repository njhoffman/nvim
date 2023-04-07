local cmd = vim.api.nvim_create_user_command
local state = require("hover.state")

local init = function()
  vim.api.nvim_create_augroup("Hover", { clear = true })

  cmd("HoverClose", function()
    vim.api.nvim_win_close(state.preview.winnr, true)
  end, { desc = "Close hover window" })

  cmd("Hover", require("hover").hover_once, { desc = "Open hover window once" })
  cmd("HoverSticky", require("hover").hover_sticky, { desc = "Open hover window sticky" })
  cmd("HoverCursor", require("hover").hover_cursor, { desc = "Open hover select menu" })
  cmd("HoverSelect", require("hover").hover_select, { desc = "Open hover select menu" })
end

return { init = init, clear = clear }
