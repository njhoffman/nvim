local col = function(strlist, opts)
  -- strlist is a TABLE of TABLES, representing columns of text
  -- opts is a text display option

  -- column spacing
  local padding = 12
  -- fill lines up to the maximim length with 'fillchar'
  local fillchar = ' '
  -- columns padding char (for testing)
  local padchar = ' '

  -- define maximum string length in a table
  local maxlen = function(str)
    local max = 0
    for i in pairs(str) do
      if #str[i] > max then
        max = #str[i]
      end
    end
    return max
  end

  -- add as much right-padding to align the text block
  local pad = function(str, max)
    local strlist = {}
    for i in pairs(str) do
      if #str[i] < max then
        local newstr = str[i] .. string.rep(fillchar, max - #str[i])
        table.insert(strlist, newstr)
      else
        table.insert(strlist, str[i])
      end
    end
    return strlist
  end

  -- this is a table for text strings
  local values = {}
  -- process all the lines
  for i = 1, maxlen(strlist) do
    local str = ''
    -- process all the columns but last, because we dont wand extra padding
    -- after last column
    for column = 1, #strlist - 1 do
      local maxstr = maxlen(strlist[column])
      local padded = pad(strlist[column], maxstr)
      if strlist[column][i] == nil then
        str = str .. string.rep(fillchar, maxstr) .. string.rep(padchar, padding)
      else
        str = str .. padded[i] .. string.rep(padchar, padding)
      end
    end

    -- lets process the last column, no extra padding
    do
      local maxstr = maxlen(strlist[#strlist])
      local padded = pad(strlist[#strlist], maxstr)
      if strlist[#strlist][i] == nil then
        str = str .. string.rep(fillchar, maxlen(strlist[#strlist]))
      else
        str = str .. padded[i]
      end
    end

    -- insert result into output table
    table.insert(values, { type = 'text', val = str, opts = opts })
  end

  return values
end

local function lineToStartGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    table.insert(out, { hi = 'StartLogo' .. i, line = line })
  end
  return out
end

local function lineToStartPopGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local hi = 'StartLogo' .. i
    if i <= 6 then
      hi = 'StartLogo' .. i + 6
    elseif i > 6 and i <= 12 then
      hi = 'StartLogoPop' .. i - 6
    end
    table.insert(out, { hi = hi, line = line })
  end
  return out
end

local function lineToStartShiftGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local n = i
    if i > 6 and i <= 12 then
      n = i + 6
    elseif i > 12 then
      n = i - 6
    end
    table.insert(out, { hi = 'StartLogo' .. n, line = line })
  end
  return out
end

-- local cool = lineToStartPopGradient(coolLines)
-- local robust = lineToStartShiftGradient(robustLines)
-- local efficient = lineToStartGradient(efficientLines)
--
-- local headers = { cool, robust, efficient }
--
-- local function header_chars()
--   math.randomseed(os.time())
--   return headers[math.random(#headers)]
-- end
--
-- -- Map over the headers, setting a different color for each line.
-- -- This is done by setting the Highligh to StartLogoN, where N is the row index.
-- -- Define StartLogo1..StartLogoN to get a nice gradient.
-- local function header_color()
--   local lines = {}
--   for i, lineConfig in pairs(header_chars()) do
--     local hi = lineConfig.hi
--     local line_chars = lineConfig.line
--     local line = {
--       type = 'text',
--       val = line_chars,
--       opts = {
--         hl = hi,
--         shrink_margin = false,
--         position = 'center',
--       },
--     }
--     table.insert(lines, line)
--   end
--
--   local output = {
--     type = 'group',
--     val = lines,
--     opts = { position = 'center' },
--   }
--
--   return output
-- end

return { col = col }
