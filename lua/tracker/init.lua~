local exports = {}
local config = require("tracker.config")
local metrics = require("tracker.metrics")

function exports.setup(_opts)
  local opts = config.setup(_opts)
  for name, cfg in pairs(opts.metrics) do
    metrics.init(name, cfg)
  end
  metrics.start()
  -- vim.keymap.set("n", lhs, commands[key], { noremap = true })
end

return exports
