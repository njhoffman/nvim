local H = require "helpers"

if H.is_module_available("nvim-startup") then
  require"nvim-startup".setup {
    startup_file = "/tmp/nvim-startuptime", -- sets startup log path (string)
    -- message = "Whoa! those {} are pretty fast", -- sets a custom message (string | function)
    message = function(time) -- function-based custom message
      local message = "nvim-startup: launched in " .. time .. " ms"
      local message_lvl = vim.lsp.log_levels.WARN
      if time < 100 then message_lvl = vim.lsp.log_levels.INFO end
      if H.is_module_available("notify") then
        local timer = vim.loop.new_timer()
        local notify = require("notify")
        timer:start(3000, 0, function() notify(message, message_lvl, { timeout = 3000, title = "Startup Time" }) end)
      end
      return message
    end,
  }
end
