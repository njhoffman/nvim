local logutils = require("logger.utils")
local log = require("debuglog.log")
local M = {}

log:new()
M.log = log.info

M.dbg = function(...)
  local msg = ... or {}
  -- local cols = math.floor(vim.opt.columns:get() / 3)
  local currwin = vim.api.nvim_get_current_win()
  -- local currwidth = vim.api.nvim_win_get_width(currwin)
  local currheight = vim.api.nvim_win_get_height(currwin)

  log.info(msg)
  local notify = require("notify")
  local notify_msg = logutils.make_string(msg)
  local args = {}
  args.timeout = 5000
  args.render = "minimal"
  args.on_open = function(notify_win)
    local buf = vim.api.nvim_win_get_buf(notify_win)
    local cb = function()
      vim.api.nvim_set_current_win(currwin)
      vim.api.nvim_win_close(notify_win, true)
      -- notify.dismiss()
      M.buf(msg)
    end
    vim.api.nvim_buf_set_keymap(buf, "n", "gf", "", { callback = cb })
    vim.api.nvim_buf_set_keymap(buf, "n", "<2-LeftMouse>", "", { callback = cb })
    vim.api.nvim_buf_set_option(buf, "filetype", "lua")
  end

  local lines = vim.split(notify_msg, "\n")
  if (#lines >= currheight) then
    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), "\n")
    notify_msg = notify_msg .. "\n..." .. #lines .. " more lines not shown"
  end -- notify.dismiss()
  notify(notify_msg, "inspect", args)
end

M.buf = function(...)
  local msg = ... or {}
  local bufnr = vim.api.nvim_create_buf(true, true)
  -- local tb = logutils.traceback()
  -- print(vim.inspect(debug.getinfo(2)))
  -- { "1:[@/home/nicholas/.config/nvim/lua/logger/utils.lua]:25 -> field:traceback", "2:[@/home/nichola s/.config/nvim/lua/debuglog/init.lua]:105 -> field:dbgbuf", "3:[:lua]:1" }
  -- 3:[:lua]:1  = command line
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, "inspect-" .. bufnr)
  vim.bo.filetype = "lua"
  msg = logutils.make_string(msg)
  local lines = vim.split(msg, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

-- local log = require("debuglog")
-- M.buf('hello')
-- M.log(vim.api.nvim_get_all_options_info())
-- M.buf(_G._get_stats_keymaps())

return M
