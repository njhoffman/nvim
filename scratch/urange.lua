local Range = require("u.range")
Range.from_motion("iu")

vim.keymap.set("n", "<F8>", function()
  vim.dbglog("INSIDE")
  vim.dbglog(Range.from_motion("iB"))
end, { noremap = true, nowait = true })

vim.keymap.set("n", "<F9>", function()
  vim.dbglog("INSIDE2")
  vim.dbglog(Range.from_motion("$"))
end, { noremap = true, nowait = true })
