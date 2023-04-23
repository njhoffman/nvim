local nui_layout = require("nui.layout")

local nui_popup = require("nui.popup")

local nui_text = require("nui.text")

local left_popup = nui_popup({
  focusable = false,
  border = {
    style = "rounded",
  },
  win_options = {
    winhighlight = "FloatBorder:NavbuddyFloatBorder",
  },
  buf_options = {
    modifiable = false,
  },
})

local mid_popup = nui_popup({
  enter = true,
  border = {
    style = "rounded",
  },
  win_options = {
    winhighlight = "FloatBorder:NavbuddyFloatBorder",
  },
  buf_options = {
    modifiable = false,
  },
})

local right_popup = nui_popup({
  focusable = false,
  border = {
    style = "rounded",
  },
  win_options = {
    winhighlight = "FloatBorder:NavbuddyFloatBorder",
  },
  buf_options = {
    modifiable = false,
  },
})

local layout = nui_layout(
  {
    relative = "editor",
    size = {
      width = 100,
      height = 10,
    },
    position = "100%",
  },
  nui_layout.Box({
    nui_layout.Box(title_popup, { size = { height = 3, width = "100%" } }),
    nui_layout.Box({
      nui_layout.Box(left_popup, { size = { width = "30%" } }),
      nui_layout.Box(mid_popup, { size = { width = "40%" } }),
      nui_layout.Box(right_popup, { size = { width = "30%" } }),
    }, { dir = "row", size = { height = 8 } }),
  }, { dir = "col" })
)
layout:mount()

vim.dbglog(layout)
