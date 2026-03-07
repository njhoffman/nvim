-- nvim-dap configuration
-- Focused on Lua debugging with one-small-step-for-vimkind

local log = require("logger").init("dap")
local dap = require("dap")

-- Set log level
dap.set_log_level("WARN")

-- Lua adapter for one-small-step-for-vimkind (osv)
-- This allows debugging Lua code running inside Neovim
dap.adapters.nlua = function(callback, config)
  log:debug("Lua adapter connecting to " .. (config.host or "127.0.0.1") .. ":" .. (config.port or 8086))
  callback({
    type = "server",
    host = config.host or "127.0.0.1",
    port = config.port or 8086,
  })
end

-- Lua debug configurations
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = "127.0.0.1",
    port = 8086,
  },
}

-- Signs for breakpoints and stopped location
vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DapBreakpoint",
  linehl = "",
  numhl = "DapBreakpoint",
})

vim.fn.sign_define("DapBreakpointCondition", {
  text = "",
  texthl = "DapBreakpointCondition",
  linehl = "",
  numhl = "DapBreakpointCondition",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "",
  texthl = "DapBreakpointRejected",
  linehl = "",
  numhl = "DapBreakpointRejected",
})

vim.fn.sign_define("DapLogPoint", {
  text = "",
  texthl = "DapLogPoint",
  linehl = "",
  numhl = "DapLogPoint",
})

vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "DapStopped",
  linehl = "DapStoppedLine",
  numhl = "DapStopped",
})

-- Highlight groups
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5c211" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#858585" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" })

-- DAP event listeners
dap.listeners.after.event_initialized["dap_config"] = function()
  log:info("Debug session started")
  -- Enable virtual text when debugging starts
  local ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
  if ok then
    virtual_text.enable()
  end
  -- Open dap-view when debugging starts
  local view_ok, dap_view = pcall(require, "dap-view")
  if view_ok then
    dap_view.open()
  end
end

dap.listeners.before.event_terminated["dap_config"] = function()
  log:info("Debug session terminated")
  -- Close dap-view when debugging ends
  local view_ok, dap_view = pcall(require, "dap-view")
  if view_ok then
    dap_view.close()
  end
end

dap.listeners.before.event_exited["dap_config"] = function()
  log:info("Debug session exited")
  -- Close dap-view when debugging ends
  local view_ok, dap_view = pcall(require, "dap-view")
  if view_ok then
    dap_view.close()
  end
end

-- User commands
vim.api.nvim_create_user_command("DapLuaLaunch", function()
  log:info("Launching Lua debug server on port 8086")
  require("osv").launch({ port = 8086 })
  vim.notify("Lua debug server started on port 8086", vim.log.levels.INFO)
end, { desc = "Launch Lua debug server (osv)" })

vim.api.nvim_create_user_command("DapLuaRunThis", function()
  log:info("Running current Lua file in debugger")
  require("osv").run_this()
end, { desc = "Debug current Lua file" })

vim.api.nvim_create_user_command("DapLuaStop", function()
  log:info("Stopping Lua debug server")
  require("osv").stop()
  vim.notify("Lua debug server stopped", vim.log.levels.INFO)
end, { desc = "Stop Lua debug server" })

vim.api.nvim_create_user_command("DapClearBreakpoints", function()
  dap.clear_breakpoints()
  vim.notify("All breakpoints cleared", vim.log.levels.INFO)
end, { desc = "Clear all breakpoints" })

vim.api.nvim_create_user_command("DapLogBreakpoint", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "Set log point" })

log:debug("nvim-dap configured")
