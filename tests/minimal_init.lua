-- Minimal init file for testing
-- This loads only the essential plugins needed for tests

-- Add current directory to runtimepath
vim.opt.rtp:prepend(".")

-- Add plenary.nvim
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 1 then
  vim.opt.rtp:append(plenary_path)
  vim.cmd("runtime! plugin/plenary.vim")
end

-- Add mini.test
local minitest_path = vim.fn.stdpath("data") .. "/lazy/mini.test"
if vim.fn.isdirectory(minitest_path) == 1 then
  vim.opt.rtp:append(minitest_path)
end

-- Set up basic test environment
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = false
