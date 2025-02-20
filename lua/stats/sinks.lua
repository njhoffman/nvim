local logfile = function(lines, title)
  vim.dbglog(title .. vim.fn.join(lines, "\n  "))
end

local popup = function(lines) end

local buffer = function(lines, title)
  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, title or ("stats-" .. bufnr))
  vim.bo.filetype = "lua"
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, lines, {})
end

local split = function(lines, title)
  vim.cmd("new")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo.filetype = "lua"
  vim.api.nvim_buf_set_name(bufnr, title or ("stats-" .. bufnr))
  vim.api.nvim_buf_set_lines(0, 0, 0, lines, {})
end

local notify = function(lines, title, highlights)
  require("notify").notify(lines, "inspect", {
    timeout = 10000,
    title = { title, "" },
    -- render = 'default',
    highlights = {
      body = "NotifyINFOBody",
      border = "NotifyINFOBorder",
      icon = "NotifyINFOIcon",
      title = "NotifyINFOTitle",
      inline = highlights,
    },
    hide_from_history = true,
  })
end

return {
  logfile = logfile,
  notify = notify,
  split = split,
  buffer = buffer,
  popup = popup,
}
