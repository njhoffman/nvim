local default_config = require('debuglog.config-default')

local config = {
  float_precision = 0.01,
  use_console = false,
  highlights = true,
  use_file = true,
}

config.outfile = {
  string.format('%s/%s.log', vim.api.nvim_call_function('stdpath', { 'data' }), 'inspect'),
  -- string.format('%s/%s.log', vim.api.nvim_call_function('stdpath', { 'data' }), 'nvim'),
}
config.start_time = os.clock()
config = vim.tbl_deep_extend('force', default_config, config)
return config
