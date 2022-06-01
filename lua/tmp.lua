-- local ok, cmp = pcall(require, "plugins.config.nvim-cmp")

local root = require("project_nvim.project").get_project_root()
vim.notify(root, "info")
