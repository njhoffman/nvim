# nvim-hlslens lens templating

Notes for templating the hlslens virtual text (fork at `~/git/nvim-hlslens`).

I want to enable templating the hlslens virtual text.
There will be three modes:

- default: base template that can be shared between all modes
- near: template for the virtual text lens of of matches that are near the cursor but not the nearest
- nearest: template for the virtual text lens of of the nearest match

HlSearchNear CurSearch rename to HlSearchCur
HlSearchLens WildMenu rename to HlSearchLens
HlSearchLensNear CurSearch rename to HlSearchLensCur

HlSearch IncSearch rename to HlSearch

```lua

  render = render_formats(formats.default, formats.nearest, formats.near),
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
local render_formats = function(default_fmt, nearest_fmt, near_fmt)
  return function(render, plist, nearest, idx, r_idx)
    if nearest then
      return override_lens_2(render, plist, nearest, idx, r_idx)
    else
      return override_lens(render, plist, nearest, idx, r_idx)
    end
  end
end

local formats = {
  default = {
    { "", "HlSearchReversed" },
    { "%icon%", "HlSearchIcon" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "/", "HlSearch" },
    { "%total%", "HlSearchTotal" },
    { "", "HlSearchReversed" },
  },
  nearest = {
    { "", "HlSearchReversed" },
    { "%indicator%", "HlSearchIndicator}" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "", "HlSearchReversed" },
  },
  near = {
    { "", "HlSearchReversed" },
    { "%indicator%", "HlSearchIndicator}" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "", "HlSearchReversed" },
  },
}
```
