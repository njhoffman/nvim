local counts = {
  aucommands = 1361,
  augroups = 271,
  changes = 102,
  commands = 684,
  functions = 723,
  highlights = 2908,
  history = 4849,
  memory = '137904',
  menu = 60,
  messages = 0,
  options = 52,
  scriptnames = 221,
  syntax = 1,
  variables = 490,
  virtual = '479916',
}

local utils = require('stats.utils')

local res, hls = utils.align_list(counts)
local notify = require('notify')
notify.notify({ res, hls }, 1, { render = 'extmarks', timeout = 10000, hide_from_history = true })
-- vim.dbglog(res, hls)
