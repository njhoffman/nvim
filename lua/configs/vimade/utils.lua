-- local Fade = require("vimade.style.fade").Fade
-- local animate = require("vimade.style.value.animate")
-- local direction = require("vimade.style.value.direction")
-- local ease = require("vimade.style.value.ease")
-- local fade2 = Fade({
--   value = animate.Number({
--     start = 1,
--     to = 0.2,
--     direction = direction.IN_OUT,
--     ease = ease.OUT_BOUNCE,
--     duration = 1000,
--     delay = 100,
--   }),
-- })

-- local fade1 = Fade({ value = animate.Number({ start = 1, to = 0.2, }) })
-- local Default = require("vimade.recipe.default").Default({ animate = true })
local Minimalist = require("configs.vimade.minimalist").Minimalist({
  animate = false,
  low_visibility_fadelevel = 0.5,
  -- exclude_names ={'LineNr', 'LineNrBelow', 'LineNrAbove', 'EndOfBuffer'
  -- low_visibility_names = {'WinSeparator'},
  -- no_visibility_names = {'LineNr', 'LineNrBelow', 'LineNrAbove', 'EndOfBuffer'},
  condition = function(style, state)
    -- vim.dbglog("condition")
    -- vim.dbglog(style.win)
    return true
    -- return style.win.nc == true or style._animating == true
  end,
})

local M = {
  debug_flag = false,
}

M.vimade_toggle_debug = function()
  M.debug_flag = not M.debug_flag
  -- print("vimade debug flag is now: " .. tostring(M.debug_flag))
end

M.vimade_info = function()
  print(vim.inspect(require("vimade").getInfo()))
end

M.vimade_reload = function()
  -- TODO: figure out how to detect if it isn't loaded correctly and why it isn't loading
  require("plenary.reload").reload_module("vimade", false)
  -- require("plenary.reload").reload_module("configs.vimade")
  vim.dbglog("reloading vimade")
  require("vimade").setup({ fadelevel = 0.6 })
end

M.vimade_fade_global = function(fade_level)
  fade_level = fade_level or 0.4
  vim.api.nvim_set_var("vimade_fade_level", fade_level)
end

M.vimade_unfade_global = function()
  vim.api.nvim_del_var("vimade_fade_level")
end

M.style = Minimalist.style

return M
