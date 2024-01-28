local M = {}

-- base64 character table string
local b64_lookup_table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

if not debug then
  _G['debug'] = {
    traceback = function(msg)
      return msg
    end,
  }
end

local function max_len_line(lines)
  local max_len = 0

  for _, line in ipairs(lines) do
    local line_len = line:len()
    if line_len > max_len then
      max_len = line_len
    end
  end

  return max_len
end

function M.split_components(str, pattern)
  assert(type(str) == type(''), debug.traceback('Invalid type for str: ' .. type(str)))
  assert(type(pattern) == type(''), debug.traceback('Invalid type for pattern: ' .. type(pattern)))
  local t = {}
  for v in string.gmatch(str, pattern) do
    t[#t + 1] = v
  end
  return t
end

function M.split(str, sep, plain)
  assert(type(str) == type(''), debug.traceback('Invalid type for str: ' .. type(str)))
  assert(sep == nil or type(sep) == type(''), debug.traceback('Invalid type for sep: ' .. type(sep)))
  assert(plain == nil or type(plain) == type(true), debug.traceback('Invalid type for plain: ' .. type(plain)))

  sep = sep or '%s'
  local t = {}
  for s in string.gmatch(str, '([^' .. sep .. ']+)') do
    table.insert(t, s)
  end
  return t
end

function M.str_to_clean_tbl(cmd_string)
  return require('utils.tables').str_to_clean_tbl(cmd_string)
end

function M.empty(str)
  return str == ''
end

function M.trim(str)
  return str:gsub('^%s*', ''):gsub('%s*$', '')
end

function M.capitalize(str)
  if #str == 1 or #str == 0 then
    return #str == 0 and str or str:upper()
  end
  return str:sub(1, 1):upper() .. str:sub(2, #str):lower()
end

-- NOTE: took from http://lua-users.org/wiki/BaseSixtyFour
function M.base64_encode(data)
  return (
    (data:gsub('.', function(x)
      local r, b = '', x:byte()
      for i = 8, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
      end
      return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
      if #x < 6 then
        return ''
      end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
      end
      return b64_lookup_table:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1]
  )
end

-- NOTE: took from http://lua-users.org/wiki/BaseSixtyFour
function M.base64_decode(data)
  data = string.gsub(data, '[^' .. b64_lookup_table .. '=]', '')
  return (
    data
      :gsub('.', function(x)
        if x == '=' then
          return ''
        end
        local r, f = '', (b64_lookup_table:find(x) - 1)
        for i = 6, 1, -1 do
          r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
      end)
      :gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then
          return ''
        end
        local c = 0
        for i = 1, 8 do
          c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
      end)
  )
end

--- Left align lines relatively to the parent container
-- @param container The container where lines will be displayed
-- @param lines The text to align
-- @param alignment The alignment value, range: [0-1]
function M.align_left(container, lines, alignment)
  local max_len = max_len_line(lines)
  local indent_amount = math.ceil(math.max(container.width - max_len, 0) * alignment)
  return M.shift_right(lines, indent_amount)
end

--- Center align lines relatively to the parent container
-- @param container The container where lines will be displayed
-- @param lines The text to align
-- @param alignment The alignment value, range: [0-1]
function M.align_center(container, lines, alignment)
  local output = {}
  local max_len = max_len_line(lines)

  for _, line in ipairs(lines) do
    local padding = string.rep(' ', (math.max(container.width, max_len) - line:len()) * alignment)
    table.insert(output, padding .. line)
  end

  return output
end

--- Shift lines by a given amount
-- @params lines The lines the shift
-- @param amount The amount of spaces to add
function M.shift_right(lines, amount)
  local output = {}
  local padding = string.rep(' ', amount)

  for _, line in ipairs(lines) do
    table.insert(output, padding .. line)
  end

  return output
end

--- Pretty format tables
-- @param entries The table to format
-- @param col_count The number of column to span the table on
-- @param col_sep The separator between each column, default: " "
function M.format_table(entries, col_count, col_sep)
  col_sep = col_sep or ' '

  local col_rows = math.ceil(vim.tbl_count(entries) / col_count)
  local cols = {}
  local count = 0

  for i, entry in ipairs(entries) do
    if ((i - 1) % col_rows) == 0 then
      table.insert(cols, {})
      count = count + 1
    end
    table.insert(cols[count], entry)
  end

  local col_max_len = {}
  for _, col in ipairs(cols) do
    table.insert(col_max_len, max_len_line(col))
  end

  local output = {}
  for i, col in ipairs(cols) do
    for j, entry in ipairs(col) do
      if not output[j] then
        output[j] = entry
      else
        local padding = string.rep(' ', col_max_len[i - 1] - cols[i - 1][j]:len())
        output[j] = output[j] .. padding .. col_sep .. entry
      end
    end
  end

  return output
end

return M
