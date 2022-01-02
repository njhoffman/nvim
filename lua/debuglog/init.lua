local log = require('debuglog.log')

local config = {
  use_console = false,
  highlights = true,
  plugin = "debug",
  use_file = true,
}

local unpack = unpack or table.unpack

local function is_module_available(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == "function" then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

local wrap = function(str, limit, indent, indent1)
  if type(str) ~= "string" then return str end
  indent = indent or ""
  indent1 = indent1 or indent
  limit = limit or 30
  local here = 1-#indent1
  return indent1..str:gsub("(%s+)()(%S+)()",
    function(sp, st, word, fi)
      if fi-here > limit then
        here = st - #indent
        return "\n"..indent..word
      end
    end)
end


local round = function(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
end

local make_string = function(...)
  local t = {}
  for i = 1, select("#", ...) do
    local x = select(i, ...)

    if type(x) == "number" and config.float_precision then
      x = tostring(round(x, config.float_precision))
    elseif type(x) == "table" then
      x = vim.inspect(x)
    else
      x = tostring(x)
    end

    t[#t + 1] = x
  end
  return table.concat(t, " ")
end

-- log.info("HEY", _G._get_stats_keymaps())
-- local test_message  = vim.api.nvim_get_all_options_info();
-- local test_message = "The debug library also allows us to access the upvalues that a Lua function uses, with getupvalue. Unlike local variables, however, a function has its upvalues even when it is not active (this is what closures are about, after all). Therefore, the first argument for getupvalue is not a stack level, but a function (a closure, more precisely). The second argument is the upvalue index. Lua numbers upvalues in the order they are first referred in a function, but this order is not relevant, because a function cannot have two upvalues with the same name."


local M = {}

M.log = function(...)
  local msg = ... or {}
  local cols = math.floor(vim.opt.columns:get() / 3)
  local currwin = vim.api.nvim_get_current_win()
  local currwidth = vim.api.nvim_win_get_width(currwin)
  local currheight = vim.api.nvim_win_get_height(currwin)

  log:new(config)
  log.info(msg)

  local notify = require("plugins.config.nvim-notify")
  -- notify.setup(notify_config)

  if (type(notify) == 'table') then

    local notify_msg = make_string(msg)
	  local args = {}
	  args.timeout = 5000
	  args.render = 'minimal'

	  local lines = vim.split(notify_msg, "\n")
	  if (#lines >= currheight) then
	    notify_msg = table.concat(vim.list_slice(lines, 0, currheight - 3), "\n")
	    notify_msg = notify_msg .. "\n..." .. #lines .. " more lines not shown"
	  end

	  notify.dismiss()
	  notify(notify_msg, 'inspect', args)
  end
end

M.buf = function(...)
  local msg = ... or {}
  local bufnr = vim.api.nvim_create_buf(true, true)
  -- vim.api.nvim_buf_set_option(bufnr, 'filetype', 'lua')
  local source_ft = vim.bo.filetype
  vim.api.nvim_set_current_buf(bufnr)
  vim.bo.filetype = source_ft

  msg = make_string(msg)
  local lines = vim.split(msg, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end


-- M.buf('hello')
-- M.log(vim.api.nvim_get_all_options_info())
-- M.buf(_G._get_stats_keymaps())
vim.cmd([[
  highlight! NotifyINSPECTBorder guifg=#2A70fF
  highlight! NotifyINSPECTIcon guifg=#67b0f7
  highlight! NotifyINSPECTTitle  guifg=#2760f7
  highlight! link NotifyINSPECTBody Normal
]])


vim.dbg = M.log
vim.dbgbuf = M.buf

vim.cmd([[
  function DebugLog(msg)
    call luaeval('vim.dbg(_A[1])', [a:msg])
  endfunction
  command -nargs=? Log call DebugLog('<args>')
]])

vim.cmd([[
  highlight! NotifyINSPECTBorder guifg=#2A70fF
  highlight! NotifyINSPECTIcon guifg=#67b0f7
  highlight! NotifyINSPECTTitle  guifg=#2760f7
  highlight! link NotifyINSPECTBody Normal
]])


return M

-- local api = vim.api
-- local namespace = api.nvim_create_namespace("nvim-notify")
-- return function(bufnr, notif, highlights)
--   api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

--   api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--     hl_group = highlights.icon,
--     end_line = #notif.message - 1,
--     end_col = #notif.message[#notif.message],
--   })
-- -- local notifyRender = require("otify.render")
-- -- return function(bufnr, notif, highlights)
-- --   print("RENDER", vim.inspect(notifyRender['default']), renderType)
-- --   -- local render = 'default' -- minimal
-- --   return notifyRender[renderType]
