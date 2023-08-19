local values = {}

local function set_config_state(opt_name, value, default)
  local state = require("telescope._extensions.frecency.state")
  state[opt_name] = value == nil and default or value
end

local function setup(opts)
  values = vim.tbl_deep_extend("force", values, opts)
  set_config_state("db_root", values.db_root, nil)
  set_config_state("show_scores", values.show_scores, false)
  set_config_state("show_unindexed", values.show_unindexed, true)
  set_config_state("show_filter_column", values.show_filter_column, true)
  set_config_state("user_workspaces", values.workspaces, {})
  set_config_state("disable_devicons", values.disable_devicons, false)
  set_config_state("default_workspace", values.default_workspace, nil)
  return values
end

return { setup = setup, values = values }
