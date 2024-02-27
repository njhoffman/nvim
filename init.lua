-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')

require('quickfix')

require('utils.lazy').setup({ cache = true, reload = false, lazy = false })

-- qfSeparator, qfLineNr, qfFilename
for _, mod_name in ipairs({
  'keymaps',
  'commands',
  'abbreviations',
  'autocommands',
  'dial',
  'wf-setup',
  'devbox',
  'project',
  'runner',
  'stats',
  'devdocs.setup',
  'configs.cinnamon',
  'tracker.setup',
  'configs.registers',
  'configs.neoscroll',
  'action-hints.setup',
  -- 'winsep.setup',
  -- 'better_escape-setup',
  'early-retirement.setup',
  'oldfiles',
  'tail',
  'hover.setup',
  'configs.feline',
  'nvim-lastplace-setup',
  'baleia.setup',
}) do
  vim.import(mod_name)
end

vim.defer_fn(function()
  require('sidebar').setup()

  -- 'lab.setup',
  local llm_config = require('llm-config')
  require('llm').setup(llm_config)

  local neoai_cfg = require('neoai.options')
  require('neoai').setup(neoai_cfg)

  local chatgpt_cfg = require('configs.chatgpt')
  require('chatgpt').setup(chatgpt_cfg)

  -- local map = require('mapper').map

  vim.keymap.set('n', '<M-0>', 'i<M-0><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set('n', '<M-9>', 'i<M-9><esc>', { remap = true, desc = 'warp pair symbol backwards' })
  -- vim.keymap.set('n', '<M-)>', 'i<M-)><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  -- vim.keymap.set('n', '<M-(>', 'i<M-(><esc>', { remap = true, desc = 'warp pair symbol backwards' })

  -- vim.keymap.set({ 'i', 'n' }, '<M-.>', '<M-0>', { remap = true, desc = 'warp pair symbol forwards' })
  -- vim.keymap.set({ 'i', 'n' }, '<M-,>', '<M-9>', { remap = true, desc = 'warp pair symbol forwards' })
  -- vim.keymap.set('i', "<M-'>", '<M-0>', { remap = true, desc = 'warp pair symbol forwards' })
  -- vim.keymap.set('i', '<M-;>', '<M-9>', { remap = true, desc = 'warp pair symbol backwards' })
end, 100)

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
