local devboxui = require("telescope._extensions.devhints.devboxui")

local parent = {
  w = vim.api.nvim_win_get_width(0),
  h = vim.api.nvim_win_get_height(0),
}

-- open_func = vim.lsp.util.open_floating_preview

local winnr = vim.api.nvim_open_win(0, false, {
  relative = "win",
  height = 10,
  width = 45,
  focusable = false,
  border = "rounded",
  bufpos = { 0, 0 },
  row = parent.h,
  col = parent.w,
  anchor = "SE",
  zindex = 2,
  style = "minimal",
})

local bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
vim.api.nvim_win_set_buf(winnr, bufnr)

devboxui.update_preview(bufnr)
vim.diagnostic.reset(nil, bufnr)

vim.api.nvim_create_augroup("DevHints", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    devboxui.update_preview(bufnr)
  end,
  group = "DevHints",
  buffer = vim.api.nvim_win_get_buf(0),
})
