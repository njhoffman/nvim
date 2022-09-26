local devbox = require("devbox.devbox")

local init = function(bufnr, winnr)
  vim.api.nvim_create_augroup("DevBox", { clear = true })

  local au_cursor_id = 0
  local au_cursor = function(_bufnr)
    au_cursor_id = vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        devbox.update_preview(bufnr)
      end,
      group = "DevBox",
      buffer = _bufnr,
    })
  end
  au_cursor(vim.api.nvim_win_get_buf(0))

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(ev)
      vim.api.nvim_del_autocmd(au_cursor_id)
      au_cursor(tonumber(ev.match))
    end,
    group = "DevBox",
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if ev.match == tostring(winnr) then
        vim.api.nvim_del_augroup_by_name("DevBox")
      end
    end,
    group = "DevBox",
  })
end

return { init = init }
