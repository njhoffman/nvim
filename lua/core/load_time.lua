-- Startup timing: reports when the first screen and the deferred plugins finished, without animating.

local M = {}

local function elapsed_ms()
  return vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)) * 1000
end

local function seconds(ms)
  return ("%.2fs"):format(ms / 1000)
end

---@param ready_ms number? first screen
---@param loaded_ms number deferred plugins done
---@param plugins { loaded: integer, count: integer }?
---@return string
function M.format(ready_ms, loaded_ms, plugins)
  local parts = {}
  if ready_ms then
    parts[#parts + 1] = "Ready in " .. seconds(ready_ms)
  end
  parts[#parts + 1] = (ready_ms and "loaded in " or "Loaded in ") .. seconds(loaded_ms)
  local message = table.concat(parts, ", ")
  if plugins then
    message = ("%s (%d/%d plugins)"):format(message, plugins.loaded, plugins.count)
  end
  return message
end

local function report()
  vim.g.startup_loaded_ms = elapsed_ms()
  local ok, lazy = pcall(require, "lazy")
  local message =
    M.format(vim.g.startup_ready_ms, vim.g.startup_loaded_ms, ok and lazy.stats() or nil)
  vim.notify(message, vim.log.levels.INFO, { animate = false, timeout = 3000 })
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    desc = "Record the time to the first screen",
    callback = function()
      vim.g.startup_ready_ms = elapsed_ms()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    desc = "Report startup time once the deferred plugins have loaded",
    callback = function()
      vim.schedule(report)
    end,
  })
end

return M
