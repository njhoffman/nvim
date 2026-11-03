-- Silence command: Disable noice, clear messages, and route errors to be hidden
-- Provides ability to completely silence messaging and notifications

local M = {}

-- State tracking
local state = {
  restore_routes = nil,
  lsp_clients = nil,
  diagnostics_enabled = nil,
  notify_level = nil,
  is_silenced = false,
}

-- Check if required plugins are available
local function check_plugins()
  local ok_noice, noice = pcall(require, "noice")
  local ok_notify, notify = pcall(require, "notify")

  return ok_noice and ok_notify, noice, notify
end

-- Start silence mode
local function silence_start()
  local ok, noice, notify = check_plugins()
  if not ok then
    vim.notify("Silence requires noice and nvim-notify plugins", vim.log.levels.WARN)
    return
  end

  -- Check if already silenced
  if state.is_silenced then
    vim.notify("Already in silence mode", vim.log.levels.INFO)
    return
  end

  -- Save current diagnostic state
  state.diagnostics_enabled = vim.diagnostic.is_enabled()
  if state.diagnostics_enabled then
    vim.diagnostic.enable(false)
  end

  -- Save and stop LSP clients
  state.lsp_clients = vim.lsp.get_clients()
  if state.lsp_clients and #state.lsp_clients > 0 then
    vim.lsp.stop_client(state.lsp_clients)
  end

  -- Get notification statistics before clearing
  local notify_stats = {
    pending = notify.pending() or 0,
    history = #(notify.history({ include_hidden = true }) or {}),
  }

  -- Get noice history count
  local noice_count = 0
  local ok_manager, manager = pcall(require, "noice.message.manager")
  if ok_manager and manager._history then
    noice_count = #manager._history
  end

  -- Clear all pending notifications
  notify.dismiss({ silent = true, pending = true })

  -- Show one final notification about the silence
  vim.notify(
    string.format(
      "Messages and LSP silenced - pending: %d - noice: %d",
      notify_stats.pending,
      noice_count
    ),
    vim.log.levels.INFO,
    { title = "Silence", timeout = 5000 }
  )

  -- Dismiss the notification we just showed
  vim.schedule(function()
    notify.dismiss({ silent = true, pending = true })
  end)

  -- Save current notify level and set to highest (suppress all)
  state.notify_level = vim.log.levels.OFF
  notify.setup({ level = vim.log.levels.OFF })

  -- Save current noice routes
  local ok_config, config = pcall(require, "noice.config")
  if ok_config and config.routes then
    state.restore_routes = vim.fn.deepcopy(config.routes)
  end

  -- Configure noice to skip all messages
  noice.setup({
    routes = {
      { filter = { event = "msg_show.*", kind = "" }, opts = { skip = true } },
      { filter = { event = "notify.*", kind = "" }, opts = { skip = true } },
    },
  })

  -- Clear noice message history
  if ok_manager and manager._history then
    manager._history = {}
  end

  state.is_silenced = true
end

-- Stop silence mode and restore previous state
local function silence_stop()
  local ok, noice, notify = check_plugins()
  if not ok then
    vim.notify("Silence requires noice and nvim-notify plugins", vim.log.levels.WARN)
    return
  end

  -- Check if in silence mode
  if not state.is_silenced then
    vim.notify("Not currently in silence mode", vim.log.levels.INFO)
    return
  end

  -- Re-enable noice
  noice.enable()

  -- Restore notify level
  notify.setup({ level = vim.log.levels.INFO })

  -- Restart LSP clients if they were stopped
  if state.lsp_clients and #state.lsp_clients > 0 then
    vim.schedule(function()
      for _, client in ipairs(state.lsp_clients) do
        if client and client.name then
          vim.lsp.start(client.config)
        end
      end
    end)
  end

  -- Restore noice routes
  if state.restore_routes then
    noice.setup({ routes = state.restore_routes })
  end

  -- Restore diagnostic state
  if state.diagnostics_enabled and not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(true)
  end

  -- Reset state
  state.restore_routes = nil
  state.lsp_clients = nil
  state.diagnostics_enabled = nil
  state.notify_level = nil
  state.is_silenced = false

  vim.notify("Silence mode disabled", vim.log.levels.INFO)
end

-- Toggle silence mode
local function silence_toggle()
  if state.is_silenced then
    silence_stop()
  else
    silence_start()
  end
end

-- Flush noice history
local function flush_noice()
  local ok_manager, manager = pcall(require, "noice.message.manager")
  if not ok_manager or not manager._history then
    vim.notify("Could not access noice message history", vim.log.levels.WARN)
    return
  end

  local count = #manager._history
  manager._history = {}
  vim.notify(string.format("Flushed %d noice history entries", count), vim.log.levels.INFO)
end

-- Get current silence status
local function get_status()
  return {
    is_silenced = state.is_silenced,
    has_restore_routes = state.restore_routes ~= nil,
    has_lsp_clients = state.lsp_clients ~= nil and #state.lsp_clients > 0,
    diagnostics_enabled = state.diagnostics_enabled,
  }
end

M.silence_start = silence_start
M.silence_stop = silence_stop
M.silence_toggle = silence_toggle
M.flush_noice = flush_noice
M.get_status = get_status

return M
