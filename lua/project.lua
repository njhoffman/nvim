local display = require('project_nvim.display')

-- local notify_id = nil
-- local change_project = function(dir, method)
--   local notify = require('notify')
--   local lsp = string.match(method or '', 'lsp "([^%s]+)"')
--   dir = dir:gsub(vim.fn.getenv('HOME'), '~')
--   local icon, highlight = display.get_icon(method, lsp)
--   -- local title = icon
--   local msg = ' ' .. icon .. ' ' .. dir
--   -- local msg = dir
--   notify.dismiss({})
--   notify_id = notify.notify(msg, 1, {
--     -- replace = notify_id,
--     -- title = title,
--     render = 'minimal',
--     on_close = function()
--       notify_id = nil
--     end,
--   })
-- end

local project_config = {
  -- Must use `:ProjectRoot` command to change directory
  manual_mode = false,
  -- order of detection methods: "lsp", "pattern"
  detection_methods = { 'lsp', 'pattern' },
  -- All the patterns used to detect root dir, when **"pattern"** is in detection_methods
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
  -- Table of lsp clients to ignore by name eg: { "efm", ... }
  ignore_lsp = { 'null-ls', 'copilot' },
  -- Don't calculate root dir on specific directories Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},
  -- Show hidden files in telescope
  show_hidden = true,
  -- When set to false, you will get a message when project.nvim changes your directory.
  silent_chdir = false,
  -- Path where project.nvim will store the project history for use in telescope
  datapath = vim.fn.stdpath('data'),
  chdir_func = change_project,
  last_session_project_on_startup = false,
  last_session_other_on_startup = false,
}

require('project_nvim').setup(project_config)

local cmd = vim.api.nvim_create_user_command
local get_root = function()
  local path, method = require('project_nvim.project').get_project_root()
  local line = path or ''
  if method then
    line = path .. '  [' .. method .. ']'
  end
  vim.notify(line, 2, { title = method, anchor = 'TC' })
end

cmd('ProjectGetRoot', get_root, {
  nargs = 0,
  desc = 'Get project root path and method',
})

cmd('ProjectDbg', function()
  vim.dbg(require('project_nvim.state'))
end, { desc = 'Dump debugging data' })
