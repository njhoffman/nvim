local require = require("noice.util.lazy")
local Config = require("noice.config")

-- {
--   -- default format
--   default = { "{level} ", "{title} ", "{message}" },
--   -- default format for vim.notify views
--   notify = { "{message}" },
--   -- default format for the history
--   details = { "{level} ", "{date} ", "{event}",
--     { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
--     " ", "{title} ", "{cmdline} ", "{message}",
--   },
--   telescope = ..., -- formatter used to display telescope results
--   telescope_preview = ..., -- formatter used to preview telescope results
--   lsp_progress = ..., -- formatter used by lsp progress
--   lsp_progress_done = ..., -- formatter used by lsp progress
-- }

-- -- redirect some function
-- require("noice").redirect(function()
--   print("test")
-- end)
--
-- vim.api.nvim_create_autocmd('BufEnter', {})

-- notify           notify     nvim-notify with level=nil, replace=false,
--                             merge=false
-- split            split      horizontal split
-- vsplit           split      vertical split
-- popup            popup      simple popup
-- mini             mini       minimal view, by default bottom right, right-aligned
-- cmdline          popup      bottom line, similar to the classic cmdline
-- cmdline_popup    popup      fancy cmdline popup, with different styles according
-- cmdline_output   split      split used by config.presets.cmdline_output_to_split
-- messages         split      split used for :messages
-- confirm          popup      popup used for confirm events
-- hover            popup      popup used for lsp signature help and hover
-- popupmenu        nui.menu   special view with the options used to render the
local cmdlineView = {
  reverse = false,
  align = "message-left",
  timeout = 5000,
  position = { row = -2, col = -2 },

  size = {
    max_height = math.ceil(0.8 * vim.o.lines),
    max_width = math.ceil(0.5 * vim.o.columns),
    min_width = 30,
    width = "auto",
    height = "auto",
  },
  border = {
    text = { top = "", top_align = "left", bottom = "" },
    style = {
      { "▐", "NoiceMiniBorder" },
      { " ", "NoiceMini" },
      { " ", "NoiceMini" },
      { " ", "NoiceMini" },
      { " ", "NoiceMini" },
      { " ", "NoiceMini" },
      { "▐", "NoiceMiniBorder" },
      { "▐", "NoiceMiniBorder" },
    },
    padding = { top = 0, bottom = 0, left = 1, right = 0 },
  },
  win_options = { winblend = 0 },
}

local miniView = {
  backend = "mini",
  relative = "editor",
  align = "message-left",
  timeout = 100,
  reverse = true,
  position = { row = -2, col = 0 },
  size = "auto",
  zindex = 60,
  border = {
    style = {
      { "╭", "NoiceCmdlineBorder" },
      { "─", "NoiceCmdlineBorder" },
      { "╮", "NoiceCmdlineBorder" },
      { "│", "NoiceCmdlineBorder" },
      { "╯", "NoiceCmdlineBorder" },
      { "─", "NoiceCmdlineBorder" },
      { "╰", "NoiceCmdlineBorder" },
      { "│", "NoiceCmdlineBorder" },
    },
    padding = { left = 1, right = 1 },
  },

  win_options = {
    winblend = 0,
    winhighlight = { Normal = "NoiceCmdlineNormal", IncSearch = "", Search = "" },
  },
}

local miniViewDefault = {
  backend = "mini",
  relative = "editor",
  align = "message-right",
  timeout = 2000,
  reverse = true,
  focusable = false,
  position = {
    row = -1,
    col = "100%",
    -- col = 0,
  },
  size = "auto",
  border = {
    style = "none",
  },
  zindex = 60,
  win_options = {
    winbar = "",
    foldenable = false,
    winblend = 30,
    winhighlight = {
      Normal = "NoiceMini",
      IncSearch = "",
      CurSearch = "",
      Search = "",
    },
  },
}

return {
  miniView = miniView,
  cmdlineView = cmdlineView,
}
