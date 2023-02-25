-- local dump = require("globals.dump")
-- local obj = vim.lsp.get_active_clients()
-- vim.dbglog(dump(obj))

require("material")
vim.g.material_style = "deep ocean"
-- vim.g.material_style = "oceanic"
-- vim.g.material_style = "lighter"
-- vim.g.material_style = "darker"
-- vim.g.material_style = "palenight"
vim.cmd("colorscheme material")
