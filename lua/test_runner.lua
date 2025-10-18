-- Test runner module for Neovim configuration
-- Provides commands and functions to run tests from within Neovim

local M = {}

-- State to track test results
M.results = {
  unit = { passed = 0, failed = 0, total = 0 },
  integration = { passed = 0, failed = 0, total = 0 },
}

-- Run plenary-based unit tests
M.run_unit_tests = function(opts)
  opts = opts or {}
  local test_dir = opts.dir or vim.fn.stdpath("config") .. "/tests/unit"

  vim.notify("Running unit tests...", vim.log.levels.INFO)

  -- Use plenary test harness
  local ok, plenary = pcall(require, "plenary.test_harness")
  if not ok then
    vim.notify("Plenary not found. Install nvim-lua/plenary.nvim", vim.log.levels.ERROR)
    return
  end

  plenary.test_directory(test_dir, {
    minimal_init = vim.fn.stdpath("config") .. "/tests/minimal_init.lua",
    sequential = opts.sequential or false,
  })
end

-- Run mini.test-based integration tests
M.run_integration_tests = function(opts)
  opts = opts or {}

  vim.notify("Running integration tests...", vim.log.levels.INFO)

  local ok, minitest = pcall(require, "mini.test")
  if not ok then
    vim.notify("Mini.test not found. Install echasnovski/mini.nvim", vim.log.levels.ERROR)
    return
  end

  -- Collect and run tests
  local test_dir = opts.dir or vim.fn.stdpath("config") .. "/tests/integration"
  minitest.setup({
    collect = {
      find_files = function()
        return vim.fn.globpath(test_dir, "**/test_*.lua", true, true)
      end,
    },
  })

  minitest.run()
end

-- Run all tests
M.run_all_tests = function()
  vim.notify("Running all tests...", vim.log.levels.INFO)

  M.run_unit_tests()
  vim.defer_fn(function()
    M.run_integration_tests()
  end, 1000) -- Delay integration tests to ensure unit tests complete
end

-- Run specific test file
M.run_test_file = function(filepath)
  if not filepath then
    filepath = vim.fn.expand("%:p")
  end

  if not vim.endswith(filepath, ".lua") then
    vim.notify("Not a Lua file: " .. filepath, vim.log.levels.ERROR)
    return
  end

  -- Determine test type based on path
  if filepath:match("tests/unit") then
    vim.notify("Running unit test: " .. filepath, vim.log.levels.INFO)
    local plenary = require("plenary.test_harness")
    plenary.test_file(filepath)
  elseif filepath:match("tests/integration") or filepath:match("test_") then
    vim.notify("Running integration test: " .. filepath, vim.log.levels.INFO)
    local minitest = require("mini.test")
    minitest.run_file(filepath)
  else
    vim.notify("Unknown test type for: " .. filepath, vim.log.levels.WARN)
  end
end

-- Setup commands
M.setup_commands = function()
  vim.api.nvim_create_user_command("TestUnit", function()
    M.run_unit_tests()
  end, { desc = "Run unit tests (plenary)" })

  vim.api.nvim_create_user_command("TestIntegration", function()
    M.run_integration_tests()
  end, { desc = "Run integration tests (mini.test)" })

  vim.api.nvim_create_user_command("TestAll", function()
    M.run_all_tests()
  end, { desc = "Run all tests" })

  vim.api.nvim_create_user_command("TestFile", function()
    M.run_test_file()
  end, { desc = "Run current test file" })

  vim.api.nvim_create_user_command("TestNearest", function()
    -- Run nearest test (mini.test feature)
    local minitest = require("mini.test")
    minitest.run_at_location()
  end, { desc = "Run nearest test case" })
end

return M
