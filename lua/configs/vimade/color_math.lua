local M = {}

local bit = require("bit")
local BIT_BAND = bit.band
local BIT_LSHIFT = bit.lshift
local BIT_RSHIFT = bit.rshift
local MATH_FLOOR = math.floor
local MATH_MAX = math.max
local MATH_MIN = math.min

-- Import vimade's color utilities for base operations.
local vimade_color = require("vimade.util.color")
M.to24b = vimade_color.to24b
M.toRgb = vimade_color.toRgb
M.interpolate24b = vimade_color.interpolate24b

-- Extract RGB components from a 24-bit color integer.
M.extract_rgb = function(color)
  local r = BIT_RSHIFT(BIT_BAND(color, 0xFF0000), 16)
  local g = BIT_RSHIFT(BIT_BAND(color, 0x00FF00), 8)
  local b = BIT_BAND(color, 0x0000FF)
  return r, g, b
end

-- Pack RGB components into a 24-bit color integer.
M.pack_rgb = function(r, g, b)
  r = MATH_MAX(0, MATH_MIN(255, MATH_FLOOR(r)))
  g = MATH_MAX(0, MATH_MIN(255, MATH_FLOOR(g)))
  b = MATH_MAX(0, MATH_MIN(255, MATH_FLOOR(b)))
  return BIT_LSHIFT(r, 16) + BIT_LSHIFT(g, 8) + b
end

-- Convert RGB (0-255) to HSL (h: 0-360, s: 0-1, l: 0-1).
M.rgb_to_hsl = function(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max = MATH_MAX(r, g, b)
  local min = MATH_MIN(r, g, b)
  local h, s
  local l = (max + min) / 2

  if max == min then
    h = 0
    s = 0
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h * 60
  end
  return h, s, l
end

-- Convert HSL (h: 0-360, s: 0-1, l: 0-1) to RGB (0-255).
M.hsl_to_rgb = function(h, s, l)
  if s == 0 then
    local v = MATH_FLOOR(l * 255)
    return v, v, v
  end

  local hue_to_rgb = function(p, q, t)
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

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  local hn = h / 360

  local r = hue_to_rgb(p, q, hn + 1 / 3)
  local g = hue_to_rgb(p, q, hn)
  local b = hue_to_rgb(p, q, hn - 1 / 3)

  return MATH_FLOOR(r * 255 + 0.5), MATH_FLOOR(g * 255 + 0.5), MATH_FLOOR(b * 255 + 0.5)
end

-- Lighten a 24-bit color by `amount` (0-1). 1.0 = full white.
M.lighten = function(color, amount)
  return M.interpolate24b(color, 0xFFFFFF, 1 - amount)
end

-- Darken a 24-bit color by `amount` (0-1). 1.0 = full black.
M.darken = function(color, amount)
  return M.interpolate24b(color, 0x000000, 1 - amount)
end

-- Adjust saturation of a 24-bit color.
-- `amount` > 0 increases saturation, < 0 decreases. Range: -1 to 1.
M.saturate = function(color, amount)
  local r, g, b = M.extract_rgb(color)
  local h, s, l = M.rgb_to_hsl(r, g, b)
  s = MATH_MAX(0, MATH_MIN(1, s + amount))
  r, g, b = M.hsl_to_rgb(h, s, l)
  return M.pack_rgb(r, g, b)
end

-- Shift hue of a 24-bit color by `degrees` (-360 to 360).
M.hue_shift = function(color, degrees)
  local r, g, b = M.extract_rgb(color)
  local h, s, l = M.rgb_to_hsl(r, g, b)
  h = (h + degrees) % 360
  if h < 0 then
    h = h + 360
  end
  r, g, b = M.hsl_to_rgb(h, s, l)
  return M.pack_rgb(r, g, b)
end

-- Apply a set of transforms to a 24-bit color.
-- `transforms` is a table like { lighten = 0.2, darken = 0.1, saturate = 0.3, hue = 90 }.
M.apply_transforms = function(color, transforms)
  if not transforms or not color then
    return color
  end
  if transforms.lighten then
    color = M.lighten(color, transforms.lighten)
  end
  if transforms.darken then
    color = M.darken(color, transforms.darken)
  end
  if transforms.saturate then
    color = M.saturate(color, transforms.saturate)
  end
  if transforms.hue then
    color = M.hue_shift(color, transforms.hue)
  end
  return color
end

-- Derived highlight cache.
-- Key: "original_group:transform_key" -> derived hl group name
local hl_cache = {}
local cache_counter = 0

-- Build a stable key from a transforms table.
M._transform_key = function(transforms)
  local parts = {}
  if transforms.lighten then
    parts[#parts + 1] = "l" .. transforms.lighten
  end
  if transforms.darken then
    parts[#parts + 1] = "d" .. transforms.darken
  end
  if transforms.saturate then
    parts[#parts + 1] = "s" .. transforms.saturate
  end
  if transforms.hue then
    parts[#parts + 1] = "h" .. transforms.hue
  end
  return table.concat(parts, ":")
end

-- Get or create a derived highlight group with transforms applied.
-- Returns the highlight group name.
M.get_derived_hl = function(hl_group, transforms)
  local tkey = M._transform_key(transforms)
  local cache_key = hl_group .. ":" .. tkey
  if hl_cache[cache_key] then
    return hl_cache[cache_key]
  end

  -- Resolve the original highlight.
  local hl_def = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
  if vim.tbl_isempty(hl_def) then
    return hl_group
  end

  -- Apply transforms to fg, bg, sp.
  local new_def = vim.deepcopy(hl_def)
  if new_def.fg then
    new_def.fg = M.apply_transforms(new_def.fg, transforms)
  end
  if new_def.bg then
    new_def.bg = M.apply_transforms(new_def.bg, transforms)
  end
  if new_def.sp then
    new_def.sp = M.apply_transforms(new_def.sp, transforms)
  end

  -- Create the derived highlight group.
  cache_counter = cache_counter + 1
  local derived_name = "VimadeDerived" .. cache_counter
  vim.api.nvim_set_hl(0, derived_name, new_def)

  hl_cache[cache_key] = derived_name
  return derived_name
end

-- Clear the derived highlight cache (call on ColorScheme change).
M.clear_cache = function()
  hl_cache = {}
  cache_counter = 0
end

-- Set up autocmd to clear cache on colorscheme change.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("vimade_color_math", { clear = true }),
  callback = M.clear_cache,
})

return M
