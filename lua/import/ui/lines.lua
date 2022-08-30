local build_test_parts = function()
  return {
    {
      { " ", "ImportFailedIcon" },
      { "plugins.config.cmp-git", "ImportFailedModule" },
      { "an example error msg", "ImportFailedMessage" },
      { "0.64 ms", "ImportFailedTime", { align = { "right", 100 } } },
    },
    {
      { " ", "ImportFailedIcon" },
      { "lsp", "ImportFailedModule" },
      { "different error", "ImportFailedMessage" },
      { "10.22 ms", "ImportFailedTime", { align = { "right", 100 } } },
    },
  }
end

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
      if type(widths[n]) == "nil" then
        widths[n] = 0
      end
      if #part[1] > widths[n] then
        widths[n] = #part[1]
      end
    end
  end
  return widths
end

local format_lines = function(part_lines, widths)
  local spaced_lines = {}
  local highlights = {}
  for _, part_line in pairs(part_lines) do
    local spaced_line = ""
    local hls = {}
    for n, part in pairs(part_line) do
      hls[n] = { part[2], #spaced_line, #spaced_line + #part[1] }
      spaced_line = spaced_line .. part[1] .. string.rep(" ", widths[n] - #part[1] + 1)
    end
    table.insert(highlights, hls)
    table.insert(spaced_lines, spaced_line)
  end
  return spaced_lines, highlights
end

local build_lines = function(part_lines)
  local widths = get_widths(part_lines)
  local lines, highlights = format_lines(part_lines, widths)
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
