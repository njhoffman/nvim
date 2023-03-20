local defaults = require("tracker.defaults")

local function assign_defaults(user_cfg, type)
  local cfg = nil
  if type == "provider" then
    cfg = vim.tbl_deep_extend("keep", user_cfg or {}, defaults.provider)
  elseif type == "provider_state" then
    cfg = vim.tbl_deep_extend("keep", user_cfg or {}, defaults.provider_state)
  else
    cfg = vim.tbl_deep_extend("keep", user_cfg or {}, defaults.config)
    cfg.outputs = defaults.assign_config_outputs(user_cfg.outputs or {})
    cfg.metrics = defaults.assign_config_metrics(user_cfg.metrics or {})
  end
  return cfg
end

local config = {}

local function validate_config(_cfg)
  config = _cfg
end

local function setup(opts)
  local cfg = assign_defaults(opts or {}, "config")
  validate_config(cfg)
  return config
end

return {
  assign_defaults = assign_defaults,
  opts = config,
  setup = setup,
}
