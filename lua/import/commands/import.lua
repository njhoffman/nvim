local opts = require('import.opts')
local state = require('import.commands.state')
local log_timestamp_format = '%Y-%m-%d %H:%M:%S'
local import_defaults = { hide_output = false, hide_errors = false }

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
local import = function(path, success_callback, import_opts)
  -- TODO: (Mike) I am unsure if this is the best way to do handle an existing import or not?
  -- I dont think I want to fail as importing on an import is completely valid.
  if package.loaded[path] then
    if success_callback then success_callback(package.loaded[path]) end
    return
  end
  import_opts = import_opts or {}
  for key, value in pairs(import_defaults) do
    if import_opts[key] == nil then import_opts[key] = value end
  end
  -- TODO: (Mike) Consider making the import async?
  local print_logs = {}
  local error_logs = {}
  local replay_log = {}
  local _print = print
  local _error = error
  local log_format = '%s - [%s] %s'
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
      table.insert(replay_log, { level = 'print', log = print_log })
    else
      table.insert(replay_log, { level = 'print', log = ... })
    end
  end
  -- redirect errors to print to avoid breaking import
  local error_shim = function(...)
    local print_safe_args = {}
    local _ = { ... }
    for i = 1, #_ do
      table.insert(print_safe_args, tostring(_[i]))
    end
    local error_log = string.format('ERROR: ' .. log_format, path, os.date(log_timestamp_format),
      table.concat(print_safe_args))
    table.insert(error_logs, error_log)
    if opts.user_opts.import_enable_better_printing then
      table.insert(replay_log, { level = 'error', log = error_log })
    else
      table.insert(replay_log, { level = 'error', log = ... })
    end
  end
  -- global shenanigans
  _G.print = print_shim
  _G.error = error_shim
  local start_time = vim.loop.hrtime()
  local status, module_return = pcall(require, path)
  local duration = vim.loop.hrtime() - start_time
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
  local message = nil
  if not status then
    -- Import failed 😡
    message = module_return
    state.import_status.failures[path] = 1
    state._is_in_error_state = true
  else
    -- Import was a success 😀
    state.import_status.successes[path] = 1
    if success_callback then
      local callback_status, _ = pcall(success_callback, module_return)
      if not callback_status then
        -- Callback failed 😡
        error_shim(_)
        state.import_status.successes[path] = nil
        state.import_status.failures[path] = 1
      end
    end
  end

  state.import_status.info[path] = {
    import_message   = message,
    import_time      = duration,
    print_logs       = print_logs,
    error_logs       = error_logs,
    success_callback = success_callback
  }
  if state._is_in_error_state and not state._printed_error_state then
    state._printed_error_state = true
    print("There was an error with your imports")
  end
end

return import
