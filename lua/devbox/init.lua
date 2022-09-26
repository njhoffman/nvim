local devbox = require("devbox.devbox")
local au_commands = require("devbox.aucommands")
local setup = function()
  local parent = {
    w = vim.api.nvim_win_get_width(0),
    h = vim.api.nvim_win_get_height(0),
  }

  local prev_winnr = vim.api.nvim_open_win(0, false, {
    relative = "win",
    height = 12,
    width = 50,
    focusable = false,
    border = "rounded",
    bufpos = { 0, 0 },
    row = parent.h,
    col = parent.w,
    anchor = "SE",
    zindex = 2,
    style = "minimal",
  })

  local prev_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(prev_winnr, prev_bufnr)

  devbox.update_preview(prev_bufnr)
  vim.diagnostic.reset(nil, prev_bufnr)
  au_commands.init(prev_bufnr, prev_winnr)
end

setup()
