local M = {}
M.ansi_codes = {}
M.ansi_colors = {
  -- the "\x1b" esc sequence causes issues
  -- with older Lua versions
  -- clear    = "\x1b[0m",
  clear = '[0m',
  bold = '[1m',
  italic = '[3m',
  underline = '[4m',
  black = '[0;30m',
  red = '[0;31m',
  green = '[0;32m',
  yellow = '[0;33m',
  blue = '[0;34m',
  magenta = '[0;35m',
  cyan = '[0;36m',
  white = '[0;37m',
  grey = '[0;90m',
  dark_grey = '[0;97m',
}

M.add_ansi_code = function(name, escseq)
  M.ansi_codes[name] = function(string)
    if string == nil or #string == 0 then
      return ''
    end
    return escseq .. string .. M.ansi_colors.clear
  end
end

for color, escseq in pairs(M.ansi_colors) do
  M.add_ansi_code(color, escseq)
end

local function hex2rgb(hexcol)
  local r, g, b = hexcol:match('#(..)(..)(..)')
  if not r or not g or not b then
    return
  end
  r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
  return r, g, b
end

local function synIDattr(hl, w)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl)), w)
end

function M.ansi_from_hl(hl, s, colormap)
  if vim.fn.hlexists(hl) == 1 then
    -- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#rgb-colors
    -- Set foreground color as RGB: 'ESC[38;2;{r};{g};{b}m'
    -- Set background color as RGB: 'ESC[48;2;{r};{g};{b}m'
    local what = {
      ['fg'] = { rgb = true, code = 38 },
      ['bg'] = { rgb = true, code = 48 },
      ['bold'] = { code = 1 },
      ['italic'] = { code = 3 },
      ['underline'] = { code = 4 },
      ['inverse'] = { code = 7 },
      ['reverse'] = { code = 7 },
      ['strikethrough'] = { code = 9 },
    }
    for w, p in pairs(what) do
      local escseq = nil
      if p.rgb then
        local hexcol = synIDattr(hl, w)
        if hexcol and not hexcol:match('^#') and colormap then
          -- try to acquire the color from the map
          -- some schemes don't capitalize first letter?
          local col = colormap[hexcol:sub(1, 1):upper() .. hexcol:sub(2)]
          if col then
            -- format as 6 digit hex for hex2rgb()
            hexcol = ('#%06x'):format(col)
          end
        end
        local r, g, b = hex2rgb(hexcol)
        if r and g and b then
          escseq = ('[%d;2;%d;%d;%dm'):format(p.code, r, g, b)
          -- elseif #hexcol>0 then
          --   print("unresolved", hl, w, hexcol, colormap[synIDattr(hl, w)])
        end
      else
        local value = synIDattr(hl, w)
        if value and tonumber(value) == 1 then
          escseq = ('[%dm'):format(p.code)
        end
      end
      if escseq then
        s = ('%s%s%s'):format(escseq, s, M.ansi_colors.clear)
      end
    end
  end
  return s
end

function M.strip_ansi_coloring(str)
  if not str then
    return str
  end
  -- remove escape sequences of the following formats:
  -- 1. ^[[34m
  -- 2. ^[[0;34m
  return str:gsub('%[[%d;]+m', '')
end

return M
