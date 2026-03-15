local get_queued_count = function()
  local state = require('devbox.state')
  local count = 0
  for _, task in ipairs(state.current.queued) do
    if task == true then
      count = count + 1
    end
  end
  return count
end

local update_title = function()
  local state = require('devbox.state')
  local parts = { left = '', mid = '', right = '' }
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  if get_queued_count() > 0 or not state.current.last_elapsed then
    parts.left = 'Loading ' .. #state.current.queued .. '/' .. #state.providers
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    parts.right = vim.fn.reltimestr(vim.fn.reltime(state.start))
  else
    parts.left = #state.providers
      .. '/'
      .. #state.providers
      .. ' finished (#'
      .. tostring(state.current.batch_idx)
      .. ')'
    parts.right = string.format('%.6fs', state.current.last_elapsed)
  end
  parts.right = tostring(parts.right)
  parts.mid = string.rep('', state.popup.size.width - #parts.left - #parts.right, ' ')

  local title = vim.fn.join({ parts.left, parts.mid, parts.right }, '')
  vim.wo[state.popup.winnr].winbar = title
end

local create_popup = function(winsize)
  local state = require('devbox.state')
  local parent = {
    w = vim.api.nvim_win_get_width(0),
    h = vim.api.nvim_win_get_height(0),
  }

  state.source.bufnr = vim.api.nvim_get_current_buf()
  state.source.size = parent

  local prev_winnr = vim.api.nvim_open_win(0, false, {
    relative = 'win',
    height = winsize.height,
    width = winsize.width,
    focusable = false,
    border = 'rounded',
    bufpos = { 0, 0 },
    row = parent.h - 5,
    col = parent.w,
    anchor = 'SE',
    zindex = 2,
    style = 'minimal',
  })

  state.popup.bufnr = vim.api.nvim_create_buf(false, true)
  state.popup.winnr = prev_winnr
  vim.api.nvim_win_set_buf(state.popup.winnr, state.popup.bufnr)
  update_title()
end

-- local get_provider_by_name = function(name)
--   local matched = false
--   for _, provider in ipairs(state.providers) do
--     matched = matched or (provider.name == name and provider)
--   end
--   return matched
-- end
--

local provider_time = function(name)
  return
end

local update_provider_time = function(provider)
  local state = require('devbox.state')
  local last_elapsed = tonumber(vim.fn.reltimestr(vim.fn.reltime(provider.start)))
  provider.start = nil
  if type(state.timing.providers[provider.name]) ~= 'table' then
    state.timing.providers[provider.name] = {
      n = 0,
      min = 0,
      max = 0,
      avg = 0,
      total = 0,
      last_elapsed = 0,
    }
  end
  local target = state.timing.providers[provider.name]
  target.n = target.n + 1
  target.total = target.total + last_elapsed
  target.avg = target.total / target.n
  target.max = math.max(target.max, last_elapsed)
  target.min = target.min == 0 and last_elapsed or math.min(target.min, last_elapsed)
  target.last_elapsed = last_elapsed
  provider.last_elapsed = last_elapsed
end

local update_batch_time = function()
  local state = require('devbox.state')
  state.timing.batch.n = state.timing.batch.n + 1
  local total_elapsed = 0
  for _, provider in ipairs(state.providers) do
    local p_timing = state.timing.providers[provider.name] or {}
    local p_elapsed = p_timing.last_elapsed or 0
    total_elapsed = total_elapsed + p_elapsed
  end
  state.current.last_elapsed = total_elapsed
  state.timing.batch.total = total_elapsed + state.timing.batch.total
  state.timing.batch.avg = state.timing.batch.total / state.timing.batch.n
  state.timing.batch.max = math.max(state.timing.batch.max, total_elapsed)
  state.timing.batch.min = state.timing.batch.min == 0 and state.current.last_elapsed
    or math.min(state.timing.batch.min, total_elapsed)
end

local last_batch_id = 0
local update_line_cb = function(provider, result)
  local state = require('devbox.state')
  update_provider_time(provider)

  state.current.completed[provider.idx] = provider.last_elapsed
  state.current.queued[provider.idx] = false
  if get_queued_count() == 0 and state.current.batch_idx ~= last_batch_id then
    update_batch_time()
    last_batch_id = state.current.batch_idx
  end

  local hl = vim.api.nvim_buf_add_highlight
  local summary = (string.format('%.8f', provider.last_elapsed) or '--------') .. ' ' .. result.summary
  vim.api.nvim_buf_set_lines(state.popup.bufnr, provider.idx - 1, provider.idx, false, { summary })
  hl(state.popup.bufnr, 0, 'Comment', provider.idx - 1, 0, 10)
  hl(state.popup.bufnr, 0, result.hl, provider.idx - 1, 11, 16)
  hl(state.popup.bufnr, 0, 'Keyword', provider.idx - 1, 17, -1)
  update_title()
end

-- new_average = (old_average * (n-1) + new_value) / n
local update_popup = function()
  local state = require('devbox.state')
  state.current = vim.tbl_deep_extend('force', state.current, {
    batch_idx = state.current.batch_idx + 1,
  })

  for _, provider in pairs(state.providers) do
    local p_timing = state.timing.providers[provider.name] or {}
    provider = vim.tbl_deep_extend('force', provider, {
      start = vim.fn.reltime(),
      content = nil,
      summary = nil,
    })
    state.current.queued[provider.idx] = true
    provider.handler(update_line_cb, provider)
  end

  update_title()
end

return { update_popup = update_popup, create_popup = create_popup }
