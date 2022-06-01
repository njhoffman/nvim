-- :lua require('specs').toggle()
-- Toggle Specs on/off
local H = require "helpers"

local function exp_fader(blend, cnt)
  if blend + math.floor(math.exp(cnt / 10)) <= 100 then
    return blend + math.floor(math.exp(cnt / 10))
  else
    return nil
  end
end

local function constant_blend(blend, cnt)
  -- Simple constant blend effect
  if cnt > 100 then
    return 80
  else
    return nil
  end
end

local function grow_to_right(width, ccol, cnt)
  if width - cnt > 0 then
    return { width + cnt, ccol }
  else
    return nil
  end
end

local function shrink_resizer(width, ccol, cnt)
  if width - cnt > 0 then
    print(width - cnt .. " " .. ccol - (width - cnt) / 2 + 1)
    return { width - cnt, ccol - (width - cnt) / 2 + 1 }
  else
    return nil
  end
end

local function pulse_fader(blend, cnt)
  if cnt < (100 - blend) / 2 then
    return cnt
  elseif cnt < 100 - blend then
    return 100 - cnt
  else
    return nil
  end
end

local custom_config = {
  show_jumps = true,
  min_jump = 10,
  popup = { winhl = "SpecsCursor", fader = exp_fader, resizer = shrink_resizer },
  ignore_filetypes = {},
  ignore_buftypes = { nofile = true, nowrite, quickfix, terminal, prompt }
}

local wide_config = {
  show_jumps = true,
  min_jump = 10,
  popup = {
    delay_ms = 0, -- delay before popup displays
    inc_ms = 50, -- time increments used for fade/resize effects
    blend = 0, -- starting blend, between 0-100 (fully transparent), see :h winblend
    width = 40,
    winhl = "SpecsCursor",
    fader = constant_blend,
    resizer = shrink_resizer
  },
  ignore_filetypes = {},
  ignore_buftypes = { nofile = true, nowrite = true, quickfix = true, terminal = true, prompt = true }
}

local quick_config = {
  show_jumps = true,
  min_jump = 5,
  delay_ms = 0, -- delay before popup displays
  inc_ms = 3, -- time increments used for fade/resize effects
  blend = 0, -- starting blend, between 0-100 (fully transparent), see :h winblend
  width = 50,
  winhl = "Cursor",
  fader = function(start_blend, cnt)
    local blend = start_blend + math.floor(math.exp(cnt / 10))
    if blend <= 100 then
      return blend
    else
      return nil
    end
  end,
  resizer = function(base_width, cursor_col, count)
    if count <= 100 then
      local factor = count / 100
      if count > 50 then
        factor = 1 - factor
      end
      local width = math.floor(base_width * factor)
      return { width, cursor_col - (width / 2) }
    else
      return nil
    end
  end
}

local default_config = {
  show_jumps = true,
  min_jump = 10,
  popup = {
    delay_ms = 5, -- delay before popup displays
    inc_ms = 10, -- time increments used for fade/resize effects
    blend = 60, -- starting blend, between 0-100 (fully transparent), see :h winblend
    width = 15,
    winhl = "SpecsCursor",
    fader = require("specs").exp_fader,
    resizer = require("specs").shrink_resizer
  },
  ignore_filetypes = { "" },
  ignore_buftypes = { nofile = true, nowrite, quickfix, terminal, prompt }
}

require("specs").setup(default_config)

-- Faders:
--   linear_fader ▁▂▂▃▃▄▄▅▅▆▆▇▇██
--   exp_fader ▁▁▁▁▂▂▂▃▃▃▄▄▅▆▇
--   pulse_fader ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁
--   empty_fader ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
-- Resizers:
--   shrink_resizer ░░▒▒▓█████▓▒▒░░
--   slide_resizer ████▓▓▓▒▒▒▒░░░░
--   empty_resizer ███████████████
