local styles = {
  bubble = { { "", "HlSearchReversed" }, { "", "HlSearchReversed" } },
  arrow = {
    { "", "HlSearchReversed" },
    { "", "HlSearchReversed" },
  },
  none = {
    { " ", "Ignore" },
    { " ", "Ignore" }, -- = padding
  },
}

local lens_style = "bubble" -- bubble/arrows/none

local override_lens = function(render, posList, nearest, idx, _)
  -- formats virtual text as a bubble
  local lnum, col = unpack(posList[idx])
  local text = ("%d/%d"):format(idx, #posList)
  local chunks = { styles[lens_style][1], { text, "HlSearchLens" }, styles[lens_style][2] }
  render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
end

local override_lens_2 = function(render, plist, nearest, idx, r_idx)
  local sfw = vim.v.searchforward == 1
  local indicator, text, chunks
  local abs_r_idx = math.abs(r_idx)
  if abs_r_idx > 1 then
    indicator = string.format("%d%s", abs_r_idx, sfw ~= (r_idx > 1) and "󰁞" or "󰁆")
  elseif abs_r_idx == 1 then
    indicator = sfw ~= (r_idx == 1) and "󰁞" or "󰁆"
  else
    indicator = ""
  end

  local lnum, col = unpack(plist[idx])
  if nearest then
    local cnt = #plist
    if indicator ~= "" then
      text = string.format("[%s %d/%d]", indicator, idx, cnt)
    else
      text = string.format("[%d/%d]", idx, cnt)
    end
    chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
  else
    text = string.format("[%s %d]", indicator, idx)
    chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
  end
  render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
end

local hlslens_config = {
  -- render = render_formats(formats.default, formats.nearest, formats.near),
  -- override_lens = override_lens_2,
  float_shadow_blend = 50,
  auto_enable = true,
  calm_down = true,
  nearest_only = false,
  nearest_float_when = "auto",
  virt_priority = 100,
  build_position_cb = function(plist, _, _, _)
    require("satellite.handlers.search").handler.show(plist.start_pos)
  end,
}
require("hlslens").setup(hlslens_config)
