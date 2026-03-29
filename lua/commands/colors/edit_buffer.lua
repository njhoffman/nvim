local M = {}

local FILETYPE = "hledit"
local BOOL_ATTRS = {
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
local BOOL_SET = {}
for _, attr in ipairs(BOOL_ATTRS) do
  BOOL_SET[attr] = true
end

local active_bufnr = nil
local ns = vim.api.nvim_create_namespace("hledit")

--- Parse a single line from the edit buffer into a highlight definition.
--- Format: `GroupName fg=#hex bg=#hex sp=#hex bold italic link=Target blend=50`
--- Lines starting with # are section headers, empty lines are skipped.
--- @param line string
--- @return table|nil { name: string, attrs: table, section?: string }
function M.parse_line(line)
  if not line or line == "" then
    return nil
  end

  -- Section header
  if line:match("^#") then
    local section = line:match("^#%s*(.+)")
    return { section = vim.trim(section or "") }
  end

  -- Comment line (double --)
  if line:match("^%-%-") then
    return nil
  end

  local parts = {}
  for part in line:gmatch("%S+") do
    table.insert(parts, part)
  end

  if #parts == 0 then
    return nil
  end

  local name = parts[1]
  local attrs = {}

  for i = 2, #parts do
    local part = parts[i]
    local key, val = part:match("^(%w+)=(.+)$")

    if key and val then
      if key == "fg" or key == "bg" or key == "sp" then
        attrs[key] = val
      elseif key == "link" then
        attrs.link = val
      elseif key == "blend" then
        attrs.blend = tonumber(val)
      end
    elseif BOOL_SET[part] then
      attrs[part] = true
    end
  end

  return { name = name, attrs = attrs }
end

--- Format a highlight group name and its resolved attributes into edit buffer line format.
--- @param name string
--- @param hl table|nil Result from nvim_get_hl
--- @return string
function M.format_line(name, hl)
  if not hl or vim.tbl_isempty(hl) then
    return name
  end

  if hl.link then
    return name .. " link=" .. hl.link
  end

  local parts = { name }

  if hl.fg then
    local fg = type(hl.fg) == "number" and string.format("#%06x", hl.fg) or hl.fg
    table.insert(parts, "fg=" .. fg)
  end
  if hl.bg then
    local bg = type(hl.bg) == "number" and string.format("#%06x", hl.bg) or hl.bg
    table.insert(parts, "bg=" .. bg)
  end
  if hl.sp then
    local sp = type(hl.sp) == "number" and string.format("#%06x", hl.sp) or hl.sp
    table.insert(parts, "sp=" .. sp)
  end
  if hl.blend then
    table.insert(parts, "blend=" .. hl.blend)
  end

  for _, attr in ipairs(BOOL_ATTRS) do
    if hl[attr] then
      table.insert(parts, attr)
    end
  end

  return table.concat(parts, " ")
end

--- Apply a parsed highlight definition live.
--- @param parsed table { name: string, attrs: table }
local function apply_hl(parsed)
  if not parsed or not parsed.name then
    return
  end
  local ok, err = pcall(vim.api.nvim_set_hl, 0, parsed.name, parsed.attrs)
  if not ok then
    return err
  end
end

--- Apply a single line from the buffer.
--- @param bufnr number
--- @param lnum number 0-indexed line number
function M.apply_line(bufnr, lnum)
  local lines = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)
  if not lines[1] then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, lnum, lnum + 1)
  local parsed = M.parse_line(lines[1])
  if parsed and parsed.name then
    local err = apply_hl(parsed)
    if err then
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
        virt_text = { { " " .. err, "DiagnosticError" } },
        virt_text_pos = "eol",
      })
    end
  end
end

--- Re-parse and apply the entire edit buffer.
--- @param bufnr number|nil
function M.apply_all(bufnr)
  bufnr = bufnr or active_bufnr
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local parsed = M.parse_line(line)
    if parsed and parsed.name then
      local err = apply_hl(parsed)
      if err then
        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
          virt_text = { { " " .. err, "DiagnosticError" } },
          virt_text_pos = "eol",
        })
      end
    end
  end
end

