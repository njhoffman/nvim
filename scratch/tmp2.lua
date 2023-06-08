local test_scratch = function()
  return _sd * 5
end

vim.api.nvim_create_user_command('TestScratch', test_scratch, {})

-- local line = 'E5113: Error: notify-test:63: hey'
-- vim.dbglog(vim.fn.split(line, ': \\?'))
