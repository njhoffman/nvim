local get_last_char = function(chars, key)
  return function()
    chars = type(chars) == 'string' and { chars } or (type(chars) == 'table' and chars) or {}
    key = key or (type(chars) == 'table' and chars[1] or chars)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = vim.fn.trim(vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or '')
    local last_character = current_line and current_line:sub(-1) or ''
    local to_remove = ''
    vim.dbglog(chars, key)
    if vim.fn.empty(chars) and vim.tbl_isempty(chars) and vim.fn.empty(key) then
      vim.dbglog('TO REMOVE', last_character)
      to_remove = last_character
    else
      for _, char in ipairs(chars) do
        if char == last_character then
          to_remove = char
        end
      end
    end

    if to_remove ~= '' then
      current_line = current_line and current_line:sub(1, -2) or ''
    else
      current_line = current_line .. key
    end
    vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], true, { current_line })
    vim.cmd.normal('0==')
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
  end
end

local trailChars = { ',', ';', ')', "'", '"', '|', '\\', '{', '.', '}' }
for _, key in ipairs(trailChars) do
  vim.keymap.set('n', '<leader>a' .. key, get_last_char(key), {
    desc = 'ﲖ toggle ' .. key .. ' end character',
  })
end

vim.keymap.set('n', ',aa', get_last_char({ ',', ';' }), { desc = 'ﲖ toggle ,; end characters' })
vim.keymap.set('n', ',A', get_last_char(), { desc = 'ﲖ strip end characters' })
