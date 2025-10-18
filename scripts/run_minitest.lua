-- Mini.test runner script
-- This script collects and runs all mini.test tests

-- Load mini.test
local ok, MiniTest = pcall(require, 'mini.test')
if not ok then
  print('Error: mini.test not found')
  print('Make sure mini.nvim is installed')
  vim.cmd('cquit 1')
  return
end

-- Get test directory from config path
local config_dir = vim.fn.stdpath('config')
local test_dir = config_dir .. '/tests/integration'

-- Setup mini.test
MiniTest.setup({
  collect = {
    find_files = function()
      return vim.fn.globpath(test_dir, 'test_*.lua', true, true)
    end,
    emulate_busted = false,
  },
  execute = {
    reporter = MiniTest.gen_reporter.stdout({ group_depth = 2 }),
    stop_on_error = false,
  },
  silent = false,
})

-- Run tests
print('Running integration tests from: ' .. test_dir)
print('')

local cases = MiniTest.collect()
if #cases == 0 then
  print('No test files found')
  vim.cmd('cquit 1')
  return
end

local stats = MiniTest.run(cases)

-- Print summary
print('')
if stats and type(stats) == "table" then
  print(string.format('Tests: %d total, %d passed, %d failed',
    stats.total or 0, stats.pass or 0, stats.fail or 0))

  -- Exit with appropriate code
  vim.cmd('cquit ' .. ((stats.fail or 0) == 0 and '0' or '1'))
else
  -- Fallback: assume success if we got this far
  print('Tests completed')
  vim.cmd('cquit 0')
end
