local M = {}
local logfile = vim.fn.stdpath("cache") .. "/nvim.log"
local log = require("structlog")
local config = require("config")

M.messages = {}

function M.inspect(tbl, depth, n)
  n = n or 2
  depth = depth or 5

  if (depth == 0) then
    print(string.rep(" ", n) .. "...")
    return
  end

  if (n == 0) then
    print(" ")
  end

  for key, value in pairs(tbl) do
    if (key and type(key) == "number" or type(key) == "string") then
      key = string.format('["%s"]', key)

      if (type(value) == "table") then
        if (next(value)) then
          print(string.rep(" ", n) .. key .. " = {")
          H.inspect(value, depth - 1, n + 4)
          print(string.rep(" ", n) .. "},")
        else
          print(string.rep(" ", n) .. key .. " = {},")
        end
      else
        if (type(value) == "string") then
          value = string.format('"%s"', value)
        else
          value = tostring(value)
        end

        print(string.rep(" ", n) .. key .. " = " .. value .. ",")
      end
    end
  end

  if (n == 0) then
    print(" ")
  end
end

-- TODO: make message sink for telescope
-- TODO: parse '\n'
function M.initLogger(name)
  name = name or "root"
  log.configure(
    {
      [name] = {
        sinks = {
          -- log.sinks.Console(log.level.WARN, {
          --     processors = {
          --       log.processors.Namer(),
          --       -- log.processors.Timestamper("%H:%M:%S"),
          --     },
          --     formatter = log.formatters.FormatColorizer(
          --       "[%s] %s: %-30s",
          --     { "level", "logger_name", "msg" },
          --     { level = log.formatters.FormatColorizer.color_level() }
          --     -- "%s [%s] %s: %-30s",
          --       -- { "timestamp", "level", "logger_name", "msg" },
          --     ),
          --   }
          -- ),
          -- log.sinks.NvimNotify(
          --   log.level.WARN,
          --   {
          --     processors = {
          --       log.processors.Namer(),
          --     },
          --     formatter = log.formatters.Format( --
          --       "%s",
          --       { "msg" },
          --       { blacklist = { "level", "logger_name" } }
          --     ),
          --     params_map = { title = "logger_name" },
          --   }),
          log.sinks.File(
            log.level.TRACE,
            logfile,
            {
              processors = {
                log.processors.Namer(),
                log.processors.StackWriter({"line", "file"}, {max_parents = 12, stack_level = 0}),
                log.processors.Timestamper("%H:%M:%S")
              },
              formatter = log.formatters.Format( --
                "%s [%s] %s: %-30s",
                {"timestamp", "level", "logger_name", "msg"},
                {level = log.formatters.FormatColorizer.color_level()}
              )
            }
          )
        }
      }
    }
  )
  return log.get_logger(name)
  -- function logger:inspect(obj) return H.inspect(obj).toString() end
  -- logger:warn("A log message with keyword arguments", { warning = "something happened" })

  -- dap.log, log, lsp.log, nvim.log, packer.nvim.log
end

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

local function wrap(str, limit, indent, indent1)
  if type(str) ~= "string" then
    return str
  end
  indent = indent or ""
  indent1 = indent1 or indent
  limit = limit or 30
  local here = 1 - #indent1
  return indent1 ..
    str:gsub(
      "(%s+)()(%S+)()",
      function(sp, st, word, fi)
        if fi - here > limit then
          here = st - #indent
          return "\n" .. indent .. word
        end
      end
    )
end

local function log_level_number(name)
  name = name or "info"
  local levels = {"trace", "debug", "info", "warn", "error"}
  local level_n = 1
  for i, level in ipairs(levels) do
    if level == name then
      level_n = i
    end
  end
  return level_n
end

local function log_level_name(num)
  local levels = {"trace", "debug", "info", "warn", "error"}
  local level_name = ""
  for i, level in ipairs(levels) do
    if i == num + 1 then
      level_name = level
    end
  end
  return level_name
end

local parse_message = function(message, cols)
  local msg = ""
  if type(message) == "table" then
    for i, line in ipairs(message) do
      if i > 1 then
        msg = msg .. "\n  "
      end
      if type(line) == "table" then
        line = vim.inspect(line)
      elseif type(cols) == "number" then
        line = wrap(line, cols, " ", "")
      end
      msg = msg .. line
    end
  else
    msg = message or "(nil)"
    if type(cols) == "number" then
      msg = wrap(tostring(msg), cols, " ", "")
    end
  end
  return msg
end

local notify_parse_message = function(message, cols)
  --    
  local msg = message
  if type(msg) == "string" and string.find(msg, "Set CWD to") == 1 then
    local path, pattern = string.match(msg, "Set CWD to ([^%s]+) using pattern (.*)")
    local icon = pattern == ".git" and "  " or "  "
    if path == nil then
      path = ""
    end
    path = path:gsub(vim.fn.getenv("HOME"), "~")
    msg = icon .. " " .. path
  else
    msg = parse_message(message, cols)
  end
  return msg
end

