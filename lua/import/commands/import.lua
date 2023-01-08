local opts = require("import.opts")
local reporter = require("import.reporter")
local state = require("import.commands.state")
local log_timestamp_format = "%Y-%m-%d %H:%M:%S"
local import_defaults = { hide_output = false, hide_errors = false }

local prepare_benchmarks = function(benchmarks)
  for _, benchmark in ipairs(benchmarks) do
    benchmark.prev = benchmark.get()
  end
  state.benchmarks = benchmarks
end

local finish_benchmarks = function(path)
  local deltas = {}
  for _, benchmark in ipairs(state.benchmarks) do
    benchmark.next = benchmark.get()
    benchmark.delta = benchmark.diff(benchmark.prev, benchmark.next)
    benchmark.output(path, benchmark.delta)
    table.insert(deltas, benchmark.delta)
  end
  return deltas
end

--- Safely wraps the traditional require function that lua uses for importing modules
--- Use in place of "require"
--- @param path string
---     The path to import, this should be exactly what you would pass to require
--- @param success_callback function
---     Optional: If provided, this function will be called on a successfull import of
---     the provided "path". This function will be provided the imported module as
---     its single parameter.
---     Note: This is saved for calling later on reload
---     EG: success_callback(imported_module)
--- @param import_opts table
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
--- require("import.nvim") -- require the import package to get the ability to use its import functionality
--- import("lualine", function(lualine) lualine.setup{ "do your module setup here" } end)
--- import("cmp", function(cmp) cmp.setup{ "do your module setup here" } end)
--- import("netman") -- This module doesn't require setup so you dont need to specify it
local import = function(path, success_cb, import_opts)
  -- I dont think I want to fail as importing on an import is completely valid.
  if package.loaded[path] then
    if type(success_cb) == "function" then
      return success_cb(package.loaded[path])
    else
      return package.loaded[path]
    end
  end

  import_opts = import_opts or {}
  for key, value in pairs(import_defaults) do
    if import_opts[key] == nil then
      import_opts[key] = value
    end
  end

  local print_logs = {}
  local error_logs = {}
  local replay_log = {}
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
    local print_log = string.format(log_format, path, os.date(log_timestamp_format), table.concat(print_safe_args))
    table.insert(print_logs, print_log)
    if opts.user_opts.import_enable_better_printing then
      table.insert(replay_log, { level = "print", log = print_log })
    else
      table.insert(replay_log, { level = "print", log = ... })
    end
  end
  -- redirect errors to print to avoid breaking import
  local error_shim = function(...)
    local print_safe_args = {}
    local _ = { ... }
    for i = 1, #_ do
      table.insert(print_safe_args, tostring(_[i]))
    end
    local error_log =
    string.format("ERROR: " .. log_format, path, os.date(log_timestamp_format), table.concat(print_safe_args))
    table.insert(error_logs, error_log)
    if opts.user_opts.import_enable_better_printing then
      table.insert(replay_log, { level = "error", log = error_log })
    else
      table.insert(replay_log, { level = "error", log = ... })
    end
  end
  -- global shenanigans
  _G.print = print_shim
  _G.error = error_shim

  local metrics = reporter.calc_metrics()
  prepare_benchmarks(import_opts.benchmarks or {})
  local status, mod_ret = pcall(require, path)
  reporter.calc_metrics(metrics)

  -- global shenanigans part 2, electric boogaloo
  _G.print = _print
  _G.error = _error
  if not import_opts.hide_output then
    -- Since we silenced log output above, lets replay the print events to neovim outside
    -- pcall. We are doing it this way since apparently prints dont always fire
    -- in neovim during a require, but they _will_ fire during a pcall.
    -- Thus to replicate the behavior, we are replaying the events to let neovim
    -- do whatever wild neovims do
    for _, log_info in ipairs(replay_log) do
      print(log_info.log)
    end
  end

  if not status then
    -- Import failed 😡
    state.import_status.failures[path] = 1
    state._is_in_error_state = true
  else
    -- Import was a success 😀
    state.import_status.successes[path] = 1
    if type(success_cb) == "function" then
      local cb_status, _ = pcall(success_cb, mod_ret)
      if not cb_status then
        -- Callback failed 😡
        error_shim(_)
        state.import_status.successes[path] = nil
        state.import_status.failures[path] = 1
        finish_benchmarks(path)
      end
    else
      state.import_status.successes[path] = nil
      state.import_status.failures[path] = 1
      finish_benchmarks(path)
    end
  end

  state.import_status.info[path] = {
    import_message = mod_ret,
    import_start = metrics.start,
    import_end = metrics.finish,
    import_time = metrics.duration,
    load_n = metrics.load_n,
    report = metrics.report,
    print_logs = print_logs,
    error_logs = error_logs,
    success_callback = success_cb,
  }

  if state._is_in_error_state and not state._printed_error_state then
    state._printed_error_state = true
    vim.notify("There was an error with your imports", "trace")
  end

  return mod_ret
end

return import
