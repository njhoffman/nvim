local opt = require("utils.options")
opt.set('notify_level_log', 'warn')
opt.set_local('indentsize', 2, 0)
vim.dbg(opt.get_state())
