local list = require('devdocs.list')

local installed = list.get_installed_registry()
vim.dbglog(installed)
