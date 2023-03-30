-- local options = require('utils.options')

local project_config = {
  show_hidden = true,
  ignore_lsp = { "null-ls" },
}

require("project_nvim").setup(project_config)
