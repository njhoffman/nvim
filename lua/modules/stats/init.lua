local stats_map = require('modules.stats.commands-stats')
-- local watch_map = require('modules.stats.commands-watch')
-- local track_map = require('modules.stats.commands-track')

local stats = require('modules.stats.commands')
vim.api.nvim_create_user_command('Stats', stats.command, {
  desc = 'Internal stats output and monitoring',
  complete = stats.completion(stats_map),
  nargs = '*',
})

-- local track = require('modules.stats.track') -- StatsTrack, DiffTrack, TrackDiff
-- vim.api.nvim_create_user_command('StatsTrack', track.command, {
--   desc = 'Internal stats monitoring and difference tracking',
--   complete = track.completion(track_map),
--   nargs = '*',
-- })
--

-- local watch = require('modules.stats.watch')
-- vim.api.nvim_create_user_command('StatsWatch', watch.command, {
--   desc = 'Internal stats continuous monitoring',
--   complete = watch.completion(watch_map),
--   nargs = '*',
-- })
--

-- local stats_select = function() end
-- vim.api.nvim_create_user_command('StatsSelect', stats_select, {
--   desc = 'Internal stats monitoring and difference tracking',
-- })
--
