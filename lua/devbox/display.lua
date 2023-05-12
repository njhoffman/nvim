local state = require('devbox.state')
local commands = require('devbox.state')

local get_queued_count = function()
  local count = 0
  for _, task in ipairs(state.current.queued) do
    if task == true then
      count = count + 1
    end
  end
  return count
end

local update_title = function()
  local parts = { left = '', mid = '', right = '' }
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  if get_queued_count() > 0 or not state.current.last_elapsed then
    parts.left = #state.current.queued .. '/' .. #state.providers .. 'Load' .. ' ..'
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    parts.right = vim.fn.reltimestr(vim.fn.reltime(state.current.start))
  else
    parts.left = #state.providers .. '/' .. #state.providers .. 'Done'
    parts.right = state.current.last_elapsed
  end
  parts.right = tostring(parts.right)
  parts.mid = string.rep('', state.popup.size.width - #parts.left - #parts.right, ' ')

  local title = vim.fn.join({ parts.left, parts.mid, parts.right }, '')
  vim.api.nvim_win_set_option(state.popup.winnr, 'winbar', title)
end

local create_popup = function(winsize)
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
    row = parent.h / 1.5,
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
local update_line_cb = function(provider, result)
  ---@diagnostic disable-next-line: missing-parameter
  state.current.completed[provider.idx] = provider.last_elapsed
  state.current.queued[provider.idx] = false
  if get_queued_count() == 0 then
    ---@diagnostic disable-next-line: missing-parameter
  end
  local summary = (provider.last_elapsed or '--------') .. ' ' .. result.summary
  vim.api.nvim_buf_set_lines(state.popup.bufnr, provider.idx - 1, provider.idx, false, { summary })
  vim.api.nvim_buf_add_highlight(state.popup.bufnr, 0, 'Comment', provider.idx - 1, 1, 10)
  vim.api.nvim_buf_add_highlight(state.popup.bufnr, 0, result.hl, provider.idx - 1, 10, 11)
  vim.api.nvim_buf_add_highlight(state.popup.bufnr, 0, result.hl, provider.idx - 1, 11, 12 + string.len(result.name))
  update_title()
end

-- new_average = (old_average * (n-1) + new_value) / n
local update_popup = function()
  ---@diagnostic disable-next-line: missing-parameter
  state.current = vim.tbl_deep_extend('force', state.current, {
    batch_idx = state.current.batch_idx + 1,
  })

  for _, provider in pairs(state.providers) do
    local p_timing = state.timing.providers[provider.name] or {}
    provider = vim.tbl_deep_extend('force', provider, {
      content = nil,
      summary = nil,
    })
    state.current.queued[provider.idx] = true
    provider.handler(update_line_cb, provider)
  end

  update_title()
end

return { update_popup = update_popup, create_popup = create_popup }
