-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')

-- require('qfview').setup()
require('utils.lazy').setup({ cache = true, reload = false, lazy = false })

-- qfSeparator, qfLineNr, qfFilename
for _, mod_name in ipairs({
  'keymaps',
  'commands',
  'autocommands',
  'abbreviations',
  'dial',
  'wf-setup',
  'devbox',
  'project',
  'runner',
  'stats',
  'devdocs.setup',
  'tracker.setup',
  'configs.registers',
  'action-hints.setup',
  'early-retirement.setup',
  'oldfiles',
  'hover.setup',
  'configs.feline',
}) do
  vim.import(mod_name)
end

-- vim.fn.input()

vim.defer_fn(function()
  require('sidebar').setup()

  -- 'lab.setup',
  local llm_config = require('llm-config')
  require('llm').setup(llm_config)

  local neoai_cfg = require('neoai.options')
  require('neoai').setup(neoai_cfg)

  local chatgpt_cfg = require('configs.chatgpt')
  require('chatgpt').setup(chatgpt_cfg)

  local map = require('mapper').map
  map('i', '<C-D>', '<cmd>norm d$<cr>', {
    category = 'Motion',
    label = 'delete to eol',
    desc = 'delete until the end of line',
  })

  vim.keymap.set('n', '<M-0>', 'i<M-0><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set('n', '<M-9>', 'i<M-9><esc>', { remap = true, desc = 'warp pair symbol backwards' })
  vim.keymap.set({ 'i', 'n' }, '<M-.>', '<M-0>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set({ 'i', 'n' }, '<M-,>', '<M-9>', { remap = true, desc = 'warp pair symbol forwads' })
end, 100)

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
