-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')
require('utils.lazy').setup({ cache = true, reload = false, lazy = false })

for _, mod_name in ipairs({
  'keymaps',
  'project',
  'dial',
  'wf-setup',
  'devbox',
  'commands',
  'autocommands',
  'runner',
  'stats',
  'oldfiles',
  'hover.setup',
  'lsp.illuminate',
  'configs.feline',
}) do
  vim.import(mod_name)
end

-- vim.fn.input()

require('sidebar').setup()
require('tracker').setup({ event_tracker = false, only_events = { 'User' } })
require('early-retirement').setup({
  retirementAgeMins = 20,
  minimumBufferNum = 10,
  notificationOnAutoClose = true,
})

local llm_config = require('llm-config')
require('llm').setup(llm_config)

local neoai_cfg = require('neoai.options')
require('neoai').setup(neoai_cfg)

local chatgpt_cfg = require('configs.chatgpt')
require('chatgpt').setup(chatgpt_cfg)

require('action-hints').setup({
  template = {
    definition = { text = ' ⊛', color = '#517c8a' },
    references = { text = ' ↱%s', color = '#8b0000' },
    codeactions = { text = ' %s', color = '#006ea5' },
  },
  use_virtual_text = true,
})

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
