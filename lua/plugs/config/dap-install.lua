local dap_install = require("dap-install")

dap_install.setup({
  installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})

-- DIInstall / DIUninstall

-- di_api.get_debuggers()
-- local dap_install = require("dap-install")
-- local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()
-- for _, debugger in ipairs(dbg_list) do
--   dap_install.config(debugger)
-- end

-- dap_install.config( "python", {
--   adapters = {
--     type = "executable",
--     command = "python3.9",
--     args = {"-m", "debugpy.adapter"}
--   },
--   configurations = {
--     {
--       type = "python",
--       request = "launch",
--       name = "Launch file",
--       program = "${file}",
--       pythonPath = function()
--         local cwd = vim.fn.getcwd()
--         if vim.fn.executable(cwd .. "/usr/bin/python3.9") == 1 then
--           return cwd .. "/usr/bin/python3.9"
--         elseif vim.fn.executable(cwd .. "/usr/bin/python3.9") == 1 then
--           return cwd .. "/usr/bin/python3.9"
--         else
--           return "/usr/bin/python3.9"
--         end
--       end
--     }
--   }
-- }
-- )
