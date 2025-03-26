local logger = require("logger").init("modeman")
  or { trace = print, debug = print, info = print, warn = print, error = print }

local get_logger = function(level)
  return function(...)
    if level == "trace" then
      logger:trace(...)
    elseif level == "debug" then
      logger:debug(...)
    elseif level == "info" then
      logger:info(...)
    elseif level == "warn" then
      logger:warn(...)
    elseif level == "error" then
      logger:error(...)
    end
  end
end

local log_opfunc = function(opfunc, op_def)
  local state = require("configs.reactive.state")
  if op_def then
    local op_key = op_def[1] and op_def[1][1]
    local op_count = state.opfuncs.matched[op_key] or 0
    logger:debug("OpfuncFound  " .. op_key .. ": " .. op_count)
  else
    -- local op_count = state.opfuncs.missed[op_key] or 0
    local op_count = 0
    logger:info("OpfuncMiss   " .. opfunc .. ": " .. op_count)
  end
end

-- local timing = { total = vim.fn.reltime(_, _) }
local timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= "string") then
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= "string" then
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    logger:debug(
      opts.prompt_title .. ":" .. timing.average .. " /" .. timing.total .. " (" .. num .. ") "
    )
    -- opts.finder_type, '\n', timing.command, timing.first_entry,
  end
end

local log_mode = function(curr)
  local has_ctrl = function(str)
    return str:find("") or str:find("")
  end
  local termcode = function(str)
    return vim.api.nvim_replace_termcodes(str, true, false, true)
  end

  local from, to = unpack({ termcode(curr.from or ""), termcode(curr.mode or "") })

  local op = curr.op and #curr.op > 0 and ("'" .. tostring(curr.op) .. "'") or ""
  local opkeys = type(curr.opkeys) == "table" and curr.opkeys[1] or curr.opkeys or "?"
  local opkey = curr.opfunc and #curr.opfunc > 0 and ("[" .. tostring(opkeys) .. "]") or ""
  local opdesc = curr.opfunc
      and #curr.opfunc > 0
      and ("`" .. tostring(curr.opdesc or curr.opfunc) .. "`")
    or curr.typed and #curr.typed > 0 and (" '" .. curr.typed .. "'")
    or ""

  -- variable widths depending on control characters
  local w = { has_ctrl(from) and 3 or 4, has_ctrl(to) and 3 or 4, 4, 6 }

  local msg = string.format(
    "%" .. w[1] .. "s:%-" .. w[2] .. "s %" .. w[3] .. "s %" .. w[4] .. "s %s",
    from,
    to,
    op,
    opkey,
    opdesc
  )
  logger:debug(msg)
end

return {
  timing = timing,
  trace = get_logger("trace"),
  debug = get_logger("debug"),
  info = get_logger("info"),
  warn = get_logger("warn"),
  error = get_logger("error"),
  log_opfunc = log_opfunc,
  log_mode = log_mode,
  -- log_virtual = log_virtual,
}
