local ascii = function(_, opts)
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  local code = string.byte(char)
  if code == nil then
    return '    '
  end
  -- return char .. ' 0x' .. string.format('%x', code)
  return '0x' .. string.format('%x', code)
end

-- Enable if current window width is higher than 100
return {
  name = 'ascii',
  provider = ascii,
}
