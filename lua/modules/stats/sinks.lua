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

local notify = function(rows_or_lines, title)
  local opts = {
    timeout = 10000,
    title = { title, "" },
    highlights = {
      body = "NotifyINFOBody",
      border = "NotifyINFOBorder",
      icon = "NotifyINFOIcon",
      title = "NotifyINFOTitle",
    },
    hide_from_history = true,
  }

  local is_rows = type(rows_or_lines) == "table" and type(rows_or_lines[1]) == "table"
  if is_rows then
    opts.payload = {
      kind = "columns",
      data = {
        rows = rows_or_lines,
        columns = {
          { align = "left", highlight = "Keyword" },
          { align = "right", highlight = "Comment" },
        },
        separator = " ",
      },
    }
    require("notify").notify("", "inspect", opts)
  else
    require("notify").notify(rows_or_lines, "inspect", opts)
  end
end

return {
  logfile = logfile,
  notify = notify,
  split = split,
  buffer = buffer,
  popup = popup,
}
