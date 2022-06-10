local coreutils = require("utils.core")
local logutils = require("logger.utils")
local log = require("debuglog.log")
local M = {}

log:new()
M.log = log.info

M.buf = function(...)
  local msg = ... or {}
  local bufnr = vim.api.nvim_create_buf(true, true)
  -- local tb = logutils.traceback()
  -- print(vim.inspect(debug.getinfo(2)))
  -- { "1:[@/home/nicholas/.config/nvim/lua/logger/utils.lua]:25 -> field:traceback", "2:[@/home/nichola s/.config/nvim/lua/debuglog/init.lua]:105 -> field:dbgbuf", "3:[:lua]:1" }
  -- 3:[:lua]:1  = command line
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, "inspect-" .. bufnr)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "lua")
  msg = logutils.make_string(msg)
  local lines = vim.split(msg, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

M.dbg = function(...)
  local msg = ... or {}
  -- local cols = math.floor(vim.opt.columns:get() / 3)
  local currwin = vim.api.nvim_get_current_win()
  -- local currwidth = vim.api.nvim_win_get_width(currwin)
  local currheight = vim.api.nvim_win_get_height(currwin)

  log.info(msg)
  local notify_msg = logutils.make_string(msg)
  local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  local args = {}
  args.timeout = 5000
  args.render = "minimal"
  args.hide_from_history = true
  args.on_open = function(notify_win)
    local buf = vim.api.nvim_win_get_buf(notify_win)
    vim.api.nvim_buf_set_option(buf, "filetype", "lua")
    local cb_close = function()
      vim.api.nvim_set_current_win(currwin)
      vim.api.nvim_win_close(notify_win, true)
      -- notify.dismiss()
      M.buf(msg)
    end

    vim.api.nvim_buf_set_keymap(buf, "n", "gf", "", { callback = cb_close })
    vim.api.nvim_set_keymap("n", "gF", "", { callback = cb_close })
    vim.api.nvim_buf_set_keymap(buf, "n", "<2-LeftMouse>", "", { callback = cb })
  end

  args.on_close = function(buf)
    if type(orig_map) == "table" and type(orig_map.lhs) == 'string' then
      pcall(vim.api.nvim_del_keymap, { "n", "gF" })
      pcall(vim.api.nvim_set_keymap, {
        orig_map.mode,
        orig_map.lhs,
        orig_map.rhs,
        {
          nowait = orig_map.nowait,
          noremap = orig_map.noremap,
          silent = 1,
          callback = function() end
        }
      })
    end
  end

  local lines = vim.split(notify_msg, "\n")
  if (#lines >= currheight) then
    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), "\n")
    notify_msg = notify_msg .. "\n..." .. #lines .. " more lines not shown"
  end -- notify.dismiss()
  -- vim.notify(notify_msg, "inspect", args)
  require("notify").notify(notify_msg, "inspect", args)
end



return M
