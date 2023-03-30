local out = require("tracker.output")
local diff = require("tracker.diff")

local defaults = {}

defaults.provider = {
  label = "items",
  id_fields = { "key" },
  desc_fields = {},
  output_diff = out.output_diff,
  output_group = out.output_group,
  parse_data = diff.parse_data,
}

defaults.provider_state = {
  time_get = nil,
  time_diff = nil,
  prev_items = {},
}

defaults.config = {
  outputs = {
    enabled = true,
    group = false,
    notify = {
      level = "debug",
    },
    logfile = {
      file = "filename",
    },
    panel = {
      float = true,
      max = { x = 0, y = 0, w = 0, h = 0 },
      pos = { x = 0, y = 0, w = 0, h = 0 },
    },
    -- func = function() end
  },
  providers = {},
  metrics = {
    interval = 3,
    enabled = true,
    list = {
      augroups = { provider = "tracker.metrics.augroups" },
      aucommands = { provider = "tracker.metrics.aucommands", group = true },
      -- commands = { provider = "tracker.metrics.commands", group = true },
      -- functions = { provider = "tracker.metrics.functions", group = true },
      -- highlights = { provider = "tracker.metrics.highlights", group = true },
      -- keymaps_g = { provider = "tracker.metrics.keymaps_g" },
      -- variables_g = { provider = "tracker.metrics.variables_g" },
      -- options_g = { provider = "tracker.metrics.options_g" },
      -- changes, jumplist options, syntax_items, variables_b, variables_g,
      -- variables_w, variables_p, options_g, options_w, options_b, keymaps_b,
    },
  },
}

local assign_globals = function(user_cfg, def_cfg, keys)
  local cfg = { global = {}, user = {} }
  for _, key in ipairs(keys) do
    cfg.global[key] = def_cfg[key]
    cfg.user[key] = user_cfg[key]
  end
  return vim.tbl_deep_extend("keep", cfg.user, cfg.global)
end

defaults.assign_config_metrics = function(user_cfg)
  local cfg_met = user_cfg.metrics or {}
  local user_list = cfg_met.list or {}
  local def_met = defaults.config.metrics
  local global = assign_globals(cfg_met, def_met, { "interval", "enabled" })
  local list = vim.tbl_deep_extend("keep", user_list, def_met.list)
  local metrics = {}
  for key, metric_cfg in pairs(list) do
    metrics[key] = vim.tbl_deep_extend("keep", user_list[key] or {}, metric_cfg, global)
  end
  return metrics
end

defaults.assign_config_outputs = function(user_cfg)
  local cfg_outs = user_cfg.outputs or {}
  local def_outs = defaults.config.outputs
  local global = assign_globals(cfg_outs, def_outs, { "group", "enabled" })
  local outputs = {
    notify = vim.tbl_deep_extend("keep", cfg_outs.notify or {}, def_outs.notify, global),
    logfile = vim.tbl_deep_extend("keep", cfg_outs.logfile or {}, def_outs.logfile, global),
    panel = vim.tbl_deep_extend("keep", cfg_outs.panel or {}, def_outs.panel, global),
  }
  return outputs
end

return defaults
