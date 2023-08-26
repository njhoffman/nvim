-- https://raw.githubusercontent.com/rcarriga/nvim-notify/master/README.md
-- increase fade in frequency

local on_open = require('configs.nvim-notify.on_open')
local render = require('configs.nvim-notify.render')

local cfg = {
  level = vim.log.levels.DEBUG,
  -- level = 0,
  fps = 30,
  render = render,
  stages = 'fade_in_slide_out',
  -- background_colour = "FloatShadow",
  background_colour = '#000000',
  -- Default timeout for notifications
  timeout = 5000,
  minimum_width = 5,
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
  on_open = on_open,
}

require('notify').setup(cfg)

-- You can also use plenary's async library to avoid using callbacks:
-- local async = require("plenary.async")
-- local notify = require("notify").async
-- async.run(
--   function()
--     notify("Let's wait for this to close").close()
--     notify("It closed!")
--   end
-- )
