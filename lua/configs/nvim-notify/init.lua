-- https://raw.githubusercontent.com/rcarriga/nvim-notify/master/README.md
-- increase fade in frequency

local events = require('configs.nvim-notify.events')
local render = require('notify.render._entry')

local cfg = {
  level = vim.log.levels.DEBUG,
  fps = 30,
  stages = 'fade_in_slide_out',
  -- background_colour = '#000000',
  timeout = 5000,
  minimum_width = 3,
  max_height = function()
    return math.floor(vim.opt.lines:get() / 5 * 4)
  end,
  max_width = function()
    return math.floor(vim.opt.columns:get() / 5 * 3)
  end,
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
    INSPECT = '',
    RUN = '',
    STATUS = '',
  },
  render = render,
  on_open = events.on_open,
  on_replace = events.on_replace,
}
require('notify').setup(cfg)
-- vim.notify = require('notify').notify

-- You can also use plenary's async library to avoid using callbacks:
-- local async = require("plenary.async")
-- local notify = require("notify").async
-- async.run(
--   function()
--     notify("Let's wait for this to close").close()
--     notify("It closed!")
--   end
-- )
