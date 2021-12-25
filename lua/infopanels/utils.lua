local M = {P}

M.dedent = function(str, leave_indent)
  -- Check each line and detect the minimum indent.
  local indent
  local info = {}
  for line in str:gmatch "[^\n]*\n?" do
    -- It matches '' for the last line.
    if line ~= "" then
      local chars, width
      local line_indent = line:match "^[ \t]+"
      if line_indent then
        chars = #line_indent
        width = M.strdisplaywidth(line_indent)
        if not indent or width < indent then
          indent = width
        end
        -- Ignore empty lines
      elseif line ~= "\n" then
        indent = 0
      end
      table.insert(info, { line = line, chars = chars, width = width })
    end
  end

  -- Build up the result
  leave_indent = leave_indent or 0
  local result = {}
  for _, i in ipairs(info) do
    local line
    if i.chars then
      local content = i.line:sub(i.chars + 1)
      local indent_width = i.width - indent + leave_indent
      line = (" "):rep(indent_width) .. content
    elseif i.line == "\n" then
      line = "\n"
    else
      line = (" "):rep(leave_indent) .. i.line
    end
    table.insert(result, line)
  end
  return table.concat(result)
end

return M