--- Add color swatch extmarks to the edit buffer.
--- @param bufnr number
local function add_color_swatches(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local parsed = M.parse_line(line)
    if parsed and parsed.name and not parsed.attrs.link then
      local fg = parsed.attrs.fg
      if fg then
        local hl_name = "HlEditSwatch_" .. fg:gsub("#", "")
        pcall(vim.api.nvim_set_hl, 0, hl_name, { fg = fg })
        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
          virt_text = { { "██", hl_name } },
          virt_text_pos = "inline",
          priority = 10,
        })
      end
    end
  end
end

local debounce_timer = nil

--- Create or get the active edit buffer.
--- @return number bufnr
function M.create()
  if active_bufnr and vim.api.nvim_buf_is_valid(active_bufnr) then
    return active_bufnr
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].buftype = "acwrite"
  vim.bo[bufnr].filetype = FILETYPE
  vim.bo[bufnr].swapfile = false
  vim.api.nvim_buf_set_name(bufnr, "[Highlight Editor]")

  -- Live update on text change via buf_attach
  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function(_, buf, _, first, _, last)
      if not vim.api.nvim_buf_is_valid(buf) then
        return true
      end
      if debounce_timer then
        debounce_timer:stop()
      end
      debounce_timer = vim.defer_fn(function()
        for lnum = first, last - 1 do
          M.apply_line(buf, lnum)
        end
      end, 50)
    end,
  })

  -- Save handler: persist to colorscheme files
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = bufnr,
    callback = function()
      local persistence = require("commands.colors.persistence")
      local ok, err = pcall(persistence.save, bufnr)
      if ok then
        vim.bo[bufnr].modified = false
        vim.notify("Highlights saved to colorscheme files", vim.log.levels.INFO)
      else
        vim.notify("Failed to save: " .. tostring(err), vim.log.levels.ERROR)
      end
    end,
  })

  active_bufnr = bufnr
  return bufnr
end

--- Load highlight groups into the edit buffer.
--- @param groups table List of { name: string, source?: string } entries
--- @param opts table|nil { append?: boolean }
function M.load(groups, opts)
  opts = opts or {}
  local bufnr = M.create()

  -- Build source index for section headers
  local persistence = require("commands.colors.persistence")
  local source_index = persistence.build_source_index()

  -- Group by source file
  local by_source = {}
  local order = {}

  for _, group in ipairs(groups) do
    local source = group.source
    if not source then
      local idx = source_index[group.name]
      source = idx and idx.file or "[runtime]"
    end
    if not by_source[source] then
      by_source[source] = {}
      table.insert(order, source)
    end

    -- Check for duplicates if appending
    local dominated = false
    if opts.append then
      local existing = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for _, line in ipairs(existing) do
        local parsed = M.parse_line(line)
        if parsed and parsed.name == group.name then
          dominated = true
          break
        end
      end
    end
    if not dominated then
      table.insert(by_source[source], group.name)
    end
  end

  local lines = {}
  if opts.append then
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if #lines > 0 and lines[#lines] ~= "" then
      table.insert(lines, "")
    end
  end

  for _, source in ipairs(order) do
    local names = by_source[source]
    if #names > 0 then
      table.insert(lines, "# " .. source)
      for _, name in ipairs(names) do
        local hl = vim.api.nvim_get_hl(0, { name = name, link = true })
        table.insert(lines, M.format_line(name, hl))
      end
      table.insert(lines, "")
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modified = false

  return bufnr
end

--- Open the edit buffer in a split window.
--- @param groups table|nil
--- @param opts table|nil
function M.open(groups, opts)
  local bufnr
  if groups and #groups > 0 then
    bufnr = M.load(groups, opts)
  else
    bufnr = M.create()
  end

  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(0, bufnr)
  vim.cmd("resize " .. math.min(30, vim.api.nvim_buf_line_count(bufnr) + 2))

  add_color_swatches(bufnr)
end

--- Get the active buffer number.
--- @return number|nil
function M.get_bufnr()
  if active_bufnr and vim.api.nvim_buf_is_valid(active_bufnr) then
    return active_bufnr
  end
  return nil
end

return M
