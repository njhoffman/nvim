-- local version = vim.cmd([[
--   echo matchstr(execute('version'), 'NVIM v\zs[^\n]*')
-- ]])

local version = vim.fn.matchstr(vim.api.nvim_command_output('version'), 'NVIM v\\zs[^\\n]*')
-- NVIM v0.10.0-dev-927+g21152f790
vim.dbg(version)
