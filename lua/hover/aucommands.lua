local actions = require("hover.actions")
local keymaps = require("hover.keymaps")

local function init(winnr, _opts)
  local opts = _opts or {}
  vim.api.nvim_create_augroup("Hover", { clear = true })
  if opts.behavior == "once" then
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.api.nvim_win_close(winnr, true)
        vim.api.nvim_del_augroup_by_name("Hover")
        keymaps.clear()
      end,
      group = "Hover",
    })
  elseif opts.behavior == "cursor" then
    local au_cursor_id = 0
    local au_cursor = function(_bufnr)
      au_cursor_id = vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
          vim.schedule_wrap(actions.hover_cursor())
        end,
        group = "Hover",
        buffer = _bufnr,
      })
    end
    au_cursor(vim.api.nvim_win_get_buf(0))

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(ev)
        vim.api.nvim_del_autocmd(au_cursor_id)
        au_cursor(tonumber(ev.match))
      end,
      group = "Hover",
    })
  end

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if ev.match == tostring(winnr) then
        vim.api.nvim_del_augroup_by_name("Hover")
        keymaps.clear()
      end
    end,
    group = "Hover",
  })
end

return {
  init = init,
}
