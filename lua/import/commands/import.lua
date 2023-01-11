local user_opts = require("import.opts").user_opts
local reporter = require("import.reporter")
local state = require("import.commands.state")
local log_fmt = "%Y-%m-%d %H:%M:%S"
local benchmarks = require("import.benchmarks")

local defaults = {
  hide_output = false,
  hide_errors = false,
  benchmarks = { "keymaps", "aucommands" },
}

local prepare_benchmarks = function(path, bmarks)
  state.status.benchmarks[path] = {}
  for _, name in pairs(bmarks) do
    benchmarks[name].prev = benchmarks[name].get()
    state.status.benchmarks[path][name] = benchmarks[name]
  end
end

local finish_benchmarks = function(path)
  local bmarks = state.status.benchmarks[path]
  local mod_info = state.status.info[path]
  if type(mod_info) == "table" then
    for name, bmark in pairs(bmarks) do
      bmark.next = bmark.get()
      bmark.delta = bmark.diff(bmark.prev, bmark.next)
      mod_info.summary = (mod_info.summary or "") .. bmark.summary(bmark.delta)
      mod_info.report = (mod_info.report or "") .. bmark.report(path, bmark.delta) .. "\n"
      -- debuglog.log(mod_info.report)
    end
  end
end

--- Safely wraps the traditional require function that lua uses for importing modules
--- Use in place of "require"
--- @param path string
---     The path to import, this should be exactly what you would pass to require
--- @function[opt] success_cb
---     Optional: If provided, this function will be called on a successfull import of
---     the provided "path". This function will be provided the imported module as
---     its single parameter.
---     Note: This is saved for calling later on reload
---     EG: success_cb(imported_module)
--- @table[opt] import_opts
---     Optional: If provided, the following options are available to be used during
---     import.
---     hide_output = false,
---         -- When provided, this will hide anything that was printed, but still have it available
---         -- on the ImportStatus page
---     hide_errors = false,
---         -- When provided, this will hide anything that was printed to the errors, but still
---         -- be available on the ImportStatus page
--- @return nil
---
--- Examples
--- import("lualine", function(lualine) lualine.setup{ "do your module setup here" } end)
--- import("netman") -- This module doesn't require setup so you dont need to specify it
local import = function(path, success_cb, import_opts)
  if package.loaded[path] then
    if type(success_cb) == "function" then
      return success_cb(package.loaded[path])
    else
      return package.loaded[path]
    end
  end

  import_opts = import_opts or {}
  for key, value in pairs(defaults) do
    if import_opts[key] == nil then
      import_opts[key] = value
    end
  end

  local logs = { print = {}, error = {}, replay = {} }
  local _print = print
  local _error = error
  local log_format = "%s - [%s] %s"

  -- print/error shim function to collect statements sent to both
  local print_shim = function(...)
    local print_safe_args = {}
    local _ = { ... }
    for i = 1, #_ do
      table.insert(print_safe_args, tostring(_[i]))
    end
    local print_log = string.format(log_format, path, os.date(log_fmt), table.concat(print_safe_args))
    table.insert(logs.print, print_log)
    if user_opts.import_enable_better_printing then
      table.insert(logs.replay, { level = "print", log = print_log })
    else
      table.insert(logs.replay, { level = "print", log = ... })
    end
  end
  -- redirect errors to print to avoid breaking import
  local error_shim = function(...)
    local print_safe_args = {}
    local _ = { ... }
    for i = 1, #_ do
      table.insert(print_safe_args, tostring(_[i]))
    end
    local error_log = string.format("ERROR: " .. log_format, path, os.date(log_fmt), table.concat(print_safe_args))
    table.insert(logs.error, error_log)
    if user_opts.import_enable_better_printing then
      table.insert(logs.replay, { level = "error", log = error_log })
    else
      table.insert(logs.replay, { level = "error", log = ... })
    end
  end
  -- global shenanigans
  _G.print = print_shim
  _G.error = error_shim

  local metrics = reporter.calc_metrics()
  prepare_benchmarks(path, import_opts.benchmarks or {})
  local mod_status, mod_ret = pcall(require, path)
  reporter.calc_metrics(metrics)

  -- global shenanigans part 2, electric boogaloo
  _G.print = _print
  _G.error = _error
  if not import_opts.hide_output then
    -- Replay silenced print events from above print to neovim outside pcall.
    -- Prints dont always fire in with a require, but they _will_ during a pcall.
    -- Replicate behavior by replaying the events to neovim

    for _, log_info in ipairs(logs.replay) do
      print(log_info.log)
    end
  end

  state.status.info[path] = {
    import_message = mod_ret,
    import_start = metrics.start,
    import_end = metrics.finish,
    import_time = metrics.duration,
    load_n = metrics.load_n,
    print_logs = logs.print,
    error_logs = logs.error,
    success_cb = success_cb,
  }

  if not mod_status then
    state.status.failures[path] = 1
    state._error_state = true
  else
    if type(success_cb) == "function" then
      local cb_status, _ = pcall(success_cb, mod_ret)
      if not cb_status then
        error_shim(_)
        state.status.successes[path] = nil
        state.status.failures[path] = 1
      end
    else
      state.status.successes[path] = 1
      state.status.failures[path] = nil
    end
    finish_benchmarks(path)
  end

  if state._error_state and not state._error_printed then
    state._error_printed = true
    vim.notify("There was an error with your imports", 1)
  end

  return mod_ret
end

return import
