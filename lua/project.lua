local project_chdir = function(dir, method)
  dir = dir:gsub(vim.fn.getenv("HOME"), "~")
  local lsp = string.match(method, '"([^%s]+)" lsp')
  local icon = "  "
  local msg = icon .. " " .. dir
  if method == ".git" then
    icon = "  "
    msg = icon .. " " .. method
  elseif lsp ~= "" and lsp ~= nil then
    icon = "" -- 
    msg = icon .. "[" .. lsp .. "] " .. dir
  end
  vim.notify(msg, "trace")
end

local project_cfg = {
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,
  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  detection_methods = { "lsp", "pattern" },
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},
  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},
  -- Show hidden files in telescope
  show_hidden = true,
  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = false,
  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath("data"),
  chdir_func = project_chdir
}

vim.api.nvim_create_user_command(
  "ProjectGetRoot",
  function()
    local root = require("project_nvim.project").get_project_root()
    vim.notify(root, "info")
  end,
  {
    nargs = 0,
    desc = "Get project root"
  }
)
vim.api.nvim_create_user_command(
  "ProjectGetRecent",
  function()
    local history = require("project_nvim.utils.history")
    vim.notify(history.get_recent_projects(), "inspect")
  end,
  {
    nargs = 0,
    desc = "Get recent projects list"
  }
)

require("project_nvim").setup(project_cfg)
