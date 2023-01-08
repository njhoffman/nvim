local utils = require('runner.utils')

local run_remote = function(params)
  local cmd = params.args or vim.g.run_cmd or ''
  utils.remote_commands(cmd)
  -- lua require("plenary.reload").reload_module "plenary"
end

return run_remote
