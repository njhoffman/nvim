local require = require('noice.util.lazy')
local Config = require('noice.config')

local cmdlineView = {
  reverse = false,
  align = 'message-left',
  timeout = 5000,
  position = { row = -2, col = -2 },

  size = {
    max_height = math.ceil(0.8 * vim.o.lines),
    max_width = math.ceil(0.5 * vim.o.columns),
    min_width = 30,
    width = 'auto',
    height = 'auto',
  },
  border = {
    text = { top = '', top_align = 'left', bottom = '' },
    style = {
      { '▐', 'NoiceMiniBorder' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { '▐', 'NoiceMiniBorder' },
      { '▐', 'NoiceMiniBorder' },
    },
    padding = { top = 0, bottom = 0, left = 1, right = 0 },
  },
  win_options = { winblend = 0 },
}

local miniView = {
  backend = 'mini',
  relative = 'editor',
  align = 'message-left',
  timeout = 100,
  reverse = true,
  position = { row = -2, col = 0 },
  size = 'auto',
  zindex = 60,
  border = {
    style = {
      { '╭', 'NoiceCmdlineBorder' },
      { '─', 'NoiceCmdlineBorder' },
      { '╮', 'NoiceCmdlineBorder' },
      { '│', 'NoiceCmdlineBorder' },
      { '╯', 'NoiceCmdlineBorder' },
      { '─', 'NoiceCmdlineBorder' },
      { '╰', 'NoiceCmdlineBorder' },
      { '│', 'NoiceCmdlineBorder' },
    },
    padding = { left = 1, right = 1 },
  },

  win_options = {
    winblend = 0,
    winhighlight = { Normal = 'NoiceCmdlineNormal', IncSearch = '', Search = '' },
  },
}

local miniViewDefault = {
  backend = 'mini',
  relative = 'editor',
  align = 'message-right',
  timeout = 2000,
  reverse = true,
  focusable = false,
  position = {
    row = -1,
    col = '100%',
    -- col = 0,
  },
  size = 'auto',
  border = {
    style = 'none',
  },
  zindex = 60,
  win_options = {
    winbar = '',
    foldenable = false,
    winblend = 30,
    winhighlight = {
      Normal = 'NoiceMini',
      IncSearch = '',
      CurSearch = '',
      Search = '',
    },
  },
}

local errorViewFormat = {
  '{date} ',
  '{event}',
  { '{kind}', before = { '.', hl_group = 'NoiceFormatKind' } },
  ' ',
  '{level} ',
  '{cmdline} ',
  '{title} ',
  '| {message}',
}

local historyView = {
  -- options for the message history that you get with `:Noice`
  -- view = 'split',
  view = 'popup',
  opts = { enter = true, format = errorViewFormat },
  filter = {
    any = {
      { event = '' },
      { event = 'notify' },
      { error = true },
      { warning = true },
      { event = 'msg_show' },
      { event = 'lsp', kind = 'message' },
    },
  },
}

local errorView = {
  backend = 'notify',
  opts = { enter = true, format = errorViewFormat },
  filter = {
    any = {
      { event = '' },
      { event = 'notify' },
      { error = true },
      { warning = true },
      { event = 'msg_show' },
    },
  },
}

local extView = {
  backend = 'notify-backend',
  opts = { enter = true, format = errorViewFormat },
  filter = {
    any = {
      { event = '' },
      { event = 'notify' },
      { error = true },
      { warning = true },
      { event = 'msg_show' },
    },
  },
}

return {
  extView = extView,
  historyView = historyView,
  errorView = errorView,
  miniView = miniView,
  cmdlineView = cmdlineView,
  errorViewFormat = errorViewFormat,
}
