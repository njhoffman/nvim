local stats_map = require('stats.commands-stats')
local watch_map = require('stats.commands-watch')
local track_map = require('stats.commands-track')

local stats = require('stats.commands')
vim.api.nvim_create_user_command('Stats', stats.command, {
  desc = 'Internal stats output and monitoring',
  complete = stats.completion(stats_map),
  nargs = '*',
})

local watch = require('stats.watch')
vim.api.nvim_create_user_command('StatsWatch', watch.command, {
  desc = 'Internal stats continuous monitoring',
  complete = watch.completion(watch_map),
  nargs = '*',
})

local track = require('stats.track')
vim.api.nvim_create_user_command('StatsTrack', track.command, {
  desc = 'Internal stats monitoring and difference tracking',
  complete = track.completion(track_map),
  nargs = '*',
})

local stats_select = function() end
vim.api.nvim_create_user_command('StatsSelect', stats_select, {
  desc = 'Internal stats monitoring and difference tracking',
})
