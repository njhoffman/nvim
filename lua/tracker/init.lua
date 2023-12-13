local exports = {}
local highlights = require('tracker.metrics.highlights')
-- local config = require('tracker.config')
-- local aucommands = require('tracker.metrics.aucommands')
-- local augroups = require('tracker.metrics.augroups')

-- stylua: ignore
local provider_map = {
  -- augroups  =  augroups,
  -- aucommands = aucommands,
  highlights = highlights,
}

function exports.setup(_opts)
  -- local opts = config.setup(_opts)
  local opts = _opts or {}
  for name, cfg in pairs(opts.metrics) do
    opts = vim.tbl_extend('keep', opts, cfg)
    local provider = provider_map[name]
    provider_map[name].init(provider, opts)
  end
  -- vim.keymap.set("n", lhs, commands[key], { noremap = true })
end

return exports
