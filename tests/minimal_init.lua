-- Minimal init file for testing
-- This loads only the essential plugins needed for tests

-- Add current directory and plenary to runtimepath
vim.opt.rtp:append(".")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/plenary.nvim")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/mini.nvim")

-- Required for many tests
vim.cmd("runtime! plugin/plenary.vim")

-- Set up basic test environment
vim.o.swapfile = false
vim.o.loadplugins = false
