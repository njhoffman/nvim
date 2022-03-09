require("project_nvim").setup({
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,
  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  -- detection_methods = { "pattern", "lsp", "!.git/worktrees", "!=extras", "!^fixtures", "!build/env.sh" },
  detection_methods = { "pattern", "!.git/worktrees", "!=extras", "!^fixtures", "!build/env.sh" },
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = {
    -- "package.json",
    ".git",
    -- "Makefile",
    -- "_darcs",
    -- ".hg",
    -- ".bzr",
    -- ".svn",
    "node_modules",
    -- "CMakeLists.txt",
    ".project",
  },
  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},
  -- When set to false, you will get a message when project.nvim changes your directory.
  silent_chdir = false,
})

vim.cmd [[command! ProjectGetRoot lua print(vim.inspect(require('project_nvim.project').get_project_root()))]]

require("project_nvim.project").on_buf_enter()

-- lua print(vim.inspect(require('project_nvim.project').get_project_root()))
-- local projects = require("project_nvim.utils.history")
-- local recent_projects = projects.get_recent_projects()
-- print(vim.inspect(recent_projects))
