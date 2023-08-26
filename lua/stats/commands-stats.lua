-- local view_cmds = { 'popup', 'notify', 'logfile', 'print', 'buffer', 'split' }
local command_map = {
  -- 'aucommands', 'highlights', 'vars'
  files = {
    runtime = { 'logfile', 'buffer', 'split' },
    scriptnames = { 'logfile', 'buffer', 'split' },
    size_nvim = { 'notify', 'logfile' },
    size_plugins = { 'notify', 'logfile' },
  },
  keys = {
    table = {
      neovim = { 'logfile', 'buffer', 'split' },
      neovim_todo = { 'logfile', 'buffer', 'split' },
      mapper = { 'logfile', 'buffer', 'split' },
      mapper_todo = { 'logfile', 'buffer', 'split' },
      wk_conflicts = { 'logfile', 'buffer', 'split' },
      wk_ok = { 'logfile', 'buffer', 'split' },
      wk_todo = { 'logfile', 'buffer', 'split' },
    },
    tree = {
      neovim = { 'logfile', 'buffer', 'split' },
      neovim_todo = { 'logfile', 'buffer', 'split' },
      mapper = { 'logfile', 'buffer', 'split' },
      mapper_todo = { 'logfile', 'buffer', 'split' },
      wk_conflicts = { 'logfile', 'buffer', 'split' },
      wk_ok = { 'logfile', 'buffer', 'split' },
      wk_todo = { 'logfile', 'buffer', 'split' },
    },
    list = {
      neovim = { 'logfile', 'buffer', 'split' },
      neovim_todo = { 'logfile', 'buffer', 'split' },
      mapper = { 'logfile', 'buffer', 'split' },
      mapper_todo = { 'logfile', 'buffer', 'split' },
      wk_conflicts = { 'logfile', 'buffer', 'split' },
      wk_ok = { 'logfile', 'buffer', 'split' },
      wk_todo = { 'logfile', 'buffer', 'split' },
    },
    dump = {
      neovim = { 'logfile', 'buffer', 'split' },
      neovim_todo = { 'logfile', 'buffer', 'split' },
      mapper = { 'logfile', 'buffer', 'split' },
      mapper_todo = { 'logfile', 'buffer', 'split' },
      wk_conflicts = { 'logfile', 'buffer', 'split' },
      wk_ok = { 'logfile', 'buffer', 'split' },
      wk_todo = { 'logfile', 'buffer', 'split' },
    },
  },
  lazy = {
    plugins = {
      start = {
        list = { 'logfile', 'buffer', 'split' },
        dump = { 'logfile', 'buffer', 'split' },
      },
      lazy = {
        list = { 'logfile', 'buffer', 'split' },
        dump = { 'logfile', 'buffer', 'split' },
      },
      dependency = {
        list = { 'logfile', 'buffer', 'split' },
        dump = { 'logfile', 'buffer', 'split' },
      },
    },
    configs = {
      all = { 'logfile', 'buffer', 'split' },
      dependency = { 'logfile', 'buffer', 'split' },
      checked = { 'logfile', 'buffer', 'split' },
      stray = { 'logfile', 'buffer', 'split' },
      exist = { 'logfile', 'buffer', 'split' },
      missing = { 'logfile', 'buffer', 'split' },
    },
  },
}

return command_map
