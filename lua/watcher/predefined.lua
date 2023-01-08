local generate = require('watcher.generate')

local predefined = {
  env_vars = {
    title = 'Environment Vars',
    get_data = generate.envlist,
  },
  -- buffer_vars = {
  --   title = 'Buffer Vars',
  --   get_data = generate.variables_buf
  -- },
  -- window_vars = {
  --   title = 'Window Vars',
  --   get_data = generate.variables_win
  -- },
  -- global_vars = {
  --   title = 'Global Vars',
  --   get_data = generate.variables_global
  -- },
  -- buffer_opts = {
  --   title = 'Buffer Opts',
  --   get_data = generate.opts_buf
  -- },
  -- window_opts = {
  --   title = 'Window Opts',
  --   get_data = generate.opts_win
  -- },
  -- global_opts = {
  --   title = 'Global Opts',
  --   get_data = generate.opts_global
  -- },
  -- buffer_keys = {
  --   title = 'Buffer Keys',
  --   get_data = generate.keys_buf
  -- },
  -- window_keys = {
  --   title = 'Window Keys',
  --   get_data = generate.keys_win
  -- },
  -- global_keys = {
  --   title = 'Global Keys',
  --   get_data = generate.keys_global
  -- }

}
return predefined
