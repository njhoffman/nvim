local strip_ansi_codes = function(bufnr, ansi_count)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  vim.notify('stripping ' .. ansi_count .. ' ANSI codes from buffer: ' .. bufnr)
  local content = type(lines) == 'string' and vim.fn.split(lines, '\n') or lines
  local ansi_pattern = '\x1b[[0-9][:;0-9]*m'
  local new_lines = vim.tbl_map(function(line)
    return string.gsub(line, ansi_pattern, '') or string
  end, content)
  return new_lines
end

-- To automatically colorize when a new line is added use
-- let s:baleia = luaeval("require('baleia').setup { }")
-- autocmd BufWinEnter my-buffer call s:baleia.automatically(bufnr('%'))

local replace_ansi_codes = function(bufnr, count)
  -- local new_lines = strip_ansi_codes(bufnr, count)
  local lastline = vim.api.nvim_buf_line_count(bufnr)
  vim.notify('replacing ' .. count .. ' ANSI codes in buffer: ' .. bufnr)

  local is_modifiable = vim.api.nvim_get_option_value('modifiable', { buf = bufnr })
  if not is_modifiable then
    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
  end

  local baleia = require('baleia').setup(require('configs.baleia'))
  baleia.once(bufnr)
  -- baleia.buf_set_lines(bufnr, 0, lastline, true, new_lines)
  if is_modifiable then
    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
  end
end

local check_ansi_colors = function(lines)
  local content = type(lines) == 'string' and vim.fn.split(lines, '\n') or lines
  local ansi_pattern = '\x1b[[0-9][:;0-9]*m'
  local ansi_colors = vim.tbl_filter(function(line)
    return string.match(line, ansi_pattern)
  end, content)
  local count = vim.tbl_count(ansi_colors)
  return count > 0, count
end

local check_and_format_buffer = function(ev)
  local bufnr = type(ev) == 'number' and ev or ev.buffer or vim.api.nvim_get_current_buf()
  local last_line = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, last_line, false)
  local has_ansi, count = check_ansi_colors(lines)
  if has_ansi == true then
    replace_ansi_codes(bufnr, count)
  end
  vim.dbglog('has_ansi: ' .. tostring(has_ansi) .. '(' .. bufnr .. ') count: ' .. count)
  -- if has_ansi then
  --   replace_ansi_codes(bufnr, count)
  -- end
end

-- local lines = { "\x1b[32mHello \x1b[33mworld!", "^[[0m^[[35mplugin/fake.vim^[[0m:^[[0m^[[1m^[[31m" Testing ^[[0m" }
vim.api.nvim_create_user_command('AnsiBuffers', function(ev)
  local bufnrs = type(ev.fargs and ev.fargs[1]) == 'number' and { ev.fargs[1] } or vim.api.nvim_list_bufs()
  local filtered = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf)
  end, bufnrs)
  for _, bufnr in ipairs(filtered) do
    check_and_format_buffer(bufnr)
  end
end, { desc = 'replace ANSI codes with colors', nargs = 0 })

vim.cmd([[
  let s:baleia = luaeval("require('baleia').setup { }")
  command! AnsiColorize call s:baleia.once(bufnr('%'))
]])

local group = vim.api.nvim_create_augroup('baleia', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'log' },
  callback = check_and_format_buffer,
  group = group,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = { 'quickfix', 'notify' },
  callback = check_and_format_buffer,
  group = group,
})

-- local bufnrs = vim.api.nvim_list_bufs()
-- for _, bufnr in ipairs(bufnrs) do
--   vim.dbglog('checking: ' .. bufnr)
--   check_and_format_buffer(bufnr)
-- end

return {
  check_and_format_buffer = check_and_format_buffer,
}
