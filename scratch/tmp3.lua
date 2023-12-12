local Path = require('plenary.path')

local config = { marker = '🪚' .. ' ' }

local get_open_filelist = function(cwd)
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end

  local filelist = {}
  for _, bufnr in ipairs(bufnrs) do
    local file = vim.api.nvim_buf_get_name(bufnr)
    table.insert(filelist, Path:new(file):make_relative(cwd))
  end
  return filelist
end

local remove_logs = function(buf)
  buf = buf or 0
  vim.api.nvim_set_current_buf(buf)

  local num_of_lines_before = vim.api.nvim_buf_line_count(buf)
  -- escape for vim regex, in case `[]()` are used in the marker
  local to_remove = config.marker:gsub('([%[%]()])', '\\%1')
  local matches = vim.cmd(('silent qaq:g/%s/y A'):format(to_remove))
  vim.cmd(('silent g/%s/d'):format(to_remove))
  vim.cmd.nohlsearch()
  local lines_removed = num_of_lines_before - vim.api.nvim_buf_line_count(buf)
  return lines_removed
end

local remove_logs_notify = function(buf, removed)
  local name = vim.api.nvim_buf_get_name(buf) or ''
  name = Path:new(name):make_relative(vim.fn.getcwd())
  return ('removed %s debug msgs in: %s'):format(removed, name)
end

local remove_logs_buffer = function()
  local removed = remove_logs(0)
  if removed > 0 then
    local msg = remove_logs_notify(0, removed)
  end
  vim.notify(msg, vim.log.levels.INFO, { title = 'Chainsaw Buffer' })
end

local remove_logs_open = function()
  local open_files = get_open_filelist(vim.fn.getcwd())
  local messages = {}
  for _, file in ipairs(open_files) do
    local bufnr = vim.fn.bufnr(file)
    if bufnr ~= -1 then
      local removed = remove_logs(bufnr)
      if removed and removed > 0 then
        table.insert(messages, remove_logs_notify(bufnr, removed))
      end
    end
  end
  vim.notify(messages, vim.log.levels.INFO, { title = 'Chainsaw' })
end

remove_logs_open()

-- local remove_logs_project = function()
--   local open_files = get_open_filelist(vim.fn.getcwd())
--   local messages = {}
--   for _, file in ipairs(open_files) do
--     local bufnr = vim.fn.bufnr(file)
--     if bufnr ~= -1 then
--       local removed = remove_logs(0)
--       if removed > 0 then
--         table.insert(messages, remove_logs_notify(bufnr, removed))
--       end
--     end
--   end
--   vim.notify(messages, vim.log.levels.INFO, { title = 'Chainsaw Open Files' })
-- end
--
