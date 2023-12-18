local defaults = require('tracker.defaults')

-- stylua: ignore
local sources_map = {
  -- augroups  =  augroups,
  -- aucommands = aucommands,
  -- events, functions, variables, options, keymaps, commands, ext_leaked, timers , packages, scriptnames
  highlights = require('tracker.sources.highlights'),
}

local load_sources = function(sources_list, opts, only_metrics)
  opts.only_metrics = only_metrics
  for name, cfg in pairs(sources_list) do
    opts = vim.tbl_extend('keep', opts, cfg)
    local source = source_map[name]
    if type(source.init) == 'function' then
      source.init(source, opts)
    else
      defaults.init(source, opts)
    end
  end
end

local setup = function(_opts)
  -- local opts = config.setup(_opts)
  local opts = _opts or {}

  -- load_sources(opts.metrics, opts, true)
  load_sources(opts.list, opts)
  -- vim.keymap.set("n", lhs, commands[key], { noremap = true })
end

return { setup = setup }
