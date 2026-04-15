local map = require("mapper").map
local coreutils = require("utils.core")
local logutils = require("logger.debug.utils")
local log = require("logger.debug.log")
local timer = require("logger.debug.timer")

local M = {}
log:new()
M.log = log.info

M.timer = timer

-- prints directly to stdout
M.inspect_simple = require("logger.debug.parsers.inspect-simple")
M.inspect = require("logger.debug.parsers.inspect")

-- returns string
M.dump = require("logger.debug.parsers.dump")
M.n = require("logger.debug.parsers.dump")

-- returns list of lines
M.traceback = require("logger.debug.parsers.traceback")
M.namespaces = require("logger.debug.parsers.namespaces")

-- shows only on screen notification
M.buf = function(...)
  local msg = ... or {}
  local bufnr = vim.api.nvim_create_buf(true, true)
  -- local tb = logutils.traceback()
  -- print(vim.inspect(debug.getinfo(2)))
  -- { "1:[@/home/nicholas/.config/nvim/lua/logger/utils.lua]:25 -> field:traceback", "2:[@/home/nichola s/.config/nvim/lua/debuglog/init.lua]:105 -> field:dbgbuf", "3:[:lua]:1" }
  -- 3:[:lua]:1  = command line
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, "inspect-" .. bufnr)
  vim.bo[bufnr].filetype = "lua"
  msg = logutils.make_string(msg)
  local lines = vim.split(msg, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

-- shows on-screen notification and debug log
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
    vim.bo[buf].filetype = "lua"
    local cb_close = function()
      vim.api.nvim_set_current_win(currwin)
      vim.api.nvim_win_close(notify_win, true)
      if type(orig_map) == "table" and type(orig_map.lhs) == "string" then
        pcall(vim.api.nvim_del_keymap, "n", "gF")
        pcall(map, orig_map.mode, orig_map.lhs, orig_map.rhs, {
          nowait = orig_map.nowait,
        })
      end
      -- notify.dismiss()
      M.buf(msg)
    end

    map("n", "gf", cb_close, { buffer = buf })
    map("n", "gF", cb_close)
  end

  local lines = vim.split(notify_msg, "\n")
  if false and #lines >= currheight then
    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), "\n")
    notify_msg = notify_msg .. "\n..." .. #lines .. " more lines not shown"
  end -- notify.dismiss()
  -- vim.notify(notify_msg, "inspect", args)
  require("notify").notify(notify_msg, "inspect", args)
end

return M
