local H = require "helpers"
if H.is_module_available("notify") then vim.notify = require("notify") end

-- vim.notify({ "Fixing problem.", "Please wait..." }, "info", {
--   title = plugin,
--   timeout = 3000,
--   on_close = function()
--     vim.notify("Problem solved", nil, { title = plugin })
--     vim.notify("Error code 0x0395AF", 1, { title = plugin })
--   end,
-- })

-- timeout: Number of milliseconds to show the window (default 5000)
-- on_open: A function to call with the window ID as an argument after opening
-- on_close: A function to call with the window ID as an argument after closing
-- title: Title string for the header
-- icon: Icon to use for the header
