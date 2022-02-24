local H = require("helpers")


require"nvim-startup".setup({
  startup_file = "/tmp/nvim-startuptime", -- sets startup log path (string)
  message = function(time) -- function-based custom message
    local listener = os.getenv("NVIM_LISTEN_ADDRESS"):gsub("/tmp/", "")
    local server = vim.v.servername:gsub("/tmp/", "")
    local message = time .. " ms\n"

    -- :lua vim.api.nvim_echo({{'HEY', 'Constant'}},true,{})
-- local max_width = math.max(
--   math.max(unpack(vim.tbl_map(function(line)
--     return vim.fn.strchars(line)
--   end, notif.message))),
--   50
-- )
-- local left_title = notif.title[1] .. string.rep(" ", max_width)
-- local right_title = notif.title[2]
-- api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
-- api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--   virt_text = {
--     { " " },
--     { left_icon, highlights.icon },
--     { left_title, highlights.title },
--   },
--   virt_text_win_col = 0,
--   priority = max_width,
-- })
-- api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--   virt_text = { { right_title, highlights.title }, { " " } },
--   virt_text_pos = "right_align",
--   priority = max_width,
-- })

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
          icon = " ",
          title = "Startup Time",
        })
      end)
    end
    return ""
  end,
})
