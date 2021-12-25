local M = {}
local logfile = vim.fn.stdpath("cache") .. "/nvim.log"
local log = require("structlog")
local config = require('config')

M.messages = {}

function M.inspect(tbl, depth, n)
  n = n or 2;
  depth = depth or 5;

  if (depth == 0) then
    print(string.rep(" ", n) .. "...");
    return;
  end

  if (n == 0) then print(" "); end

  for key, value in pairs(tbl) do
    if (key and type(key) == "number" or type(key) == "string") then
      key = string.format("[\"%s\"]", key);

      if (type(value) == "table") then
        if (next(value)) then
          print(string.rep(" ", n) .. key .. " = {");
          H.inspect(value, depth - 1, n + 4);
          print(string.rep(" ", n) .. "},");
        else
          print(string.rep(" ", n) .. key .. " = {},");
        end
      else
        if (type(value) == "string") then
          value = string.format("\"%s\"", value);
        else
          value = tostring(value);
        end

        print(string.rep(" ", n) .. key .. " = " .. value .. ",");
      end
    end
  end

  if (n == 0) then print(" "); end
end

-- TODO: make message sink for telescope
-- TODO: parse '\n'
function M.initLogger(name)
  name = name or "root"
  log.configure({
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
        log.sinks.File(log.level.TRACE, logfile, {
           processors = {
            log.processors.Namer(),
            log.processors.StackWriter({ "line", "file" }, { max_parents = 12, stack_level = 0 }),
            log.processors.Timestamper("%H:%M:%S"),
          },
          formatter = log.formatters.Format( --
            "%s [%s] %s: %-30s",
            { "timestamp", "level", "logger_name", "msg" },
            { level = log.formatters.FormatColorizer.color_level() }
          ),
        })
      }
    }
  })
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

local function log_level_number(name)
  name = name or "info"
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_n = 1
  for i, level in ipairs(levels) do
    if level == name then level_n = i - 1 end
  end
  return level_n
end

local function log_level_name(num)
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_name = ""
  for i, level in ipairs(levels) do
    if i == num + 1 then level_name  = level end
  end
  return level_name
end

local parse_message = function(message, cols)
  local msg = ''
  if type(message) == "table" then
    for i, line in ipairs(message) do
      if i > 1 then msg = msg .. "\n  " end
      if type(line) == 'table' then
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


-- nvim_echo({chunks}, {history}, {opts})                           *nvim_echo()*
--                 Echo a message.

--                 Parameters: ~
--                     {chunks}   A list of [text, hl_group] arrays, each
--                                representing a text chunk with specified
--                                highlight. `hl_group` element can be omitted
--                                for no highlight.
--                     {history}  if true, add to |message-history|.
--                     {opts}     Optional parameters. Reserved for future use.
-- :lua vim.api.nvim_echo({{'HEY', 'Constant'}},true,{})
local notify_parse_message = function(message, cols)
  --    
  local msg = message
  if type(msg) == "string" and  string.find(msg, "Set CWD to") == 1 then
    local path, pattern = string.match(msg, 'Set CWD to ([^%s]+) using pattern (.*)' )
    local icon = pattern == ".git" and "  " or "  "
    path = path:gsub(vim.fn.getenv('HOME'), '~')
    msg = icon .. ' ' .. path
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
    if not info then break end
    local msg = ""
    if info.what == "C" then   -- is a C function?
      msg = level .. ': ' .. 'C function'
      if type(info.name) == "string" and info.name ~= "" then
        msg = msg .. " -> " .. info.namewhat .. ":" .. info.name
      end
    else   -- a Lua function
      -- out = out .. '\n' .. string.format('[%s]:%d', info.short_src, info.currentline)
      msg = string.format('%d:[%s]:%d', level, info.source, info.currentline)
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

  vim.defer_fn(function()
    -- TODO: pull msg strings out, vim.inspect rest of keyed objects
    local notif_time = vim.fn.strftime("%H:%M")
    local level_n = log_level_number(level)

    local msg = parse_message(message)

    local cols = math.floor(vim.opt.columns:get() / 3)
    if level_n >= 4 then cols = math.floor(vim.opt.columns:get() / 2) end
    local notify_msg = notify_parse_message(message, cols)

    -- TODO: interate through visible windows to detect if telescope is open
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    if type(level) == "number"  then
      level = log_level_name(level)
    else
      level = level and string.lower(level) or "debug"
    end

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
      local timeout = 2000
      local renderType = 'minimal'
      if type(args.title) == "nil" then
        if level_n == 4 then
          args.title = 'WARN'
        elseif level_n == 5 then
          args.title = {'ERROR', notif_time}
        end
      end
      if type(args.title) ~= "nil" then renderType = 'default' end
      if level_n == 3 then timeout = 4000 end
      if level_n >= 4 then timeout = 6000 end
      if level_n == 5 then
        args.keep = function() return true end
      end
      args.timeout = args.timeout or timeout
      args.render = args.render or renderFunc(renderType)
      require("notify")(notify_msg, level, args)
    end
  end, 0)
