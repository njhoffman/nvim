local opts = require("import.opts")
local cmds = require("import.commands")
local ui_state = require("import.ui.state")
local lines = require("import.ui.lines")

local title_line = function(imported, view_width)
  local title = #imported.successes .. " imported"
  if #imported.failures > 0 then
    title = title .. " - " .. #imported.failures .. " failed"
  end
  title = title .. " - " .. math.floor(imported.time / 1000000 * 100) / 100 .. " ms total"
  local title_padding = (view_width / 2) - (title:len() / 2)
  title = string.rep(" ", title_padding) .. title
  return title
end

local debuglog = require("debuglog")
local build_failed_parts = function(imported)
  local part_lines = {}
  for _, name in ipairs(imported.failures) do
    local detail = imported.details[name]
    if not detail then
      detail = cmds.get_status(name)
    end

    local icon = " " .. opts.user_opts.import_failed_icon .. " "
    local time = math.floor(detail.import_time / 1000000 * 100) / 100 .. " ms "

    local message = detail.summary or " -- "
    -- print(string.format("%-12s%-12s%-12s", "Some", "String", "Test"))
    -- - : left align result inside field
    -- + : always prefix with a sign, using + if field positive
    -- 0 : left-fill with zeroes rather than spaces
    -- (space) : If positive, put a space where the + would have been
    -- foo = data .. string.rep("-", 50 - data:len())

    local parts = {
      { icon, "ImportFailedIcon" },
      { name, "ImportFailedModule" },
      { message, "ImportFailedMessage" },
      { time, "ImportFailedTime", {} },
    }

    table.insert(ui_state.details, name)
    table.insert(part_lines, parts)
  end
  return part_lines
end

local build_success_parts = function(imported)
  local part_lines = {}
  table.sort(imported.successes, function(a, b)
    return imported.details[a].load_n < imported.details[b].load_n
  end)

  for _, name in ipairs(imported.successes) do
    local detail = imported.details[name]
    if not detail then
      detail = cmds.get_status(name)
    end

    local icon = " " .. opts.user_opts.import_success_icon .. " "
    local time = math.floor(detail.import_time / 1000000 * 100) / 100 .. " ms "
    local message = detail.summary or "" -- or ("#" .. tostring(detail.load_n))

    local parts = {
      { icon, "ImportSuccessIcon" },
      { name, "ImportSuccessModule" },
      { message, "ImportSuccessMessage" },
      { time, "ImportSuccessTime" },
    }

    table.insert(ui_state.details, name)
    table.insert(part_lines, parts)
  end
  return part_lines
end

local summary_lines = function(imported, view_width)
  local linenum = 0
  local title = title_line(imported, view_width)
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, linenum, -1, false, { title })
  linenum = linenum + 1

  local failed_parts = build_failed_parts(imported)
  local failed_lines, failed_highlights = lines.build_lines(failed_parts, view_width)
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, linenum, -1, false, failed_lines)
  lines.apply_highlights(failed_highlights, linenum, ui_state.buf_handle)
  linenum = linenum + #failed_lines

  local success_parts = build_success_parts(imported)
  local success_lines, success_highlights = lines.build_lines(success_parts, view_width)
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, linenum, -1, false, success_lines)
  lines.apply_highlights(success_highlights, linenum, ui_state.buf_handle)
  linenum = linenum + #success_lines

  -- debuglog.log(success_parts)
end

return summary_lines
