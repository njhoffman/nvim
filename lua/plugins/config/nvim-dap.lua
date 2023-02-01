local dap = require("dap")
local config = require("config")
local DAP = config.DAP

-- git clone https://github.com/microsoft/vscode-node-debug2.git vim.fn.stdpath("data") .. "adapters/vscode-node-debug2"
-- /usr/local/bin/nvim --embed --headless
-- =============================
--              DAP
-- =============================
-- mfussenegger/nvim-dap
-- C/C++/Rust Go Java Mockdebug Python Ruby Dart Haskell Javascript/Node PHP Scala Neovim Lua .NET
if DAP.log_level ~= nil or DAP.log_level ~= false or DAP.log_level ~= 0 then
  dap.set_log_level(DAP.log_level)
  -- nvim-dap/lua/dap/log.lua:29
end

dap.adapters.bashdb = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
  name = "bashdb",
}
-- Add the configuration :

dap.configurations.sh = {
  {
    type = "bashdb",
    request = "launch",
    name = "Launch file",
    showDebugOutput = true,
    pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
    pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
    trace = true,
    file = "${file}",
    program = "${file}",
    cwd = "${workspaceFolder}",
    pathCat = "cat",
    pathBash = "/bin/bash",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    args = {},
    env = {},
    terminalKind = "integrated",
  },
}

dap.adapters.node2 = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/node-debug2-adapter",
}
dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}
dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    --   host = function()
    --     local value = vim.fn.input('Host [127.0.0.1]: ')
    --     if value ~= "" then
    --       return value
    --     end
    --     return '127.0.0.1'
    --   end,
    --   port = function()
    --     local val = tonumber(vim.fn.input('Port: '))
    --     assert(val, "Please provide a port number")
    --     return val
    --   end,
  },
}

dap.adapters.nlua = function(callback, lua_config)
  callback({
    type = "server",
    host = lua_config.host or "127.0.0.1",
    port = lua_config.port or 8090,
  })
end

-- If you prefer to start delve manually, you can use the following adapter definition instead:
--
-- dap.adapters.delve = {
--   type = "server",
--   host = "127.0.0.1",
--   port = 38697,
-- }
-- dap.configurations.lua = {
--   {
--     type = 'nlua',
--     request = 'attach',
--     name = "Attach to running Neovim instance",
--   }
-- }
--
-- dap.adapters.nlua = function(callback, config)
--   callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
-- end

