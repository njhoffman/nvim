local H = require("helpers")

require"nvim-startup".setup({
  startup_file = "/tmp/nvim-startuptime", -- sets startup log path (string)
  message = function(time) -- function-based custom message
    local listener = os.getenv("NVIM_LISTEN_ADDRESS"):gsub("/tmp/", "")
    local server = vim.v.servername:gsub("/tmp/", "")
    local message = time .. " ms\n"
    if listener == server then
      message = message .. listener
    else
      message = message .. "listen: " ..
        listener .. "\nserver:  " .. server
    end
    local message_lvl = 'info'
    if H.is_module_available("notify") then
      local timer = vim.loop.new_timer()
      timer:start(3000, 0, function()
        vim.notify(message, message_lvl, {
          timeout = 5000,
          icon = " ",
          title = "Startup Time",
        })
      end)
    end
    return ""
  end,
})
