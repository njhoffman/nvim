local buffer = function(lines, title)
  lines = type(lines) == 'string' and vim.fn.split(lines, '\n') or lines
  vim.dbglog(title .. vim.fn.join(lines, '\n  '))

  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, title or ('stats-' .. bufnr))
  vim.bo.filetype = 'lua'
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, lines, {})
end

local split = function(lines, title)
  lines = type(lines) == 'string' and vim.fn.split(lines, '\n') or lines
  vim.cmd('new')
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo.filetype = 'lua'
  vim.api.nvim_buf_set_name(bufnr, title or ('stats-' .. bufnr))
  vim.api.nvim_buf_set_lines(0, 0, 0, lines, {})
end

local logfile = function(lines, title)
  lines = type(lines) == 'string' and vim.fn.split(lines, '\n') or lines
  if #lines > 1 then
    title = title .. ' (' .. #lines .. ')\n  '
  else
    title = title .. ' '
  end
  vim.dbglog(title .. vim.fn.join(lines, '\n  '))
end

local notify = function(lines, title)
  -- local notify = require('notify')
  local notify = vim.notify
  if type(title) ~= 'nil' and #title > 0 then
    notify(lines, 2, { timeout = 10000, title = title })
  else
    notify(lines, 2, { timeout = 10000, render = 'compact' })
  end
end

local popup = function(lines, title)
  -- local stats_list = vim.import('stats')
  --
  -- local Popup = vim.import('nui.popup')
  -- local event = vim.import('nui.utils.autocmd').event
  --
  -- local popup = Popup({
  --   position = { row = '90%', col = '100%' },
  --   size = {
  --     width = 25,
  --     height = 20,
  --   },
  --   enter = false,
  --   focusable = false,
  --   zindex = 50,
  --   relative = 'editor',
  --   border = {
  --     highlight = 'FloatBorder',
  --     padding = {
  --       top = 1,
  --       bottom = 1,
  --       left = 1,
  --       right = 1,
  --     },
  --
  --     style = 'rounded',
  --     text = {
  --       top = 'InfoWindow',
  --       top_align = 'center',
  --     },
  --   },
  --   buf_options = {
  --     modifiable = false,
  --     readonly = true,
  --   },
  --   win_options = {
  --     winblend = 50,
  --     winhighlight = 'Normal:Normal',
  --   },
  -- })
  --
  -- -- mount/open the component
  -- popup:mount()
  --
  -- -- unmount component when cursor leaves buffer
  -- -- popup:on(event.BufLeave, function()
  -- --   popup:unmount()
  -- -- end)
  --
  -- local select_items = stats_list.get_items()
  --
  -- -- set content
  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, select_items)
  --
  -- -- -- vim.ui.select(select_items, {},
  -- -- --   function(selected)
  -- -- --     selected = selected or ''
  -- -- --     print('SELECTED ' .. selected)
  -- -- --   end
  -- -- -- )
  -- -- -- print(vim.ins;pect(env_counts))
  --
end

return {
  logfile = logfile,
  notify = notify,
  split = split,
  buffer = buffer,
  popup = popup,
}
