local fade_in_slide_out_stages = require("notify.stages").fade_in_slide_out

local cols = math.floor(vim.opt.columns:get() / 3 * 2)
fade_in_slide_out_stages[2] = function()
  return {
    opacity = { 100, frequency = 3 },
    col = cols
    -- col = { vim.opt.columns:get() }
  }
end

local config = {
  level = "info",
  timeout = 5000,
  max_width = nil,
  max_height = nil,
  -- stages = BUILTIN_STAGES.FADE_IN_SLIDE_OUT,
  stages = fade_in_slide_out_stages,
  -- render = BUILTIN_RENDERERS.DEFAULT,
  background_colour = "Normal",
  on_open = nil,
  on_close = nil,
  minimum_width = 50,
  fps = 30,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎"
  }
}

local notify = require("notify").setup(config)
vim.notify = notify.notify

vim.notify(
  text,
  "info",
  {
    title = "My Awesome Plugin",
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    end
  }
)
vim.notify("My super important message")
vim.notify("My super important message", "error")
