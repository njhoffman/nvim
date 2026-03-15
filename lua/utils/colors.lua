-- https://github.com/psliwka/termcolors.nvim/blob/master/lua/termcolors.lua

local vivid = require('utils.colors-vivid')

local termcolors = {}

local function color_from_syntax(name, type)
  type = type or 'fg'
  local result = vim.api.nvim_eval('synIDattr(synIDtrans(hlID("' .. name .. '")), "' .. type .. '#")')
  if result == '' then
    return nil
  else
    return result
  end
end

local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent)
  return math.floor(attr * (100 + percent) / 100)
end

local function ordered_table(t)
  local current_index = 1
  local metatable = {}
  function metatable:__newindex(key, value)
    rawset(self, key, value)
    rawset(self, current_index, key)
    current_index = current_index + 1
  end

  return setmetatable(t or {}, metatable)
end

local function ordered_pairs(t)
  local current_index = 0
  local function iter(t)
    current_index = current_index + 1
    local key = t[current_index]
    if key then
      return key, t[key]
    end
  end

  return iter, t
end

local function is_light()
  return vim.opt.background:get() == 'light'
end

function termcolors.scrape_current_colorscheme()
  local colors = ordered_table({})
  colors.foreground = color_from_syntax('Normal', 'fg')
  colors.background = color_from_syntax('Normal', 'bg')
  for i = 0, 255 do
    colors['color' .. i] = vim.g['terminal_color_' .. i]
  end
  colors.cursor = color_from_syntax('cursor', 'bg') or colors.foreground
  colors.cursor_text_color = color_from_syntax('cursor', 'fg') or colors.background
  colors.url_color = color_from_syntax('url')
  colors.selection_foreground = color_from_syntax('Visual', 'fg') or 'none'
  colors.selection_background = color_from_syntax('Visual', 'bg')
  colors.tab_bar_background = termcolors.shade_color(colors.background, is_light() and -20 or -45)
  colors.active_tab_foreground = colors.foreground
  colors.active_tab_background = colors.background
  colors.inactive_tab_foreground = color_from_syntax('Comment', 'fg')
  colors.inactive_tab_background = termcolors.shade_color(colors.background, is_light() and -12 or -25)
  colors.active_border_color = color_from_syntax('TabLineSel')
  colors.inactive_border_color = color_from_syntax('VertSplit')
  colors.bell_border_color = color_from_syntax('TextWarning')

  local cleaned_colors = ordered_table({})
  for setting_name, setting_value in ordered_pairs(colors) do
    if setting_value ~= nil then
      cleaned_colors[setting_name] = string.lower(setting_value)
    end
  end
  return cleaned_colors
end

function termcolors.shade_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then
    return 'NONE'
  end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return string.format('#%02x%02x%02x', r, g, b)
end

function termcolors.generate_kitty_config()
  local config = { '# Put the following lines in your ~/.config/kitty/kitty.conf' }
  for setting_name, setting_value in ordered_pairs(termcolors.scrape_current_colorscheme()) do
    table.insert(config, setting_name .. ' ' .. setting_value)
  end
  return config
end

function termcolors.show()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, 'Termcolors')
  vim.api.nvim_buf_set_lines(buf, 0, 1, true, termcolors.generate_kitty_config())
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'conf'
  vim.cmd('buffer ' .. buf)
end

function termcolors.get_color_from_hl(name)
  local result = {}
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  for k, v in pairs(hl) do
    if type(v) == "number" then
      result[k] = string.format('#%06x', v)
    end
  end
  return result
end

function termcolors.clamp_color(color)
  return math.max(math.min(color, 255), 0)
end

function termcolors.to_rgb(color)
  return tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6), 16)
end

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and l in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSL representation
]]
function rgbToHsl(r, g, b, a)
  r, g, b = r / 255, g / 255, b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    local s
    if l > 0.5 then
      s = d / (2 - max - min)
    else
      s = d / (max + min)
    end
    if max == r then
      h = (g - b) / d
      if g < b then
        h = h + 6
      end
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l, a or 255
end

--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  Array           The RGB representation
]]
function hslToRgb(h, s, l, a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q
    if l < 0.5 then
      q = l * (1 + s)
    else
      q = l + s - l * s
    end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return r * 255, g * 255, b * 255, a * 255
end

--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then
    s = 0
  else
    s = d / max
  end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
      h = (g - b) / d
      if g < b then
        h = h + 6
      end
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)

  i = i % 6

  if i == 0 then
    r, g, b = v, t, p
  elseif i == 1 then
    r, g, b = q, v, p
  elseif i == 2 then
    r, g, b = p, v, t
  elseif i == 3 then
    r, g, b = p, q, v
  elseif i == 4 then
    r, g, b = t, p, v
  elseif i == 5 then
    r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

function termcolors.desaturate(hex, pct)
  local r, g, b = termcolors.to_rgb(hex)
  vim.dbglog(hex, r, g, b)
  local hsv = { rgbToHsv(r, g, b, 255) }
  -- local newrgb = { vivid.HSVtoRGB(h, s - pct, v, a) }
  -- vim.dbglog(h, s, v, a)
  pct = pct > 1 and pct / 100 or pct
  local newhsv = { hsv[1], hsv[2] - pct, hsv[3], 1 }
  newhsv[1] = newhsv[1] * 360
  local newrgb = { hsvToRgb(unpack(newhsv)) }
  vim.dbglog('new', newrgb)
end

function termcolors.darken(color, percent)
  local r, g, b = termcolors.to_rgb(color)
  if type(r) ~= 'nil' and type(g) ~= 'nil' and type(b) ~= 'nil' then
    r = termcolors.clamp_color(math.floor(tonumber(r * (100 - percent) / 100) or r))
    g = termcolors.clamp_color(math.floor(tonumber(g * (100 - percent) / 100) or g))
    b = termcolors.clamp_color(math.floor(tonumber(b * (100 - percent) / 100) or b))
  end
  local new_color = '#' .. string.format('%0x', r) .. string.format('%0x', g) .. string.format('%0x', b)
  if #new_color == 6 then
    new_color = '#0' .. string.format('%0x', r) .. string.format('%0x', g) .. string.format('%0x', b)
  end

  return new_color
end

-- vim.dbglog(termcolors.desaturate("#802020", 30))
return termcolors
