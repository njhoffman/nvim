-- Place breakpoint: require"dash".toggle_breakpoint()
-- Step: require"dash".step()
-- Continue: require"dash".continue()
-- Inspect variable: require"dash".inspect()
-- Inspect variable (visual): require"dash".vinspect()

-- Usage
-- :DashRun

-- ntangle
--   ##snippets
--   @../lua/snippets/init.lua=
--   local M = {}
--   @implement
--   return M
--   @implement+=
--   function M.version()
--     return "0.1"
--   end
--
-- 'one-small-step-for-vimkind: osv lua debugger
-- 1. Open a Neovim instance (instance A)
-- 2. Launch the DAP server with (A) >
--  :lua require"osv".launch()
-- < Note: Write down the port number
-- 3. Open another Neovim instance (instance B)
-- 4. Open `myscript.lua` (B)
-- 5. Place a breakpoint on line 2 using (B) >
--   :lua require"dap".toggle_breakpoint()
-- <6. Connect the DAP client using (B) >
--   :lua require"dap".continue()
-- < Note: host - Press return, leave default
--        port - Enter the port you wrote down
-- 7. Run `myscript.lua` in the other instance (A) >
--   :luafile myscript.lua
-- <8. The breakpoint should hit and freeze the instance (B)

-- launch({opts})                                           *osv.launch()*

-- This command will launch the DAP server awaiting any connections. On
-- execution, a prompt message will display the port it's running on.

--     Parameters:~
--         {opts} Optional parameters.
--                • `host`: defaults to "127.0.0.1"
--                • `port`: Specify a port number or if nil, lets the server
--                choose an available port.
--                • `log`: boolean to enable logging
-- run_this({opts})                                        *osv.run_this()*

--     Parameters:~
--         {opts} Optional parameters.
--                • `log`: boolean to enable logging

-- This command will automatically start the DAP server and connect
-- nvim-dap to it. You still need to set the `dap.adapters.nlua` as
-- explained in the configuration section.
