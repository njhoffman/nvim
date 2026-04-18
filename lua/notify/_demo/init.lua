-- local notify = vim.notify

local get_config = function(user_variants, user_opts)
  local defaults = {
    opts = {
      delay = 200,
      notify_timeout = 3000,
      group_timeout = 4000,
      levels = { "trace", "debug", "info", "warn", "error" },
      -- for the default 'stages', should default to user configured value
      stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
      -- by default this should get the names of all the renderers available
      renders = {
        "minimal",
        "simple",
        "compact",
        "default",
        "wrapped-minimal",
        "wrapped-compact",
        "wrapped-default",
      },
    },
    -- different input variants to test dynamic ui rendering
    variants = require("notify.demo.variants"),
  }
  return {
    variants = user_variants or defaults.variants,
    opts = vim.tbl_extend("force", defaults.opts, user_opts or {}),
  }
end

local setup_demo = function()
  -- local demo_cfg = get_config(user_variants, user_opts)
  -- this function should open up a scratch buffer with the default options that can be modified and passed as
  -- user_variants, user_options here
  local demo_cfg = get_config()
  require("notify.demo.demo").run(demo_cfg)
end

return { setup = setup_demo }
