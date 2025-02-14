local utils = require("lsp.utils")

local found = utils.root_pattern("Project.toml", ".git", ".bashrc")(vim.api.nvim_buf_get_name(0))
vim.dbglog(found)
vim.dbglog(found)
-- root, pattern = root_pattern(unpack(step))(fname)
-- local stylua_found = root_pattern({ "stylua.toml", ".stylua.toml" })()
-- vim.dbglog("stylua_found", stylua_found)
