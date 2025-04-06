local default_cfg = {
  winbar = {
    show = true,
    sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
    -- Must be one of the sections declared above
    default_section = "watches",
  },
  windows = {
    height = 12,
    terminal = {
      -- 'left'|'right'|'above'|'below': Terminal position in layout
      position = "left",
      -- List of debug adapters for which the terminal should be ALWAYS hidden
      hide = {},
      -- Hide the terminal when starting a new session
      start_hidden = false,
    },
  },
}