local traceback = function()
  -- The main introspective function in the debug library is the debug.getinfo function. Its first parameter may be a function or a stack level. When you call debug.getinfo(foo) for some function foo, you get a table with some data about that function. The table may have the following fields:

  -- source --- Where the function was defined. If the function was defined in a string (through loadstring), source is that string. If the function was defined in a file, source is the file name prefixed with a `@´.
  -- short_src --- A short version of source (up to 60 characters), useful for error messages.
  -- linedefined --- The line of the source where the function was defined.
  -- what --- What this function is. Options are "Lua" if foo is a regular Lua function, "C" if it is a C function, or "main" if it is the main part of a Lua chunk.
  -- name --- A reasonable name for the function.
  -- namewhat --- What the previous field means. This field may be "global", "local", "method", "field", or "" (the empty string). The empty string means that Lua did not find a name for the function.
  -- nups --- Number of upvalues of that function.
  -- func --- The function itself; see later.
  -- When foo is a C function, Lua does not have much data about it. For such functions, only the fields what, name, and namewhat are relevant.

  -- When you call debug.getinfo(n) for some number n, you get data about the function active at that stack level. For instance, if n is 1, you get data about the function doing the call. (When n is 0, you get data about getinfo itself, a C function.) If n is larger than the number of active functions in the stack, debug.getinfo returns nil. When you query an active function, calling debug.getinfo with a number, the result table has an extra field, currentline, with the line where the function is at that moment. Moreover, func has the function that is active at that level.

  -- The field name is tricky. Remember that, because functions are first-class values in Lua, a function may not have a name, or may have several names. Lua tries to find a name for a function by looking for a global variable with that value, or else looking into the code that called the function, to see how it was called. This second option works only when we call getinfo with a number, that is, we get information about a particular invocation.

  -- The getinfo function is not efficient. Lua keeps debug information in a form that does not impair program execution; efficient retrieval is a secondary goal here. To achieve better performance, getinfo has an optional second parameter that selects what information to get. With this parameter, it does not waste time collecting data that the user does not need. The format of this parameter is a string, where each letter selects a group of data, according to the following table:
  -- `n´	selects fields name and namewhat
  -- `f´	selects field func
  -- `S´	selects fields source, short_src, what, and linedefined
  -- `l´	selects field currentline
  -- `u´	selects field nup
  local level = 1
  local out = {}
  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end
    local msg = ""
    if info.what == "C" then -- is a C function?
      msg = level .. ": " .. "C function"
      if type(info.name) == "string" and info.name ~= "" then
        msg = msg .. " -> " .. info.namewhat .. ":" .. info.name
      end
    else -- a Lua function
      -- out = out .. '\n' .. string.format('[%s]:%d', info.short_src, info.currentline)
      msg = string.format("%d:[%s]:%d", level, info.source, info.currentline)
      if type(info.name) == "string" and info.name ~= "" then
        msg = msg .. " -> " .. info.namewhat .. ":" .. info.name
      end
    end
    table.insert(out, msg)
    level = level + 1
  end
  return out
end

local renderFunc = function(renderType)
  return function(bufnr, notif, highlights)
    -- local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    -- print("renderFunc", renderType)
    return require("notify.render." .. renderType)(bufnr, notif, highlights)
  end

  -- local api = vim.api
  -- local namespace = api.nvim_create_namespace("nvim-notify")
  -- return function(bufnr, notif, highlights)
  --   api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

  --   api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
  --     hl_group = highlights.icon,
  --     end_line = #notif.message - 1,
  --     end_col = #notif.message[#notif.message],
  --   })
  -- -- local notifyRender = require("notify.render")
  -- -- return function(bufnr, notif, highlights)
  -- --   print("RENDER", vim.inspect(notifyRender['default']), renderType)
  -- --   -- local render = 'default' -- minimal
  -- --   return notifyRender[renderType]
  -- end
end

vim.notify = function(message, level, ...)
  local args = ... or {}
  local tb = traceback()

  vim.defer_fn(
    function()
      -- TODO: pull msg strings out, vim.inspect rest of keyed objects
      local notif_time = vim.fn.strftime("%H:%M")
      if type(level) == "number" then
        level = log_level_name(level)
      else
        level = level and string.lower(level) or "debug"
      end

      local level_n = log_level_number(level)
      local cols = math.floor(vim.opt.columns:get() / 3)
      if level_n >= 4 then
        cols = math.floor(vim.opt.columns:get() / 2)
      end

      local msg = parse_message(message)
      local notify_msg = notify_parse_message(message, cols)

      -- TODO: interate through visible windows to detect if telescope is open
      local bufnr = vim.api.nvim_get_current_buf()
      local winnr = vim.api.nvim_get_current_win()
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

      local min_log_level = log_level_number(config.Logging.log_level)
      local min_notify_level = log_level_number(config.Logging.notify_level)

      local logger = M.initLogger("notify")

      if level_n >= min_log_level then
        if level_n == 1 then
          logger:trace(msg)
        elseif level_n == 2 then
          logger:debug(msg)
        elseif level_n == 3 then
          logger:info(msg)
        elseif level_n == 4 then
          logger:warn(msg)
        elseif level_n == 5 then
          logger:info(vim.inspect(tb))
          logger:error(msg)
        end
      end

      local skip_render = false
      -- NOTE: quick hack to see if other windows open on start

      if level_n < min_notify_level then
        skip_render = true
      elseif winnr ~= 1000 then
        skip_render = true
        logger:warn("skipping winnr: " .. winnr .. " -- (" .. notify_msg .. ")")
      end

      if is_module_available("notify") and skip_render == false then
        local notify = require("notify")
        local timeout = 2000
        local renderType = "minimal"
        if type(args.title) == "nil" then
          if level_n == 4 then
            args.title = "WARN"
          elseif level_n == 5 then
            args.title = {"ERROR", notif_time}
          end
        end
        -- select renderType that displays title
        if type(args.title) ~= "nil" then
          renderType = "default"
        end
        if level_n <= 3 then
          timeout = 2000
        elseif level_n == 4 then
          timeout = 5000
        elseif level_n == 5 then
          timeout = 8000
        -- args.keep = function() return true end
        end
        args.timeout = args.timeout or timeout
        args.render = args.render or renderFunc(renderType)
        notify(notify_msg, level, args)
      end
    end,
    0
  )
end

-- FIXME: lua vim.notify(vim.inspect(vim.fn.getbufinfo(1)), "warn")

vim.logger = M.initLogger("root")

return M