-- dap.adapters.go = {
--   type = "executable",
--   -- command = "node",
--   command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
--   args = { vim.fn.stdpath("data") .. "/adapters/vscode-go/dist/debugAdapter.js" },
-- }
--
-- dap.configurations.go = {
--   {
--     type = "go",
--     name = "Debug",
--     cwd = vim.fn.getcwd(),
--     request = "launch",
--     showLog = false,
--     program = "${workspaceFolder}/${file}",
--     -- program = "${file}",
--     dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
--   },
-- }
--
-- dap.configurations.javascript = {
--   {
--     type = "node2",
--     request = "launch",
--     program = "${workspaceFolder}/${file}",
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = "inspector",
--     console = "integratedTerminal",
--   },
-- }
--
-- dap.configurations.javascriptreact = {
--   {
--     type = "node2",
--     request = "launch",
--     program = "${workspaceFolder}/${file}",
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = "inspector",
--     console = "integratedTerminal",
--   },
-- }
--
-- dap.configurations.typescript = {
--   {
--     type = "node2",
--     request = "launch",
--     program = "${workspaceFolder}/${file}",
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = "inspector",
--     console = "integratedTerminal",
--   },
-- }
-- -- NODE / TYPESCRIPT
-- dap.adapters.node2 = {
--   type = "executable",
--   -- command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
--   command = "node",
--   args = {
--     vim.fn.stdpath("data") .. "/adapters/vscode-node-debug2/out/src/nodeDebug.js",
--   },
-- }
-- require("dap-python").setup("/home/linuxbrew/.linuxbrew/opt/python@3.8/bin/python3.8")
--
-- -- dap.adapters.go = function(cb, config)
-- --   local cb_input = {
-- --     type = "executable",
-- --     command = os.getenv("HOME") .. "/.nvm/versions/node/v12.18.2/bin/node",
-- --     args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" },
-- --   };
-- --   if config.request == "attach" and config.mode == "remote" then
-- --     local _, port = start_devenv_debug_session()
-- --     cb_input.enrich_config = function(config, on_config)
-- --       local f_config = vim.deepcopy(config)
-- --       f_config.port = tonumber(port)
-- --       on_config(f_config)
-- --     end;
-- --   elseif config.mode == "test" then
-- --     local package = vim.fn.input("Go package to debug: ");
-- --     cb_input.enrich_config = function(config, on_config)
-- --       local f_config = vim.deepcopy(config)
-- --       f_config.program = os.getenv("PLAID_PATH") .. "/go.git/" .. package
-- --       on_config(f_config)
-- --     end;
-- --   end
-- --   cb(cb_input)
-- -- end;
--
-- -- LUA
-- --   Launch the server in the debuggee using require"osv".launch()
-- --   Open another Neovim instance with the source file
-- --   Place breakpoint
-- --   Connect using the DAP client
-- --   Run your script/plugin in the debuggee
-- -- Alternaltively you can:
-- --   Open a lua file
-- --   Place breakpoint
-- --   Invoke require"osv".run_this()
-- --   vim.fn.stdpath('data') .. osv.log
--
-- -- RUBY
-- -- C/CPP
-- -- Enable virtual text.
-- -- TODO: check options
-- -- if DAP.virtual_text ~= nil or DAP.virtual_text ~= false or DAP.virtual_text ~= 0 then
-- --   vim.g.dap_virtual_text = DAP.virtual_text
-- -- end
--
-- -- local ensure_script = os.getenv('PLAID_PATH') .. '/go.git/scripts/ensure_debugger_session.sh';
--
-- -- local function get_debugging_port(service_name)
-- --   local ports_compose = io.open(
-- --     os.getenv('PLAID_PATH') .. '/go.git/proto/src/plaidtypes/coretypes/service.proto', 'r'
-- --   )
-- --   local port = nil
-- --   for line in ports_compose:lines() do
-- --     -- Match lines like: "    SERVICE_FEATURE_SERVER_CONSUMER = 181 [" and pull the 181.
-- --     local proto_base = string.match(
-- --       line,
-- --       '^%s-SERVICE_' .. string.upper(service_name) .. '%s-=%s-(%d+)%s-%['
-- --     )
-- --     if proto_base ~= nil then
-- --       port = 50000 + (proto_base + 1) * 10 - 1
-- --       break
-- --     end
-- --   end
-- --   ports_compose:close()
-- --   return port
-- -- end
--
-- -- local function start_devenv_debug_session()
-- --   local service_name = vim.fn.input('Debugee Service: ')
-- --   local port = get_debugging_port(service_name) or vim.fn.input('Debuggee Port: ')
-- --   -- Start the debugger in the devenv service.
-- --   vim.fn.system({ensure_script, service_name})
-- --   io.write(string.format('Debug session for %s with port %d', service_name, port))
-- --   return service_name, port;
-- -- end
--
-- -- =============================
-- --            ADAPTERS
-- -- =============================
--
-- -- PYTHON
-- -- dap.adapters.python = {
-- --   type = "executable",
-- --   -- command = os.getenv("HOME") .. "/default-env/lib/python3.9/bin/python",
-- --   command = "/home/linuxbrew/.linuxbrew/opt/python@3.9/bin/python3.9",
-- --   args = { "-m", "debugpy.adapter" },
-- -- }
--
-- -- dap.adapters.devenv_python = function(cb, config)
-- --   local _, port = start_devenv_debug_session();
-- --   local remoteness = vim.fn.input('Remote or Local Devenv: ')
-- --   local host;
-- --   if remoteness == 'remote' then
-- --     host = '10.131.1.149';
-- --   elseif remoteness == 'local' then
-- --     host = '127.0.0.1';
-- --   else
-- --     io.write(string.format('Unusable remoteness value: %s', remoteness));
-- --   end
-- --   cb({
-- --     type = 'server';
-- --     host = host;
-- --     port = port;
-- --     enrich_config = function(config, on_config)
-- --       local f_config = vim.deepcopy(config)
-- --       if f_config.connect ~= nil then
-- --         f_config.connect.port = port;
-- --         f_config.connect.host = host;
-- --       end
-- --       on_config(f_config)
-- --     end;
-- --   })
-- -- end
--
-- -- -- GO
-- -- Install delve
--
-- -- go get github.com/go-delve/delve/cmd/dlv
-- -- or via package manager (pacman -S delve)
-- -- Install vscode-go
--
-- -- git clone https://github.com/golang/vscode-go
-- -- cd vscode-go
-- -- npm install && npm run compile
-- -- manual: dlv dap -l 127.0.0.1:38697 --log --log-output="dap"
--
-- -- =============================
-- --         CONFIGURATIONS
-- -- =============================
-- -- # pip install debugpy, needs python3.8
--
-- -- dap.configurations.python = {
-- --   {
-- --     -- The first three options are required by nvim-dap
-- --     type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
-- --     request = "launch",
-- --     name = "Launch file",
-- --     -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
-- --     program = "${file}", -- This configuration will launch the current file if used.
-- --     -- pythonPath = function()
-- --     --   -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
-- --     --   -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
-- --     --   -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
-- --     --   local cwd = vim.fn.getcwd()
-- --     --   if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
-- --     --     return cwd .. "/venv/bin/python"
-- --     --   elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
-- --     --     return cwd .. "/.venv/bin/python"
-- --     --   else
-- --     --     return "/usr/bin/python"
-- --     --   end
-- --     -- end,
-- --   },
-- --   -- {
-- --   --   type = "devenv-python",
-- --   --   request = "attach",
-- --   --   mode = "remote",
-- --   --   connect = {},
-- --   --   name = "Devenv Debugger",
-- --   --   cwd = vim.fn.getcwd(),
-- --   --   pathMappings = {
-- --   --     { localRoot = vim.fn.getcwd(), remoteRoot = "/usr/src/app" },
-- --   --   },
-- --   -- },
-- -- }
--
-- -- dap.configurations.go = {
-- --   {
-- --     type = "go",
-- --     request = "attach",
-- --     mode = "remote",
-- --     name = "Remote Attached Debugger",
-- --     remotePath = "/opt/gopath/src/github.plaid.com/plaid/go.git",
-- --     cwd = vim.fn.getcwd(),
-- --     dlvToolPath = vim.fn.exepath("dlv"),
-- --   },
-- --   {
-- --     type = "go",
-- --     name = "Local File Debugger",
-- --     request = "launch",
-- --     program = "${file}",
-- --     dlvToolPath = vim.fn.exepath("dlv"),
-- --   },
-- --   {
-- --     type = "go",
-- --     request = "launch",
-- --     mode = "test",
-- --     name = "Local Test Debugger",
-- --     envFile = os.getenv("PLAID_PATH") .. "/go.git/environment/experimental",
-- --     dlvToolPath = vim.fn.exepath("dlv"),
-- --   },
-- -- }
