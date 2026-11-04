local set_option = vim.api.nvim_set_option_value
local get_option = vim.api.nvim_get_option_value

-- ensure winbar remains the same when changing from WinBar to WinBarNC during opening
local winbar_sync = function(ev)
  local bufid = ev.buf
  local winid = vim.fn.bufwinid(bufid)
  local winhl = "WinBarNC:WinBar"
  local old_winhl = vim.api.nvim_get_option_value("winhl", { win = winid })

  if old_winhl and #old_winhl > 0 then
    winhl = old_winhl .. "," .. winhl
  end

  vim.api.nvim_set_option_value("winhl", winhl, { win = winid })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = "TelescopeWinbar",
    buffer = bufid,
    callback = function()
      local new_winhl = get_option("winhl", { win = winid }):gsub(",?WinBarNC:WinBar", "")
      -- set_option('winhl', new_winhl, { win = winid })
      return true
    end,
  })
end

return { winbar_sync = winbar_sync }
