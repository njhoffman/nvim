---@class ProjectOptions
local defaults = {
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,
  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  detection_methods = { 'lsp', 'pattern' },
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},
  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},
  -- Show hidden files in telescope
  show_hidden = false,
  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = true,
  -- Custom function to handle chdir message
  chdir_func = true,
  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath('data'),
  -- Allows the user to declare a custom callback to execute before project selection
  -- occurs, such as when moving from one project to another
  before_project_selection_callback = function() end,
  -- Allows the user to declare a custom callback to execute after project selection
  after_project_selection_callback = function() end,
  -- Load the most recent session on startup if not in the project directory
  last_session_on_startup = true,

  -- Overwrite some of Session Manager options
  session_manager_opts = {
    autosave_ignore_dirs = {
      vim.fn.expand('~'), -- don't create a session for $HOME/
      '/tmp',
    },
    autosave_ignore_filetypes = {
      -- All buffers of these file types will be closed before the session is saved
      'ccc-ui',
      'gitcommit',
      'gitrebase',
      'qf',
      'toggleterm',
    },
  },
  -- Project directories
  projects = {
    '~/lazy/*',
    '~/git/*',
    '~/.config/*',
  },
}

---@type ProjectOptions
local options = {}

local init = function(_options)
  options = vim.tbl_deep_extend('force', defaults, _options or {})

  local glob = require('project_nvim.utils.globtopattern')
  local home = vim.fn.expand('~')
  options.exclude_dirs = vim.tbl_map(function(pattern)
    if vim.startswith(pattern, '~/') then
      pattern = home .. '/' .. pattern:sub(3, #pattern)
    end
    return glob.globtopattern(pattern)
  end, options.exclude_dirs)

  vim.opt.autochdir = false -- implicitly unset autochdir
end

local get = function(key)
  return key == nil and options or options[key]
end

return { init = init, get = get }
