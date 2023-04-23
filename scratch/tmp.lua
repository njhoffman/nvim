-- local void = require("gitsigns.async").void
local git = require("gitsigns.git")
local bufnr = vim.api.nvim_get_current_buf()
-- local bufnr = 5876
local res = vim.api.nvim_buf_get_var(bufnr, "gitsigns_status_dict")
-- vim.api.nvim_eval()
-- vim.api.nvim_exec2()
-- vim.dbglog("res", res)
-- print(vim.inspect(res))
return res

-- local scheduler = require("gitsigns.async").scheduler
-- void(function()
--   -- local repo = git.get_repo_info("/home/nicholas/.config/nvim")
--   vim.dbglog(git.try_worktrees(vim.fn.expand("%:h")))
--   local repo = git.get_repo_info("/home/nicholas/git/neovim")
--   vim.dbglog(repo)
-- end)()
-- vim.dbglog(gitsigns.get_repo_info(vim.fn.expand("%:p")))
