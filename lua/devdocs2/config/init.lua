local M = {}

local path = require("plenary.path")
local defaults = require("devdocs2.config.defaults")

---@class nvim_devdocs.Config
M.options = {}

M.setup = function(new_config)
  M.options = vim.tbl_deep_extend("force", defaults, new_config or {})

  DATA_DIR = path:new(M.options.dir_path)
  DOCS_DIR = DATA_DIR:joinpath("docs")
  INDEX_PATH = DATA_DIR:joinpath("index.json")
  LOCK_PATH = DATA_DIR:joinpath("docs-lock.json")
  REGISTRY_PATH = DATA_DIR:joinpath("registry.json")

  return defaults
end

M.get_float_options = function()
  local ui = vim.api.nvim_list_uis()[1]
  local row = (ui.height - M.options.float_win.height) * 0.5
  local col = (ui.width - M.options.float_win.width) * 0.5
  local float_opts = M.options.float_win

  float_opts.row = M.options.float_win.row or row
  float_opts.col = M.options.float_win.col or col
  float_opts.zindex = 10

  return float_opts
end

return M
