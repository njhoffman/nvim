local lsp_progress = {
  {
    '{progress} ',
    key = 'progress.percentage',
    contents = {
      { '{data.progress.message} ' },
    },
  },
  '({data.progress.percentage}%) ',
  { '{spinner} ', hl_group = 'NoiceLspProgressSpinner' },
  { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
  { '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
}
local lsp_progress_done = {
  { '✔ ', hl_group = 'NoiceLspProgressSpinner' },
  { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
  { '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
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

local telescopeViewFormat = {
  '{date} ',
  '{level} ',
  '{event}',
  { '{kind}', before = { '.', hl_group = 'NoiceFormatKind' } },
  ' ',
  '{title} ',
  '{cmdline} ',
  '{message}',
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
  -- backend = 'notify',
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

local popupView = {
  backend = 'popup',
  relative = 'editor',
  close = {
    events = { 'BufLeave' },
    keys = { 'q' },
  },
  enter = true,
  border = {
    style = 'rounded',
  },
  position = '50%',
  size = {
    width = '120',
    height = '20',
  },
  win_options = {
    winhighlight = { Normal = 'NoicePopup', FloatBorder = 'NoicePopupBorder' },
    winbar = '',
    foldenable = false,
  },
}

local hoverView = {
  view = 'popup',
  relative = 'cursor',
  zindex = 45,
  enter = false,
  anchor = 'auto',
  size = {
    width = 'auto',
    height = 'auto',
    max_height = 20,
    max_width = 120,
  },
  border = {
    style = 'none',
    padding = { 0, 2 },
  },
  position = { row = 1, col = 0 },
  win_options = {
    wrap = true,
    linebreak = true,
  },
}

local popupView = {
  -- size = {
  --   width = 80,
  --   height = 40,
  -- },
  -- size = {
  --   width = "80%",
  --   height = 0.6,
  -- },
  size = {
    -- max_height = math.ceil(0.8 * vim.o.lines),
    -- width = 'auto',
    -- max_width = 120,
    -- width = math.floor(0.9 * vim.o.columns),
    min_width = 10,
    height = 20,
  },
  border = {
    style = 'rounded',
    padding = { left = 1, right = 1 },
  },
  close = { keys = { 'q', '<esc>' } },
  -- win_options = {
  --      winbar = "",
  --      foldenable = false,
  --      cursorline = true,
  --      cursorlineopt = "line",
  --      winhighlight = {
  --        Normal = "NoicePopupmenu", -- change to NormalFloat to make it look like other floats
  --        FloatBorder = "NoicePopupmenuBorder", -- border highlight
  --        CursorLine = "NoicePopupmenuSelected", -- used for highlighting the selected item
  --        PmenuMatch = "NoicePopupmenuMatch", -- used to highlight the part of the item that matches the input
  --      },
  --    },
}

local cmdlineOutputView = {
  format = 'details',
  view = 'popup',
  zindex = 200,
  size = {
    width = '90%',
  },
  win_options = {
    colorcolumn = '',
  },
  buf_options = {
    filetype = 'noice',
  },
}

local miniView = {
  zindex = 10,
  win_options = {
    winblend = 30,
    winhighlight = {
      Normal = 'NoiceMini',
      IncSearch = '',
      Search = '',
    },
  },
}

local render = require('notify.render._entry')

local notifyView = {
  -- render = 'minimal',
  merge = true,
  render = render,
  level = vim.log.levels.TRACE,
  -- fps = 30,
  -- stages = 'fade_in_slide_out',
  -- background_colour = '#000000',
  -- timeout = 5000,
  -- minimum_width = 5,
  -- max_height = function()
  --   return math.floor(vim.opt.lines:get() / 5 * 4)
  -- end,
  -- max_width = function()
  --   return math.floor(vim.opt.columns:get() / 5 * 3)
  -- end,
  -- icons = {
  --   ERROR = '',
  --   WARN = '',
  --   INFO = '',
  --   DEBUG = '',
  --   TRACE = '✎',
  --   INSPECT = '',
  --   RUN = '',
  --   STATUS = '',
  -- },
}

local cmdlinePopupView = {
  backend = 'popup',
  position = { row = 10, col = '50%' },
  size = { width = 60, height = 'auto' },
  win_options = {
    winhighlight = {
      Normal = 'NoiceCmdlinePopup',
      FloatBorder = 'NoiceCmdlinePopupBorder',
      FloatTitle = 'NoiceCmdlinePopupTitle',
      IncSearch = '',
      CurSearch = '',
      Search = '',
    },
    cursorline = false,
  },
}

-- builtin views:
--   notify         notify
--   split          split
--   vsplit         split
--   popup          popup
--   mini           mini
--   cmdline        popup
--   cmdline_popup  popup
--   cmdline_output split
--   messages       split
--   confirm        popup
--   hover          popup
--   popupmenu      nui.menu

-- ['notify_error'] = views.errorView,

local config = {
  mini = miniView,
  popup = popupView,
  notify = notifyView,
  cmdline_popup = cmdlinePopupView,
  cmdline_output = cmdlineOutputView,
}

return {
  config = config,
  historyView = historyView,
  errorView = errorView,
  errorViewFormat = errorViewFormat,
  telescopeViewFormat = telescopeViewFormat,
}
