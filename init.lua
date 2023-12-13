-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')

-- require('qfview').setup()
require('utils.lazy').setup({ cache = true, reload = false, lazy = false })

-- qfSeparator, qfLineNr, qfFilename
for _, mod_name in ipairs({
  'keymaps',
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
  'commands',
  'autocommands',
}) do
  vim.import(mod_name)
end

-- vim.fn.input()

vim.defer_fn(function()
  require('configs.registers')
  require('sidebar').setup()
  require('tracker').setup({
    metrics = {
      -- 'aucommands' = {},
      -- 'augroups' = {},
      -- highlights = {},
    },
    events = {
      -- 'BufAdd',
      'BufDelete',
      --   'BufEnter',
      --   'BufFilePost',
      --   'BufFilePre',
      --   'BufHidden',
      --   'BufLeave',
      --   'BufModifiedSet',
      'BufNew',
      --   'BufNewFile',
      -- 'BufRead ',
      --   'BufReadPost',
      --   'BufReadPre ',
      --   'BufUnload',
      --   'BufWinEnter',
      --   'BufWinLeave',
      --   'BufWipeout',
      'BufWrite',
      --   'BufWritePost',
      --   'BufWritePre',
      'ChanInfo',
      'ChanOpen',
      'CmdUndefined',
      'CmdlineChanged',
      'CmdlineEnter',
      'CmdlineLeave',
      'CmdwinEnter',
      'CmdwinLeave',
      'ColorScheme',
      'ColorSchemePre',
      'CompleteChanged',
      'CompleteDone',
      'CompleteDonePre',
      -- 'CursorHold',
      -- 'CursorHoldI',
      -- 'CursorMoved',
      -- 'CursorMovedI',
      'DiffUpdated',
      'DirChanged',
      'DirChangedPre',
      'ExitPre',
      'FileAppendCmd',
      'FileAppendPost',
      'FileAppendPre',
      'FileChangedRO',
      'FileChangedShell',
      'FileChangedShellPost',
      'FileReadCmd',
      'FileReadPost',
      'FileReadPre',
      -- 'FileType',
      'FileWriteCmd',
      'FileWritePost',
      'FileWritePre',
      'FilterReadPost',
      'FilterReadPre',
      'FilterWritePost',
      'FilterWritePre',
      -- 'FocusGained',
      -- 'FocusLost',
      'FuncUndefined',
      -- 'InsertChange',
      -- 'InsertCharPre',
      -- 'InsertEnter',
      -- 'InsertLeave',
      -- 'InsertLeavePre',
      'MenuPopup',
      'ModeChanged',
      -- 'OptionSet',
      'QuickFixCmdPost',
      'QuickFixCmdPre',
      'QuitPre',
      'RecordingEnter',
      'RecordingLeave',
      'RemoteReply',
      'SearchWrapped',
      'SessionLoadPost',
      'ShellCmdPost',
      'ShellFilterPost',
      'Signal',
      'SourcePost',
      'SourcePre',
      'SpellFileMissing',
      'StdinReadPost',
      'StdinReadPre',
      'SwapExists',
      -- 'Syntax',
      'TabClosed',
      'TabEnter',
      'TabLeave',
      'TabNew',
      'TabNewEntered',
      'TermClose',
      'TermEnter',
      'TermLeave',
      'TermOpen',
      'TermResponse',
      -- 'TextChanged',
      -- 'TextChangedI',
      -- 'TextChangedP',
      -- 'TextChangedT',
      -- 'TextYankPost',
      'UIEnter',
      'UILeave',
      'User',
      'VimEnter',
      'VimLeave',
      'VimLeavePre',
      'VimResized',
      'VimResume',
      'VimSuspend',
      'WinClosed',
      -- 'WinEnter',
      -- 'WinLeave',
      'WinNew',
      -- 'WinResized',
      -- 'WinScrolled',
    },
  })
  require('early-retirement').setup({
    retirementAgeMins = 20,
    minimumBufferNum = 10,
    notificationOnAutoClose = true,
  })
  require('lab').setup({})
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
  require('mapper').map('i', '<C-D>', '<cmd>norm d$<cr>', {
    category = 'Motion',
    label = 'delete to eol',
    desc = 'delete until the end of line',
  })

  vim.keymap.set({ 'n', 'i' }, '<M-.>', 'i<M-0><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set({ 'n', 'i' }, '<M-,>', 'i<M-9><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set('n', '<M-0>', 'i<M-0><esc>', { remap = true, desc = 'warp pair symbol forwads' })
  vim.keymap.set('n', '<M-9>', 'i<M-9><esc>', { remap = true, desc = 'warp pair symbol backwards' })
end, 100)

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
