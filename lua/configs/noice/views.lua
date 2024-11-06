local lsp_progress = {
  {
    "{progress} ",
    key = "progress.percentage",
    contents = {
      { "{data.progress.message} " },
    },
  },
  "({data.progress.percentage}%) ",
  { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
  { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
  { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
}
local lsp_progress_done = {
  { "✔ ", hl_group = "NoiceLspProgressSpinner" },
  { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
  { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
}

local errorViewFormat = {
  "{date} ",
  "{event}",
  { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
  " ",
  "{level} ",
  "{cmdline} ",
  "{title} ",
  "| {message}",
}

local telescopeViewFormat = {
  "{date} ",
  "{level} ",
  "{event}",
  { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
  " ",
  "{title} ",
  "{cmdline} ",
  "{message}",
}

local historyView = {
  -- options for the message history that you get with `:Noice`
  -- view = 'split',
  view = "popup",
  opts = { enter = true, format = errorViewFormat },
  filter = {
    any = {
      { event = "" },
      { event = "notify" },
      { error = true },
      { warning = true },
      { event = "msg_show" },
      { event = "lsp", kind = "message" },
    },
  },
}

local errorView = {
  -- backend = 'notify',
  opts = { enter = true, format = errorViewFormat },
  filter = {
    any = {
      { event = "" },
      { event = "notify" },
      { error = true },
      { warning = true },
      { event = "msg_show" },
    },
  },
}

local popupView = {
  backend = "popup",
  relative = "editor",
  close = {
    events = { "BufLeave" },
    keys = { "q", "<esc>" },
  },
  enter = true,
  position = "50%",
  win_options = {
    winhighlight = { Normal = "NoicePopup", FloatBorder = "NoicePopupBorder" },
    winbar = "",
    foldenable = false,
  },
  -- size = { width = "120", height = "20", },
  -- size = { width = 80, height = 40, },
  -- size = { width = "80%", height = 0.6, },
  size = {
    max_height = math.ceil(0.8 * vim.o.lines),
    max_width = math.ceil(0.9 * vim.o.columns),
    min_width = 10,
    height = "auto",
    width = "auto",
  },
  border = { style = "rounded", padding = { left = 1, right = 1 } },
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
  -- },
}

local hover_changes = {
  opacity = 80,
  border = { style = "none", padding = { 0, 0 } },
  position = { row = 1, col = 0 },
  -- shadow_blend = 36, -- if you using shadow as border use this set the opacity
  -- shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
}

local hoverView = {
  view = "popup",
  relative = "cursor",
  zindex = 45,
  enter = false,
  anchor = "auto",
  size = {
    width = "auto",
    height = "auto",
    max_height = 20,
    max_width = 120,
  },
  border = {
    style = "none",
    padding = { 0, 1 },
  },
  position = { row = 1, col = 0 },
  win_options = {
    wrap = true,
    linebreak = true,
  },
}

local cmdlineOutputSplitView = {
  format = "details",
  view = "split",
  enter = true,
}

local cmdlineOutputPopupView = {
  format = "details",
  view = "popup",
  enter = true,
  -- zindex = 200,
  size = {
    max_height = vim.o.lines - 9,
  },
  position = { row = 6, col = "50%" },
  win_options = { colorcolumn = "", signcolumn = "no" },
  buf_options = { filetype = "noice" },
}

local miniView = {
  zindex = 10,
  win_options = {
    winblend = 30,
  },
}

-- local render = require("notify.render._entry")

local notifyView = {
  -- render = 'minimal',
  merge = true,
  -- render = render,
  -- level = vim.log.levels.TRACE,
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
  backend = "popup",
  position = { row = 10, col = "50%" },
  size = { width = 60, height = "auto" },
  win_options = {
    winhighlight = {
      Normal = "NoiceCmdlinePopup",
      FloatBorder = "NoiceCmdlinePopupBorder",
      FloatTitle = "NoiceCmdlinePopupTitle",
      IncSearch = "",
      CurSearch = "",
      Search = "",
    },
    cursorline = false,
  },
}

-- builtin views:
--   cmdline        popup      mini      mini
--   cmdline_output split      notify    notify
--   cmdline_popup  popup      popup     popup
--   confirm        popup      popupmenu nui.menu
--   hover          popup      split     split
--   messages       split      vsplit    split
-- ['notify_error'] = views.errorView,

-- TODO: make popup view with previous messages collapsed
-- TODO: create view option to scroll multiline view
-- TODO: create view option to prepend instead of append
-- TODO: enter on shift+enter
-- TODO: clear cmdline on ctrl+enter
-- TODO: hotkey to toggle notify/popup/split views
-- TODO: cmdline and popup together preset
-- cmdline_popup = { position = { row = 5, col = "50%", }, size = { width = 60, height = "auto", }, },
-- popupmenu = { relative = "editor", position = { row = 8, col = "50%", }, size = { width = 60, height = 10, },
--              border = { style = "rounded", padding = { 0, 1 }, },
--              win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" }, }, },

local config = {
  mini = miniView,
  popup = popupView,
  notify = notifyView,
  cmdline_popup = cmdlinePopupView,
  cmdline_output = cmdlineOutputPopupView,
  cmdline_output_popup = cmdlineOutputPopupView,
  cmdline_output_split = cmdlineOutputSplitView,
}

return {
  config = config,
  historyView = historyView,
  errorView = errorView,
  errorViewFormat = errorViewFormat,
  telescopeViewFormat = telescopeViewFormat,
}
