-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')

-- require('qfview').setup()
require('utils.lazy').setup({ cache = false, reload = false, lazy = false })

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
  'tracker.setup',
  'configs.registers',
  'action-hints.setup',
  'early-retirement.setup',
  'oldfiles',
  'hover.setup',
  'configs.feline',
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

  local map = require('mapper').map
  map('i', '<C-D>', '<cmd>norm x<cr>', { -- <C-o> + dl, norm lxh
    category = 'Motion',
    desc = 'delete next char',
  })

  map('i', '<M-d>', '<cmd>norm d$<cr>', {
    category = 'Motion',
    desc = 'delete next char',
  })

  map('n', '<M-}>', '<cmd>norm v}<cr>', {
    category = 'Motion',
    desc = 'traverse blocks forward with select',
  })
  map('x', '<M-}>', '<cmd>norm }<cr>', {
    category = 'Motion',
    desc = 'traverse blocks forward with select',
  })

  map('n', '<M-{>', '<cmd>norm v{<cr>', {
    category = 'Motion',
    desc = 'traverse blocks backwards with select',
  })
  map('x', '<M-{>', '<cmd>norm {<cr>', {
    category = 'Motion',
    desc = 'traverse blocks backwards with select',
  })

  vim.keymap.set('n', '<M-0>', 'i<M-0><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set('n', '<M-9>', 'i<M-9><esc>', { remap = true, desc = 'warp pair symbol backwards' })
  vim.keymap.set({ 'i', 'n' }, '<M-.>', '<M-0>', { remap = true, desc = 'warp pair symbol forwards' })
  vim.keymap.set({ 'i', 'n' }, '<M-,>', '<M-9>', { remap = true, desc = 'warp pair symbol forwards' })
  vim.keymap.set('i', "<M-'>", '<M-0>', { remap = true, desc = 'warp pair symbol forwards' })
  vim.keymap.set('i', '<M-;>', '<M-9>', { remap = true, desc = 'warp pair symbol backwards' })
end, 100)

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
