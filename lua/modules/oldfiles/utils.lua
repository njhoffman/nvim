local function round(x, n)
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then
    x = math.floor(x + 0.5)
  else
    x = math.ceil(x - 0.5)
  end
  return x / n
end

local time_labels = {
  { '  secs', '  mins', ' hours', '  days', ' weeks', ' month', ' years' },
  { ' s', ' m', ' h', ' d', ' w', ' M', ' Y' },
  { ' sec', ' min', ' hrs', ' day', ' wks', ' mon', ' yrs' },
}

local function time_ago(time)
  local now = os.time()
  local diff_seconds = os.difftime(now, time)
  local labels = time_labels[3]

  if diff_seconds < 90 then
    return round(diff_seconds) .. labels[1]
  end
  local diff_minutes = diff_seconds / 60
  if diff_minutes < 59.5 then
    return round(diff_minutes) .. labels[2]
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 23.5 then
    return round(diff_hours) .. labels[3]
  end

  local diff_days = diff_hours / 24
  if diff_days < 7.5 then
    return round(diff_days) .. labels[4]
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 4.5 then
    return round(diff_weeks) .. labels[5]
  end

  local diff_months = diff_days / 30
  if diff_months < 11.5 then
    return round(diff_months) .. labels[6]
  end

  local diff_years = diff_days / 365.25
  return round(diff_years) .. labels[7]
end

local file_size = function(size, path)
  local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
  local index = 1

  local fsize = size or vim.fn.getfsize(path or vim.api.nvim_buf_get_name(0))

  if fsize < 0 then
    fsize = 0
  end

  while fsize > 1024 and index < 7 do
    fsize = fsize / 1024
    index = index + 1
  end

  return string.format(index == 1 and '%g%s' or '%.2f%s', fsize, suffix[index])
end

---@param text string
---@param max_length number
---@return string
local truncate = function(text, max_length)
  if vim.api.nvim_strwidth(text) > max_length then
    return string.sub(text, 1, max_length - 1) .. '…'
  end
  return text
end

---@param text string
---@param length number
---@param align "'left'" | "'center'" | "'right'"|nil
---@param gap_char string|nil
---@return string
local align = function(text, length, align, gap_char)
  text = tostring(text)
  align = align or 'left'
  gap_char = gap_char or ' '

  local gap_length = length - vim.api.nvim_strwidth(text)

  local gap_left = ''
  local gap_right = ''

  if align == 'left' then
    gap_right = string.rep(gap_char, gap_length)
  elseif align == 'center' then
    gap_left = string.rep(gap_char, math.ceil(gap_length / 2))
    gap_right = string.rep(gap_char, math.floor(gap_length / 2))
  elseif align == 'right' then
    gap_left = string.rep(gap_char, gap_length)
  end

  return gap_left .. text .. gap_right
end

local file_exists = function(path)
  local f = io.open(path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
  return false
end

return {
  align = align,
  truncate = truncate,
  file_size = file_size,
  time_ago = time_ago,
  file_exists = file_exists,
}
