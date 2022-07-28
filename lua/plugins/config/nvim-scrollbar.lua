require("scrollbar").setup({
  show = true,
  handle = {
    text = " ",
    color = "#223355",
    hide_if_all_visible = true, -- Hides handle if all lines are visible
  },
  marks = {
    Search = { text = { "-", "=" }, priority = 0, color = "orange" },
    Error = { text = { "-", "=" }, priority = 1, color = "#770000" },
    Warn = { text = { "-", "=" }, priority = 2, color = "#774400" },
    Info = { text = { "-", "=" }, priority = 3, color = "#004499" },
    Hint = { text = { "-", "=" }, priority = 4, color = "green" },
    Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
  },
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
  },
  excluded_buftypes = {
    "terminal"
  },
  autocmd = {
    render = {
      "BufWinEnter",
      "TabEnter",
      "TermEnter",
      "WinEnter",
      "CmdwinLeave",
      "TextChanged",
      "VimResized",
      "WinScrolled",
    },
  },
  handlers = {
    diagnostic = true,
    search = true, -- Requires hlslens to be loaded
  },
})

-- run after loading hlslens
-- require("scrollbar.handlers.search").setup()

-- example config with importing colors
-- local colors = require("tokyonight.colors").setup()

-- require("scrollbar").setup({
--     handle = {
--         color = colors.bg_highlight,
--     },
--     marks = {
--         Search = { color = colors.orange },
--         Error = { color = colors.error },
--         Warn = { color = colors.warning },
--         Info = { color = colors.info },
--         Hint = { color = colors.hint },
--         Misc = { color = colors.purple },
--     }
-- })
