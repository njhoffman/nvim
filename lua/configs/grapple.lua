local default_cfg = {
  ---@type "debug" | "info" | "warn" | "error"
  log_level = 'warn',

  ---Can be either the name of a builtin scope resolver,
  ---or a custom scope resolver
  ---@type string | Grapple.ScopeResolver
  scope = 'git',

  ---The save location for tags
  ---@type string
  -- save_path = tostring(Path:new(vim.fn.stdpath('data')) / 'grapple'),

  ---Window options used for the popup menu
  popup_options = {
    relative = 'editor',
    width = 60,
    height = 12,
    style = 'minimal',
    focusable = false,
    border = 'single',
  },

  integrations = {
    ---Support for saving tag state using resession.nvim
    resession = false,
  },
}
local cfg = { popup_options = { border = 'rounded' } }
require('grapple').setup(cfg)
vim.keymap.set('n', '<leader>m', require('grapple').toggle)
-- vim.keymap.set('n', '<leader>j', function()
--   require('grapple').select({ key = '{name}' })
-- end)
--
-- vim.keymap.set('n', '<leader>J', function()
--   require('grapple').toggle({ key = '{name}' })
-- end)
