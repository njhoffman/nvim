local build_test_parts = function()
  return {
    {
      { " ", "ImportFailedIcon" },
      { "plugins.config.cmp-git", "ImportFailedModule" },
      { "an example error msg", "ImportFailedMessage" },
      { "0.64 ms", "ImportFailedTime", { align = { 'right', 40 } } },
    },
    {
      { " ", "ImportFailedIcon" },
      { "lsp", "ImportFailedModule" },
      { "different error", "ImportFailedMessage" },
      { "10.22 ms", "ImportFailedTime", { align = { 'right', 40 } } },
    },
  }
end

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
  vim.dbglog(lines, highlights)
end

local parts = build_test_parts()
build_lines(parts)
