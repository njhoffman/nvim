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
local Minimalist = require("vimade.recipe.minimalist").Minimalist({
  animate = false,
  low_visibility_fadelevel = 0.3,
  -- exclude_names ={'LineNr', 'LineNrBelow', 'LineNrAbove', 'EndOfBuffer'
  -- low_visibility_names = {'WinSeparator'},
  -- no_visibility_names = {'LineNr', 'LineNrBelow', 'LineNrAbove', 'WinSeparator', 'EndOfBuffer'},
  condition = function(style, state)
    -- vim.dbglog("condition")
    -- vim.dbglog(style.win)
    return true
    -- return style.win.nc == true or style._animating == true
  end,
})

local default_fadelevel = function()
  return 0.4
end

local get_active_info = function(curr)
  curr = vim.tbl_deep_extend("force", curr, {
    buf_opts = {},
    buf_info = vim.fn.getbufinfo(curr.bufnr)[1],
    win_info = vim.fn.getwininfo(curr.winid)[1],
    win_cfg = vim.api.nvim_win_get_config(curr.winid),
  })
  for name, val in pairs(vim.api.nvim_get_all_options_info()) do
    if val.scope == "buf" then
      curr.buf_opts[name] = vim.api.nvim_get_option_value(name, { buf = curr.bufnr })
    end
  end
  curr.wintype = vim.fn.win_gettype(curr.win_info.winnr)
  return curr
end
-- local global_vars = "vimade_init", "vimade_timer", "vimade_loaded", "vimade_paused",
-- "vimade_running", "vimade_error_count", "vimade_fade_active", "vimade_python_setup",
-- local example_info = {
--   [true] = 6, CHANGED = 2, ERROR = 1, HLCHECK = 8, READY = 0, RECALCULATE = 4,
--   blocklist = {
--     default = {
--       buf_opts = { buftype = { "prompt", "terminal" } },
--       win_config = { relative = true },
--       win_type = true
--    } },
--   callbacks = {},
--   current = { bufnr = 1, tabnr = 1, winid = 1000 },
--   fademinimap = true,
--   groupdiff = true,
--   groupscrollbind = false,
--   is_dark = true,
--   link = { default = {} },
--   nc_buffers = true,
--   nc_windows = false,
--   ncmode = "buffers",
--   nohlcheck = true,
--   normalid = 77,
--   normalncid = 59,
--   now = 50723558,
--   renderer = "lua",
--   termguicolors = true,
--   tick_id = 215,
--   tick_state = 0,
--   vimade_fade_active = false,
--   vimade_lua = {
--     fadelevel = <function 1>,
--     style = { { attach = <function 2>, value = <function 3> }, {
--       attach = <function 4> }, { attach = <function 5> }, { attach = <function 6>
-- } } } }

local M = {}

M.debug_flag = false
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

-- M.vimade_fade_buffers = function(opts)
--   local bufnrs = type(opts.buf) == "number" and { opts.buf }
--     or type(opts.buf) == "table" and opts.buf
--     or vim.api.nvim_list_bufs()
--   local match = opts.match or { win_config = "relative" }

-- end
-- M.vimade_unfade_buffers = function(opts) end

-- M.vimade_fade_windows = function(opts) end
-- M.vimade_unfade_windows = function(opts) end
M.vimade_fade_global = function(fade_level)
  fade_level = fade_level or 0.4
  vim.api.nvim_set_var("vimade_fade_level", fade_level)
end

M.vimade_unfade_global = function()
  vim.api.nvim_del_var("vimade_fade_level")
end

M.fadelevel = function(fadelevel_cfg)
  return function(style, _) --style, state
    local fadelevel = 1
    if style.win.is_active_win == false then
      local curr = get_active_info(require("vimade.state.globals").current)
      -- if style.win.buf_opts.filetype == "neo-tree" then
      fadelevel = fadelevel_cfg.split or default_fadelevel()
      if curr.wintype == "popup" then
        fadelevel = fadelevel_cfg.popup or default_fadelevel()
      end
    end
    -- vim.dbglog('fade: ' .. fadelevel, curr.buf_info.name)
    return fadelevel
  end
end

M.style = Minimalist.style

return M
