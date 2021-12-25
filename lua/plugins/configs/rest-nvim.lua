
-- , run the request under the cursor
-- http://www.google.com
vim.cmd([[command! RESTRun lua require('rest.nvim').RestNvim()]])
-- preview the request curl command
vim.cmd([[command! RESTPreview lua require('rest.nvim').RestNvimPreview()]])
--  re-run the last request
vim.cmd([[command! RESTRunLast lua require('rest.nvim').RestRunLast()]])
require("rest-nvim").setup({ requires = { "nvim-lua/plenary.nvim" }, result_split_horizontal = false })
