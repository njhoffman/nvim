local M = {}

local host = "127.0.0.1"
local h = require("configs.dap.helpers")

function M.setup(dap)
  dap = dap or require("dap")

  -- Go
  if not dap.adapters.go then
    require("configs.dap.go").setup(dap, host)
  end

  -- javascript/typescript
  local js_debug_server = {
    type = "server",
    host = host,
    port = "${port}",
    executable = {
      command = "node",
      args = {
        h.get_install_path("js-debug-adapter") .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }

  if not dap.adapters.chrome then
    dap.adapters.chrome = js_debug_server
  end

  if not dap.adapters.node then
    dap.adapters.node = js_debug_server
  end

  for _, lang in ipairs({
    "typescript",
    "javascript",
  }) do
    dap.configurations[lang] = {
      {
        type = "node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "chrome",
        request = "launch",
        name = "Launch Chrome",
        url = "http://localhost:4200",
        sourceMaps = true,
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        protocol = "inspector",
        port = 9222,
      },
      {
        type = "chrome",
        request = "launch",
        name = 'Start Chrome with "localhost"',
        url = "http://localhost:4200",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
        sourceMaps = true,
      },
    }
  end

  -- lua
  dap.configurations.lua = { { type = "nlua", request = "attach", name = "Neovim lua" } }
  dap.adapters.nlua = function(callback, config)
    vim.dbglog("Adapter invoked")
    callback({
      type = "server",
      host = config.host or host,
      port = config.port or 8086,
    })
  end
end

return M
