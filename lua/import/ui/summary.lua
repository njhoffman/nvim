local opts = require("import.opts")
local cmds = require("import.commands")
local ui_state = require("import.ui.state")

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

-- local combine_fields = function(fields)
--   return fields[2] .. ' fag'
-- end
-- -- return vim.fn.strchars(string.gsub(line, '^%s+', ''))
-- local lines = { { " ", "plugins.config.substitute-nvim" }, { " ", " substitute-nvim" } }

-- local summary_lines = function(imported, view_width)
--   local lines = { title_line(imported, view_width) }
--   ui_state.lines = { -1 }
--   failed_lines(imported, view_width, lines)
--   table.insert(lines, "")
--   table.insert(ui_state.lines, -1)
--   success_lines(imported, view_width, lines)
--   return lines
-- end

local title_line = function(imported, view_width)
  local title = #imported.successes .. " imported"

  if #imported.failures > 0 then
    title = title .. " - " .. #imported.failures .. " failed"
  end

  title = title .. " - " .. math.floor(imported.time / 1000000 * 100) / 100 .. " ms total"
  local title_padding = (view_width / 2) - (title:len() / 2)
  title = string.rep(" ", title_padding) .. title
  -- title_line(imported, view_width)
  return title
end

local output_title = function(imported, view_width)
  title_line(imported, view_width)
end

local hl_fail = {
  icon = "ImportIcon",
  title = "ImportErrorTitle",
  file = "ImportErrorFile",
  line = "ImportErrorLine",
  message = "ImportErrorMessage",
  command = "ImportErrorCommand",
  stack = "ImportErrorStack",
}

local build_lines = function()
  local spaced_lines = {}
  local linesets = ui_state.failed.parts
  for i, lineparts in pairs(linesets) do
    local line = ""
    for n, linepart in pairs(lineparts) do
      local width = ui_state.failed.widths[i]
      line = linepart[1] .. string.rep(" ", #linepart[1] - widths[i])
    end
    table.insert(spaced_lines, line)
  end
  return spaced_lines
end

local build_failed_lines = function(imported)
  local lines = {}
  local widths = { icon = 3, module = 0, message = 0, time = 0 }

  for _, module_name in ipairs(imported.failures) do
    local icon = ""
    local detail = imported.details[module_name]
    if not detail then
      detail = cmds.get_status(module_name)
    end

    local icon = " " .. opts.user_opts.import_failed_icon .. " "
    local message = "example msg, to parse later"
    local time = math.floor(detail.import_time / 1000000 * 100) / 100 .. " ms total"
    local message = "example error msg"

    local parts = {
      { icon, "ImportFailedIcon" },
      { module_name, "ImportFailedModule" },
      { message, "ImportFailedMessage" },
      { time, "ImportFailedTime" },
    }

    if #module_name > widths.module then
      widths.module = #module_name
    end
    if #message > widths.message then
      widths.message = #message
    end
    if #time > widths.time then
      widths.time = #time
    end

    table.insert(ui_state.failed.parts, parts)
  end

  ui_state.failed.widths = widths
end

local parse_line = function(parts)
  local line = ""
  local hls = {}
  for _, part in pairs(parts) do
    local col_start = string.len(line)
    line = line .. (part[1] or "")
    local col_end = string.len(line)
    table.insert(hls, { part[2], col_start, col_end })
  end
  return { line = line, hls = hls }
end

-- build_highlights = function(linenum)
--   for i, hl in pairs(ui_state.failed.highlights) do
--     vim.dbg(i, hl)
--     vim.api.nvim_buf_add_highlight(
--       ui_state.buf_handle, 0, hl[1], linenum + i, hl[2], hl[3])
--   end
--     -- vim.api.nvim_buf_add_highlight(ui_state.buf_handle, 0, res.hls[1], linenum, res.hls[2], res.hls[3])
--   -- vim.api.nvim_buf_set_lines(ui_state.buf_handle, linenum, -1, false, lines)
-- end
-- {
--   { "", "ImportFailedIcon" },
--   { "plugins.config.cmp-git", "ImportFailedModule" },
--   { "example error msg", "ImportFailedMessage" },
--   { "0.64 ms total", "ImportFailedTime" },
-- }

local output_failed_lines = function()
  local title = "this is an example tilte"
  local lines = {}
  local highlights = {}

  vim.api.nvim_buf_set_lines(ui_state.buf_handle, 0, -1, false, { title })

  for i, linepart in pairs(ui_state.failed.parts) do
    local res = parse_line(linepart)
    table.insert(lines, res.line)
    table.insert(highlights, res.hls)
  end

  ui_state.failed.highlights = highlights
  ui_state.failed.lines = lines
  ui_state.failed.spaced_lines = build_lines()

  -- local linenum = 2
  -- vim.api.nvim_buf_set_lines(
  --   ui_state.buf_handle, linenum, -1, false, ui_state.failed.spaced_lines
  -- )
  -- apply_highlights(2)
end

local summary_lines = function(imported)
  -- output_title(imported, view_width)
  build_failed_lines(imported)
end

return summary_lines
