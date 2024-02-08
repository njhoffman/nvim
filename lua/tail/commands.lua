local config = require('tail.config')
local utils = require('tail.utils')
local state = require('tail.state')
local logger = require('tail.logger')

-- tail Update
local update_edit = function()
  -- run edit command on state.bufnr
  if vim.api.nvim_buf_is_valid(state.bufnr) then
    vim.api.nvim_command('edit ' .. state.bufname)
  end
  if vim.api.nvim_win_is_valid(state.winid) then
    vim.fn.win_execute(state.winid, 'normal G')
  end
end

local changed_size = function(file_size)
  local file_lines = vim.fn.line('$')
  local lines_diff = state.file_lines and (file_lines - state.file_lines) or nil
  logger.log_diff(file_size, lines_diff, file_lines)
  state.bufname = vim.api.nvim_buf_get_name(0)
  state.file_size = file_size
  state.file_lines = file_lines
  update_edit()
end

local changed_checktime = function(arg)
  vim.dbglog('checktime', arg)
end

local checktime_tick = function(ev)
  vim.cmd.checktime()
  vim.dbglog('ev', ev)
end

local checksize_tick = function()
  local file_size = vim.fn.getfsize(state.bufname)
  if state.timer_id ~= nil and file_size ~= state.file_size then
    changed_size(file_size)
  end
end

local setup_buffer = function()
  state.bufname = vim.api.nvim_buf_get_name(0)
  state.bufnr = vim.api.nvim_get_current_buf()
  state.winnr = vim.fn.bufwinnr(state.bufnr)
  state.winid = vim.fn.bufwinid(state.bufnr)
  state.file_size = vim.fn.getfsize(state.bufname)
  state.file_lines = vim.fn.line('$')

  vim.bo.autoread = true
  vim.bo.fileencoding = 'utf-8'
  vim.bo.modifiable = false
  vim.bo.readonly = true
  vim.bo.synmaxcol = 2000
  vim.wo.conceallevel = 3
  vim.wo.foldlevel = 99
  vim.wo.foldmethod = 'manual'
  vim.wo.scrolloff = 7
  vim.wo.wrap = false
  vim.v.fcs_choice = 'reload'
  -- vim.opt.encoding = 'UTF-8'
  -- vim.opt.hidden = true
  -- vim.opt.ignorecase = true
  -- vim.opt.laststatus = 2
  -- vim.opt.redrawtime = 4000
  -- setlocal bufhidden=delete
  -- setlocal nobuflisted
  -- setlocal nomodifiable
  -- setlocal nonumber
  -- setlocal noshowcmd
  -- setlocal noswapfile
  -- setlocal previewwindow
end

local tail = {}

function tail.start_tail()
  setup_buffer()
  if config.checktime then
    vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
      callback = changed_checktime,
    })
    state.timer_id = vim.fn.timer_start(config.interval, checktime_tick, { ['repeat'] = -1 })
  else
    update_edit()
    utils.start_test_timer()
    state.timer_id = vim.fn.timer_start(config.interval, checksize_tick, { ['repeat'] = -1 })
  end

  vim.dbglog(state)
  logger.log_start()
end

-- stop Tail
function tail.stop_tail()
  vim.dbglog('stop')
  utils.stop_test_timer()
  if state.timer_id ~= nil then
    vim.fn.timer_stop(state.timer_id)
    for key, _ in ipairs(state) do
      state[key] = nil
    end
  end
end

return tail
