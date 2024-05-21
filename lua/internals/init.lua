-- nvim -u NONE -c 'set nowrap' large_file.json
-- https://github.com/norcalli/profiler.nvim
-- :set &verbosefile="/tmp/logfile.log" and :set verbose=9 and :set verbosefile = ""
-- :profile start profile.log
-- :profile func *
-- :profile file *
-- :profile stop/pause

local modules = require('internals.modules')
local commands = require('internals.commands')

local setup_keymaps = function(_)
  -- vim.keymap.set('n', '<f12>', ':ProfileStart<CR>')
end

-- setup for begin profile startup times
local init = function(opts)
  opts = opts or {}
  for _, mod in pairs(modules.profilers) do
    if mod and type(mod.init) == 'function' then
      mod.init(opts)
    end
  end
end

-- setup for finish startup times and profiling on-demand
local setup = function(opts)
  opts = opts or {}
  commands.update(opts)
  setup_keymaps(opts)
end

return { init = init, setup = setup }
