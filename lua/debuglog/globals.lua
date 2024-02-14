local log = require('debuglog')
local logutils = require('debuglog.utils')
local config = require('debuglog.config')

local M = {}

M.buf = function(...)
  local msg = ... or {}
  local bufnr = vim.api.nvim_create_buf(true, true)
  -- local tb = logutils.traceback()
  -- print(vim.inspect(debug.getinfo(2)))
  -- { "1:[@/home/nicholas/.config/nvim/lua/logger/utils.lua]:25 -> field:traceback", "2:[@/home/nichola s/.config/nvim/lua/debuglog/init.lua]:105 -> field:dbgbuf", "3:[:lua]:1" }
  -- 3:[:lua]:1  = command line
  local source_ft = vim.bo.filetype
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, 'inspect-' .. bufnr)
  vim.bo.filetype = source_ft
  msg = logutils.make_string(msg)
  local lines = vim.split(msg, '\n')
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

local function dump_buffer(winnr, notify_win, args)
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_win_close(notify_win, true)
  -- notify.dismiss()
  M.buf(args)
end

M.log = function(...)
  local msg = ... or {}
  local cols = math.floor(vim.opt.columns:get() / 3)
  local currwin = vim.api.nvim_get_current_win()
  local currheight = vim.api.nvim_win_get_height(currwin)

  log:new(config)
  log.info(msg)

  local notify = require('notify')
  local notify_msg = logutils.make_string(msg)
  local args = {}
  args.timeout = 5000
  args.render = 'minimal'
  args.on_open = function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
  end

  local lines = vim.split(notify_msg, '\n')
  if false and #lines >= currheight then
    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), '\n')
    notify_msg = notify_msg .. '\n...' .. #lines .. ' more lines not shown'
  end
  -- notify.dismiss()
  notify(notify_msg, 'info', args)
end

M.inspect = function(...)
  local notify = require('notify')
  local msg = ... or {}
  local cols = math.floor(vim.opt.columns:get() / 3 * 2)
  local currwin = vim.api.nvim_get_current_win()
  local currheight = vim.api.nvim_win_get_height(currwin)
  local notify_msg = logutils.make_string(msg)

  local args = {
    timeout = 8000,
    minimum_width = 20,
    maximum_width = cols,
    render = 'minimal',
    -- keep = function() return true end,
    on_open = function(notify_win)
      local buf = vim.api.nvim_win_get_buf(notify_win)
      local cb = function()
        dump_buffer(currwin, notify_win, msg)
      end
      vim.api.nvim_buf_set_keymap(buf, 'n', 'gf', '', { callback = cb })
      vim.api.nvim_buf_set_keymap(buf, 'n', '<2-LeftMouse>', '', { callback = cb })
      vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
    end,
  }

  local lines = vim.split(notify_msg, '\n')
  if #lines >= currheight then
    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), '\n')
    notify_msg = notify_msg .. '\n...' .. #lines .. ' more lines not shown'
  end
  notify(notify_msg, 'inspect', args)
end

vim.dbg = M.inspect
vim._log = log.info
vim._buf = M.buf

vim.dbg_test = function()
  vim._log(vim.api.nvim_get_all_options_info())
end

--[[ vim.api.nvim_create_user_command(
  "Log",
  function(args)
    -- lua vim.dbg(vim.api.nvim_exec('PrettyPrint b:', { output = true }))
    vim_cmd = "vim.api.nvim_exec('PrettyPrint " .. args.args .. "', { output = true })"
    load("vim.dbgbuf(" .. vim_cmd .. ")")()
    -- load('vim.dbg(' .. args.args .. ')')()
  end,
  {
    nargs = "*",
    desc = "Dump inspected argument to new buffer"
  }
)

vim.api.nvim_create_user_command(
  "Notify",
  function(args)
    vim_cmd = "vim.api.nvim_exec('PrettyPrint " .. args.args .. "', { output = true })"
    load("vim.dbg(" .. vim_cmd .. ")")()
    -- load('vim.dbg(' .. args.args .. ')')()
  end,
  {
    nargs = "*",
    desc = "Output inspected argument to new notification"
  }
) ]]
-- function! OutputExSplitWindow(...)
--   " this function output the result of the Ex command into a split scratch buffer
--   let cmd = join(a:000, ' ')
--   let temp_reg = @"
--   redir @"
--   silent! execute cmd
--   redir END
--   let output = copy(@")
--   let @" = temp_reg
--   if empty(output)
--     echoerr "no output"
--   else
--     new
--     setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
--     put! =output
--   endif
-- endfunction
-- command! -nargs=+ -complete=command OutputEx call OutputExSplitWindow(<f-args>)
