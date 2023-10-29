local function debounce(func, delay)
  local timer_id = nil
  return function(...)
    if timer_id then
      vim.fn.timer_stop(timer_id)
    end
    local args = { ... }
    timer_id = vim.fn.timer_start(delay, function()
      func(unpack(args))
    end)
  end
end

local supports_method = function(method)
  local clients = vim.lsp.buf_get_clients()
  for _, client in pairs(clients) do
    if client.server_capabilities[method] then
      return true
    end
  end
  return false
end

local function is_cursor_on_whitespace()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(bufnr, cursor[1] - 1, cursor[1], false)[1]
  local char = line:sub(cursor[2] + 1, cursor[2] + 1)
  return char:match('^%s$') ~= nil
end

return {
  debounce = debounce,
  supports_method = supports_method,
  is_cursor_on_whitespace = is_cursor_on_whitespace,
}
