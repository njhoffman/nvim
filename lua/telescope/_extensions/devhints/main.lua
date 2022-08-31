-- telescope modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local telescope_config = require("telescope.config").values

local generate = require("telescope._extensions.devhints.generate")
local default_conf_opts = {}

local attach_mappings = function()
  return true
end

local M = {}

M.setup = function(setup_config) end

M.all = function(theme_opts, conf_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})
  local devhints = generate.get_devhints()
  pickers
    .new(theme_opts, {
      prompt_title = "Devhint Languages",
      results_title = "Languages",
      finder = finders.new_table({
        results = devhints,
        -- entry_maker = display.entry_maker,
      }),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

return M
