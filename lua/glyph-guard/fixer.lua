local M = {}
local escape = require("glyph-guard.escape")

local function comment_prefix(ft)
  if ft == "lua" then
    return "--"
  end
  return "#"
end

local function group_by_line(findings)
  local map = {}
  for _, f in ipairs(findings) do
    map[f.lnum] = map[f.lnum] or {}
    table.insert(map[f.lnum], f)
  end
  return map
end

local function parse_comment(line, prefix)
  local idx = line:find(prefix, 1, true)
  if not idx then
    return line, nil, nil
  end
  local code = line:sub(1, idx - 1)
  local rest = line:sub(idx + #prefix)
  if rest:sub(1, 1) == " " then
    rest = rest:sub(2)
  end

  local gs = rest:find("U%+%x+")
  if not gs then
    local base = vim.trim(rest)
    return code, base ~= "" and base or nil, nil
  end

  local candidate = rest:sub(gs)
  if not candidate:match("^U%+%x+%s+%S") then
    local base = vim.trim(rest)
    return code, base ~= "" and base or nil, nil
  end

  local s = gs - 1
  while s >= 1 do
    local c = rest:sub(s, s)
    if c == " " or c == "\t" or c == "|" then
      s = s - 1
    else
      break
    end
  end
  local base = vim.trim(rest:sub(1, s))
  return code, base ~= "" and base or nil, candidate
end

M.parse_comment = parse_comment

function M.apply_buffer(buf, findings, cfg)
  local lines = group_by_line(findings)
  local ft = vim.bo[buf].filetype
  local prefix = comment_prefix(ft)
  local lang = escape.lang_of(ft)

  for lnum, items in pairs(lines) do
    table.sort(items, function(a, b)
      return a.col > b.col
    end)

    local warn_nonportable = false
    for _, f in ipairs(items) do
      local repl, warn = escape.replacement(f, lang)
      if warn then
        warn_nonportable = true
      end
      vim.api.nvim_buf_set_text(buf, lnum - 1, f.col, lnum - 1, f.col + f.size, { repl })
    end

    local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
    local code, base = parse_comment(line, prefix)

    table.sort(items, function(a, b)
      return a.col < b.col
    end)

    local seen, parts = {}, {}
    for _, f in ipairs(items) do
      if not seen[f.cp] then
        seen[f.cp] = true
        table.insert(parts, f.codepoint .. " " .. f.char)
      end
    end
    local glyph_part = table.concat(parts, " ")

    code = code:gsub("%s+$", "")
    local new_line
    if base then
      new_line = code .. " " .. prefix .. " " .. base .. " | " .. glyph_part
    else
      new_line = code .. " " .. prefix .. " " .. glyph_part
    end
    if warn_nonportable then
      new_line = new_line .. " | WARN non-portable escape"
    end

    vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { new_line })
  end
end

return M
