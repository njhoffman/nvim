local M = {}

local COLORSCHEME_DIR = vim.fn.stdpath("config") .. "/lua/colorschemes/nord-nick"
local SOURCE_FILES = { "editor.lua", "syntax.lua", "plugins.lua" }

--- Parse a set() call line from a colorscheme source file.
--- Matches: `set(0, "GroupName", { ... })` or `set(0, "@group.name", { ... })`
--- @param line string
--- @return string|nil group_name, string|nil attrs_str
local function parse_source_line(line)
  return line:match('^%s*set%(0,%s*"([^"]+)",%s*(%b{})%)')
end

--- Build an index of all highlight groups defined in colorscheme source files.
--- @return table Map of group_name -> { file: string, line: number, full_line: string }
function M.build_source_index()
  local index = {}

  for _, filename in ipairs(SOURCE_FILES) do
    local filepath = COLORSCHEME_DIR .. "/" .. filename
    local f = io.open(filepath, "r")
    if f then
      local lnum = 0
      for line in f:lines() do
        lnum = lnum + 1
        local group_name = parse_source_line(line)
        if group_name then
          index[group_name] = {
            file = filename,
            filepath = filepath,
            line = lnum,
            full_line = line,
          }
        end
      end
      f:close()
    end
  end

  return index
end

--- Generate a set() call line from a group name and attributes table.
--- @param name string
--- @param attrs table
--- @param indent string|nil
--- @return string
function M.generate_set_line(name, attrs, indent)
  indent = indent or "  "

  if attrs.link then
    return string.format('%sset(0, "%s", { link = "%s" })', indent, name, attrs.link)
  end

  local parts = {}

  if attrs.fg then
    table.insert(parts, string.format('fg = "%s"', attrs.fg))
  end
  if attrs.bg then
    table.insert(parts, string.format('bg = "%s"', attrs.bg))
  end
  if attrs.sp then
    table.insert(parts, string.format('sp = "%s"', attrs.sp))
  end
  if attrs.blend then
    table.insert(parts, string.format("blend = %d", attrs.blend))
  end

  local bool_attrs = {
    "bold",
    "italic",
    "underline",
    "undercurl",
    "underdouble",
    "underdotted",
    "underdashed",
    "strikethrough",
    "reverse",
    "standout",
    "nocombine",
    "default",
  }

  for _, attr in ipairs(bool_attrs) do
    if attrs[attr] then
      table.insert(parts, attr .. " = true")
    end
  end

  local inner = table.concat(parts, ", ")
  return string.format('%sset(0, "%s", { %s })', indent, name, inner)
end

--- Save the edit buffer contents back to colorscheme source files.
--- @param bufnr number
function M.save(bufnr)
  local edit_buffer = require("commands.colors.edit_buffer")
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local index = M.build_source_index()

  -- Collect changes grouped by file
  local changes = {} -- filepath -> { { line: number, new_content: string } }
  local current_section = nil
  local warnings = {}

  for _, line in ipairs(lines) do
    local parsed = edit_buffer.parse_line(line)
    if not parsed then
      goto continue
    end

    if parsed.section then
      current_section = parsed.section
      goto continue
    end

    if not parsed.name then
      goto continue
    end

    local source = index[parsed.name]
    if not source then
      if current_section and current_section ~= "[runtime]" then
        table.insert(warnings, parsed.name .. ": not found in source files")
      end
      goto continue
    end

    local new_line = M.generate_set_line(parsed.name, parsed.attrs)
    local filepath = source.filepath

    if not changes[filepath] then
      changes[filepath] = {}
    end
    table.insert(changes[filepath], {
      line = source.line,
      new_content = new_line,
    })

    ::continue::
  end

  -- Apply changes to each file (process in reverse line order to preserve line numbers)
  for filepath, file_changes in pairs(changes) do
    local f = io.open(filepath, "r")
    if not f then
      error("Cannot open: " .. filepath)
    end
    local file_lines = {}
    for file_line in f:lines() do
      table.insert(file_lines, file_line)
    end
    f:close()

    -- Sort by line number descending so replacements don't shift indices
    table.sort(file_changes, function(a, b)
      return a.line > b.line
    end)

    for _, change in ipairs(file_changes) do
      file_lines[change.line] = change.new_content
    end

    f = io.open(filepath, "w")
    if not f then
      error("Cannot write: " .. filepath)
    end
    f:write(table.concat(file_lines, "\n") .. "\n")
    f:close()
  end

  if #warnings > 0 then
    vim.notify("Skipped (not in source):\n" .. table.concat(warnings, "\n"), vim.log.levels.WARN)
  end
end

--- Get the colorscheme directory path.
--- @return string
function M.get_colorscheme_dir()
  return COLORSCHEME_DIR
end

--- Get the list of source files.
--- @return table
function M.get_source_files()
  return SOURCE_FILES
end

return M
