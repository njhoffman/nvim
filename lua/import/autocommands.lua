local detail_lines = require("import.ui.details")
local ui_state = require("import.ui.state")
local actions = require("import.actions")

local _assign_autocommands = function()
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = ui_state.buf_handle,
    desc = "Clear out Cache for import UI",
    callback = actions.close,
    once = true,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    buffer = ui_state.buf_handle,
    desc = "Clear out cache for import UI",
    callback = actions.close,
    once = true,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = ui_state.buf_handle,
    desc = "Loading Details into View Buffer",
    callback = detail_lines,
  })
end

return _assign_autocommands
