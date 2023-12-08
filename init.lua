-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')
-- require('qfview').setup()
require('utils.lazy').setup({ cache = true, reload = false, lazy = false })

-- qfSeparator, qfLineNr, qfFilename
for _, mod_name in ipairs({
  'dial',
  'wf-setup',
  'devbox',
  'project',
  'runner',
  'stats',
  'oldfiles',
  'hover.setup',
  'configs.feline',
  'abbreviations',
  'keymaps',
  'commands',
  'autocommands',
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

-- require('scroll-eof').setup({
--   scrolloff = 3,
--   -- The pattern used for the internal autocmd to determine
--   -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
--   pattern = '*',
--   -- Whether or not scrollEOF should be enabled in insert mode
--   insert_mode = false,
--   -- List of filetypes to disable scrollEOF for.
--   disabled_filetypes = {},
--   -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode() for available modes.
--   disabled_modes = {},
-- })

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
