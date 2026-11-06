local ft_noice = "noice.log"

local lsp_progress = {
  {
    "{progress} ",
    key = "progress.percentage",
    contents = { { "{data.progress.message} " } },
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
  buf_options = {
    filetype = ft_noice,
    syntax = "noice.log.lua",
  },
  close = {
    events = { "BufLeave" },
    keys = { "q", "<esc>" },
  },
  enter = true,
  position = "50%",
  win_options = {
    winhighlight = { Normal = "NoicePopup", FloatBorder = "NoicePopupBorder" },
    winbar = "",
    scrolloff = 9999,
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
    scrolloff = 9999,
    linebreak = true,
  },
}

local cmdlineOutputSplitView = {
  format = "details",
  view = "split",
  enter = true,
  buf_options = { filetype = ft_noice },
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
  win_options = { colorcolumn = "", signcolumn = "no", scrolloff = 9999 },
  buf_options = { filetype = ft_noice },
}

local miniView = {
  zindex = 10,
  win_options = {
    winblend = 30,
  },
}

-- local render = require("notify.render._entry")

local notifyView = {
  -- backend = { "snacks", "notify" },
  backend = "notify",
  fallback = "mini",
  format = "notify",
  replace = false,
  merge = false,
  on_notify = function(info)
    require("configs.noice.logfile")(info.level, info.content)
  end,
}

local cmdlinePopupView = {
  backend = "popup",
  position = { row = 10, col = "50%" },
  size = { width = 60, height = "auto" },
  win_options = {
    scrolloff = 9999,
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
local splitView = {
  backend = "split",
  enter = false,
  relative = "editor",
  position = "bottom",
  size = "20%",
  close = {
    keys = { "q" },
  },
  buf_options = {
    filetype = ft_noice,
    syntax = "noice.log.lua",
  },
  win_options = {
    winhighlight = { Normal = "NoiceSplit", FloatBorder = "NoiceSplitBorder" },
    scrolloff = 9999,
    wrap = true,
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

-- cmdline_popup = { position = { row = 5, col = "50%", }, size = { width = 60, height = "auto", }, },
-- popupmenu = { relative = "editor", position = { row = 8, col = "50%", }, size = { width = 60, height = 10, },
--              border = { style = "rounded", padding = { 0, 1 }, },
--              win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" }, }, },

-- stylua: ignore
local config = {
  mini           = miniView,
  popup          = popupView,
  notify         = notifyView,
  cmdline_popup  = cmdlinePopupView,
  cmdline_output = cmdlineOutputPopupView,
  split          = splitView
  -- vsplit
  -- cmdline
  -- messages
  -- confirm
  -- hover
  -- popupmenu
}

-- stylua: ignore
return {
  config              = config,
  historyView         = historyView,
  errorView           = errorView,
  errorViewFormat     = errorViewFormat,
  telescopeViewFormat = telescopeViewFormat,
}