end

-- FIXME: lua vim.notify(vim.inspect(vim.fn.getbufinfo(1)), "warn")

vim.logger = M.initLogger("root")

vim.dbg = function(message, ...)
  local args = ... or {}

  local level_n = log_level_number(level)

  local msg = parse_message(message, level_n)
  vim.logger:debug(msg)
  require("notify")(msg, 'debug', { title = args.title or 'debugger' })

end

vim.cmd([[
  function DebugLog(msg)
    call luaeval('vim.dbg(_A[1])', [a:msg])
  endfunction
  command -nargs=? Log call DebugLog('<args>')
]])


vim.notify_example = function()
  vim.notify({ "Fixing problem.", "Please wait..." }, "info", {
    title = 'notify example',
    timeout = 3000,
    on_close = function()
      vim.notify("Problem solved", nil, { title = 'notify example' })
      vim.notify("Error code 0x0395AF", 1, { title = 'notify example' })
    end,
  })
end

return M


-- load.lua : vim.notify('error')



-- 23.1.1 – Accessing Local Variables
-- You can access the local variables of any active function by calling getlocal, from the debug library. It has two parameters: the stack level of the function you are querying and a variable index. It returns two values: the name and the current value of that variable. If the variable index is larger than the number of active variables, getlocal returns nil. If the stack level is invalid, it raises an error. (You can use debug.getinfo to check the validity of a stack level.)

-- Lua numbers local variables in the order that they appear in a function, counting only the variables that are active in the current scope of the function. For instance, the code

--     function foo (a,b)
--       local x
--       do local c = a - b end
--       local a = 1
--       while true do
--         local name, value = debug.getlocal(1, a)
--         if not name then break end
--         print(name, value)
--         a = a + 1
--       end
--     end

--     foo(10, 20)
-- will print
--     a       10
--     b       20
--     x       nil
--     a       4
-- The variable with index 1 is a (the first parameter), 2 is b, 3 is x, and 4 is another a. At the point where getlocal is called, c is already out of scope, while name and value are not yet in scope. (Remember that local variables are only visible after their initialization code.)
-- You can also change the values of local variables, with debug.setlocal. Its first two parameters are a stack level and a variable index, like in getlocal. Its third parameter is the new value for that variable. It returns the variable name, or nil if the variable index is out of scope.

-- 23.1.2 – Accessing Upvalues
-- The debug library also allows us to access the upvalues that a Lua function uses, with getupvalue. Unlike local variables, however, a function has its upvalues even when it is not active (this is what closures are about, after all). Therefore, the first argument for getupvalue is not a stack level, but a function (a closure, more precisely). The second argument is the upvalue index. Lua numbers upvalues in the order they are first referred in a function, but this order is not relevant, because a function cannot have two upvalues with the same name.

-- You can also update upvalues, with debug.setupvalue. As you might expect, it has three parameters: a closure, an upvalue index, and the new value. Like setlocal, it returns the name of the upvalue, or nil if the upvalue index is out of range.

-- The following code shows how we can access the value of any given variable of a calling function, given the variable name:

--     function getvarvalue (name)
--       local value, found

--       -- try local variables
--       local i = 1
--       while true do
--         local n, v = debug.getlocal(2, i)
--         if not n then break end
--         if n == name then
--           value = v
--           found = true
--         end
--         i = i + 1
--       end
--       if found then return value end

--       -- try upvalues
--       local func = debug.getinfo(2).func
--       i = 1
--       while true do
--         local n, v = debug.getupvalue(func, i)
--         if not n then break end
--         if n == name then return v end
--         i = i + 1
--       end

--       -- not found; get global
--       return getfenv(func)[name]
--     end


  -- function NotificationService:dismiss(opts)
  --   local bufs = vim.api.nvim_list_bufs()
  --   local notif_wins = {}
  --   for _, buf in pairs(bufs) do
  --     local win = vim.fn.bufwinid(buf)
  --     if win ~= -1 and vim.api.nvim_buf_get_option(buf, "filetype") == "notify" then
  --       notif_wins[#notif_wins + 1] = win
  --     end
  --   end
  --   for _, win in pairs(notif_wins) do
  --     pcall(vim.api.nvim_win_close, win, true)
  --   end
  --   if opts.pending then
  --     local cleared = 0
  --     while self._pending:pop() do
  --       cleared = cleared + 1
  --     end
  --     vim.notify("Cleared " .. cleared .. " pending notifications")
  --   end
  -- end
