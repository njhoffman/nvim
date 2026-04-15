-- local lines_width = function(lines)
--   return math.max(math.max(unpack(vim.tbl_map(
--     function(line) return vim.fn.strchars(string.gsub(line, '^%s+', ''))
--   end, lines))))
-- end
-- local lines_width = function(data, user_cb)
--   local count_c = function(line)
--     return vim.fn.strchars(string.gsub(user_cb(line), '^%s+', ''))
--   end
--   return math.max(math.max(unpack(
--     vim.tbl_map(count_c, data)
--   )))
-- end

local get_widths = function(part_lines)
  local widths = {}
  for _, line in ipairs(part_lines) do
    for n, part in ipairs(line) do
      -- TODO: ImportFailedMessage blank
      if type(widths[n]) == "nil" or #part[1] > widths[n] then
        widths[n] = #part[1]
      end
    end
  end
  return widths
end
--   globals.variables                                                    1.73 ms
--   user-options                                                    0.31 ms

local format_lines = function(part_lines, widths, view_width)
  local spaced_lines = {}
  local highlights = {}
  for _, part_line in pairs(part_lines) do
    local spaced_line = ""
    local hls = {}
    local space_left = view_width - 1
    for n, part in pairs(part_line) do
      local width = widths[n] - #part[1] + 1
      if n == #part_line then
        space_left = space_left - #part[1]
        hls[n] = { part[2], #spaced_line + space_left, view_width + 1 }
        spaced_line = spaced_line .. string.rep(" ", space_left) .. part[1]
      else
        hls[n] = { part[2], #spaced_line, #spaced_line + #part[1] }
        spaced_line = spaced_line .. part[1] .. string.rep(" ", width)
      end
      space_left = space_left - widths[n]
    end
    table.insert(highlights, hls)
    -- vim.dbglog(spaced_line)
    table.insert(spaced_lines, spaced_line)
  end
  return spaced_lines, highlights
end

local build_lines = function(part_lines, view_width)
  local widths = get_widths(part_lines)
  local lines, highlights = format_lines(part_lines, widths, view_width)
  return lines, highlights
end

local apply_highlights = function(highlights, linenum, bufnr)
  for i, line in pairs(highlights) do
    for _, hl in pairs(line) do
      vim.api.nvim_buf_add_highlight(bufnr, 0, hl[1], linenum - 1 + i, hl[2], hl[3])
    end
  end
end

return {
  build_lines = build_lines,
  apply_highlights = apply_highlights,
}
-- local parts = build_test_parts()
-- build_lines(parts)
