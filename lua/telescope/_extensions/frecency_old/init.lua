local has_telescope, telescope = pcall(require, "telescope")

-- TODO: make sure scandir unindexed have opts.ignore_patterns applied
-- TODO: make filters handle mulitple directories

if not has_telescope then
  error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local frecency = require("telescope._extensions.frecency.frecency")
local config = require("telescope._extensions.frecency.config")
local util = require("telescope._extensions.frecency.util")

local function checkhealth()
  local has_sql, _ = pcall(require, "sqlite")
  if has_sql then
    vim.health.report_ok("sql.nvim installed.")
    -- return "MOOP"
  else
    vim.health.report_error("Need sql.nvim to be installed.")
  end
  if pcall(require, "nvim-web-devicons") then
    vim.health.report_ok("nvim-web-devicons installed.")
  else
    vim.health.report_info("nvim-web-devicons is not installed.")
  end
end

return telescope.register_extension({
  setup = config.setup,
  exports = {
    frecency = frecency,
    get_workspace_tags = util.get_workspace_tags,
    validate_db = function(...)
      require("telescope._extensions.frecency.db_client").validate(...)
    end,
  },
  health = checkhealth,
})
