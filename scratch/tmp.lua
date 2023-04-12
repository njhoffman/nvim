vim.dbglog(vim.b.gitsigns_status_dict)

-- local void = require("gitsigns.async").void
-- local git = require("gitsigns.git")
-- local scheduler = require("gitsigns.async").scheduler
-- void(function()
--   -- local repo = git.get_repo_info("/home/nicholas/.config/nvim")
--   vim.dbglog(git.try_worktrees(vim.fn.expand("%:h")))
--   local repo = git.get_repo_info("/home/nicholas/git/neovim")
--   vim.dbglog(repo)
-- end)()
-- vim.dbglog(gitsigns.get_repo_info(vim.fn.expand("%:p")))
