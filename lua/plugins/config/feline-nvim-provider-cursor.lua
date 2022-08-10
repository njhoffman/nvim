local M = {}
M.position = function(_, opts)
  local line, col = unpack(api.nvim_win_get_cursor(0))

  local line_text = api.nvim_get_current_line()
  -- Get the text before the cursor in the current line
  local before_cursor = line_text:sub(1, col)

  -- Replace tabs with the equivalent amount of spaces according to the value of 'tabstop'
  before_cursor = before_cursor:gsub('\t', string.rep(' ', vim.bo.tabstop))

  -- Turn col from byteindex to column number and make it start from 1
  col = vim.str_utfindex(before_cursor) + 1

  local linenr_min_width, colnr_min_width

  if opts.padding then
    if type(opts.padding) == 'table' then
      linenr_min_width = opts.padding.line or 3
      colnr_min_width = opts.padding.col or 2
    else
      linenr_min_width = 3
      colnr_min_width = 2
    end
  else
    linenr_min_width = 0
    colnr_min_width = 0
  end

  -- Get padded line and column string
  local line_str = string.rep(' ', linenr_min_width - math.floor(math.log10(line)) - 1)
    .. tostring(line)

  local col_str = string.rep(' ', colnr_min_width - math.floor(math.log10(col)) - 1)
    .. tostring(col)

  if opts.format then
    local str = opts.format
    str = str:gsub('{line}', line_str)
    str = str:gsub('{col}', col_str)
    return str
  else
    return string.format('%s:%s', line_str, col_str)
  end
end

M.ascii = function(_, opts)
  -- <s>  115,  Hex 73,  Octal 163
  return '0x73'
end
return M
