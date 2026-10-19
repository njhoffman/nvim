-- nvim-dap-view configuration
-- Lightweight debugging UI alternative to nvim-dap-ui

require("dap-view").setup({
  winbar = {
    show = true,
    sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
    default_section = "watches",
  },
  windows = {
    size = 12,
    terminal = {
      position = "left",
      hide = {},
    },
  },
})
