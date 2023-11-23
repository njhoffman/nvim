local function selection_count()
  local mode = vim.fn.mode(true)
  local line_start, col_start = vim.fn.line('v'), vim.fn.col('v')
  local line_end, col_end = vim.fn.line('.'), vim.fn.col('.')
  if mode:match('') then
    return string.format('%dx%d', math.abs(line_start - line_end) + 1, math.abs(col_start - col_end) + 1)
  elseif mode:match('V') or line_start ~= line_end then
    return math.abs(line_start - line_end) + 1
  elseif mode:match('v') then
    return math.abs(col_start - col_end) + 1
  else
    return ''
  end
end

-- function M.position(_, opts)
--     local line, col = unpack(api.nvim_win_get_cursor(0))
--
--     local line_text = api.nvim_get_current_line()
--     -- Get the text before the cursor in the current line
--     local before_cursor = line_text:sub(1, col)
--
--     -- Replace tabs with the equivalent amount of spaces according to the value of 'tabstop'
--     before_cursor = before_cursor:gsub('\t', string.rep(' ', vim.bo.tabstop))
--
--     -- Turn col from byteindex to column number and make it start from 1
--     col = vim.str_utfindex(before_cursor) + 1
--
--     local linenr_min_width, colnr_min_width
--
--     if opts.padding then
--         if type(opts.padding) == 'table' then
--             linenr_min_width = opts.padding.line or 3
--             colnr_min_width = opts.padding.col or 2
--         else
--             linenr_min_width = 3
--             colnr_min_width = 2
--         end
--     else
--         linenr_min_width = 0
--         colnr_min_width = 0
--     end
--
--     -- Get padded line and column string
--     local line_str = string.rep(' ', linenr_min_width - math.floor(math.log10(line)) - 1)
--         .. tostring(line)
--
--     local col_str = string.rep(' ', colnr_min_width - math.floor(math.log10(col)) - 1)
--         .. tostring(col)
--
--     if opts.format then
--         local str = opts.format
--         str = str:gsub('{line}', line_str)
--         str = str:gsub('{col}', col_str)
--         return str
--     else
--         return string.format('%s:%s', line_str, col_str)
--     end
-- end

return {
  name = 'selection_count',
  provider = selection_count,
}
