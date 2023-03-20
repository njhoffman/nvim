local sidebar = require("sidebar")

sidebar.setup()
sidebar.toggle()
vim.dbglog(require("sidebar.state"))
