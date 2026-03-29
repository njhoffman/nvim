-- nvim -u NONE -c 'set nowrap' large_file.json
-- https://github.com/norcalli/profiler.nvim
-- require"jit.p".start("10,i1,s,m0,G", "/tmp/output.log")
-- vim.cmd[[au VimLeave * lua require'jit.p'.stop()]]
-- :let &verbosefile = "/tmp/logfile.log"' and ':let &verbose = 9'

--------------------------------------------------------------------------
---jitp-profiler in plenary

require('plenary.profile').start('profile.log')

-- code to be profiled
require('plenary.profile').stop()

start('profile.log', { flame = true })
-- inferno-flamegraph profile.log > flame.svg
local out = io.open('final_refactored_store_offset_benchmark_vim.json.decode.log', 'a')
out:write(
  string.format(
    '%s\n',
    require('plenary.profile').benchmark(1, require('harpoon.mark').store_offset)
  )
)

-- PROFILING
require('plenary.profile').start('profile_10x_vim.json.decode.log', { flame = true })
require('plenary.profile').benchmark(10, require('harpoon.mark').store_offset)
require('plenary.profile').stop()

--------------------------------------------------------------------------
--- profile.nvim

local should_profile = os.getenv('NVIM_PROFILE')

if should_profile then
  require('profile').instrument_autocmds()
  if should_profile:lower():match('^start') then
    require('profile').start('*')
  else
    require('profile').instrument('*')
  end
end

local function toggle_profile()
  local prof = require('profile')
  if prof.is_recording() then
    prof.stop()
    vim.ui.input(
      { prompt = 'Save profile to:', completion = 'file', default = 'profile.json' },
      function(filename)
        if filename then
          prof.export(filename)
          vim.notify(string.format('Wrote %s', filename))
        end
      end
    )
  else
    prof.start('*')
  end
end

require("mapper").map('', '<f1>', toggle_profile)

-- When you want to run Neovim and profile something, start it with NVIM_PROFILE=1 nvim.
-- Then you can tap <F1> to start a profile, and <F1> again to complete the profile and save it to a file.
-- If you instead want to profile the startup of neovim, do NVIM_PROFILE=start nvim and then hit <F1> as soon as neovim loads.
--  I'd recommend taking relatively short profiles, and wherever possible target the specific module(s) you care about.
--  For example, instead of start("*"), it would be much better if I could use start("aerial*") to profile just my aerial nvim plugin.
-- You can view the traces in chrome://tracing or at https://ui.perfetto.dev/
