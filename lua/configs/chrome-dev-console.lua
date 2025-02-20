-- :CdcConsole http://example.com
-- :CdcCommand document.body.outerHTML
-- :CdcCommand $("body") // if the page has jQuery

require("chrome-dev-console").setup({
  console_window = {
    height = 20, -- Height of the split window
    placement = "below", -- 'left', 'right', 'above', 'below'
  },
  auto_close_page = true, -- Close webpage when console buffer is deleted
})
