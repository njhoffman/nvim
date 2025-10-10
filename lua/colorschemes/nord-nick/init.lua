---@diagnostic disable
--luacheck: ignore

local lush = require("lush")

local hl_files = { "main", "plugins", "nord-nvim" }

local loaded = {}
for _, hl_file in ipairs({ "main", "plugins", "nord-nvim" }) do
  local ok, hls = pcall(require, "colorschemes.nord-nick." .. hl_file)
  if ok then
    table.insert(loaded, { name = hl_file, highlights = hls })
  else
    vim.notify("Error loading " .. hl_file .. " highlight file\n" .. vim.inspect(hls), 4)
  end
end

-- local ok_main, hl_main = pcall(require, "colorschemes.nord-nick.main")
-- local ok_plugins, hl_plugins = pcall(require, "colorschemes.nord-nick.plugins")
-- local ok_nord, nord = pcall(require, "colorschemes.nord-nick.nord-nvim")

local colors = nil
for _, hl_idx in ipairs(vim.fn.reverse(vim.tbl_keys(loaded))) do
  local hl_name = loaded[hl_idx].name
  if colors == nil then
    colors = loaded[hl_idx].highlights
  else
    -- colors = lush.extends({ colors }).with(loaded[hl_key].highlights)

    local ok, res = pcall(lush.extends({ colors }).with, loaded[hl_idx].highlights)
    if not ok then
      vim.notify("Error merging highlights from: " .. hl_name .. "\n" .. vim.inspect(res), 4)
    else
      colors = res
    end
  end
end
return colors
-- local ok, err = pcall(lush.extends({ plugins }).with, hl_main)
-- vim.dbglog(ok, err)
-- local main = lush.extends({ plugins }).with(hl_main)
-- return main
-- Supports the following keys:
--
--   fg:    sets the `fg` property of a highlight group.
--          value must be a string, or respond to tostring().
--
--   bg:    sets the `bg` property of a highlight group.
--          value must be a string, or respond to tostring().
--
--   sp:    sets the `sp` property of a highlight group.
--          value must be a string, or respond to tostring().
--
--   blend: sets the `blend` property of a highlight group.
--          value must be an integer between 0 and 100.
--
--          note: you must have enabled blending in neovim via
--                `pumblend` or `winblend`!
--
--   gui:   a string containing any of the following format modifier
--          values, separated by space or comma.
--
--   bold:          boolean, enables or disables bold.
--   italic:        boolean, enables or disables italics.
--   underline:     boolean, enables or disables underline.
--   underlineline: boolean, enables or disables double underline.
--   underdouble:   boolean, underlineline in nvim 0.8
--   undercurl:     boolean, enables or disables undercurl.
--   underdot:      boolean, enables or disables underdot.
--   underdotted:   boolean, underdot in nvim 0.8
--   underdash:     boolean, enables or disables underdash.
--   underdashed:   boolean, underdash in nvim 0.8
--   strikethrough: boolean, enables or disables strikethrough.
--   reverse:       boolean, enables or disables flipping fg and bg values.
--   standout:      boolean, enables or disables standout.
--   nocombine:     boolean, enables or disables nocombine.
--
--   lush:  a namespace to save arbitrary data to a group. Is not
--          exported to the final highlight but may be accessed in
--          the lush-spec or the parsed-lush-spec.
-- Example - adding plugin support:
-- >
--   local lush = require('lush')
--   local hsl = lush.hsl
--
--   -- some colorscheme from the internet
--   local harbour = require('lush_colorscheme.harbour')
--
--   local spec = lush.extends({harbour}).with(function()
--     return {
--       -- make Sneak look like Search
--       Sneak { harbour.Search },
--       -- you can now use Sneak just like any other group (ref, inherit, etc)
--       SneakScope { bg = Sneak.bg.li(10) },
--       SneakLabel { Sneak, gui = "italic" },
--       -- you can use bits from anywhere
--       MixAndMatch { bg = harbour.Normal.fg, fg = SneakLabel.fg, gui = "underline" },
--     }
--   end)
--
--   return spec
-- <
-- Example - complex combination:
-- >
--   -- You may have installed this colorscheme via your package manager or similar
--   -- (good lush colorschemes should be portable), or you might be writing a variant
--   -- for your main colorscheme.
--   local some_colorscheme = require('lush_colorscheme.some_colorscheme')
--
--   -- Maybe you also want to include a community extension that patches
--   -- some missing styles in the original colorscheme.
--   local some_colorscheme_lsp = require('lush_colorscheme.some_colorscheme_lsp')
--
--   local spec = lush.extends({some_colorscheme, some_colorscheme_lsp}).with(function()
--     -- It is also valid to return an empty spec. This is functionally
--     -- equivalent to calling merge({some_colorscheme}).
--     -- return { }
--
--     return {
--       -- You can use the same group tools as normal: linking and group
--       -- inheritance, but you must access the groups through their imported
--       -- variables.
--
--       -- Inherit fg and gui settings, but adjust bg
--       Normal { some_colorscheme.Normal, bg = some_colorscheme.Normal.bg.li(10).sa(20) },
--
--       -- Overwrite comment group completely
--       Comment { fg = some_colorscheme.Normal.fg.da(10) },
--
--       -- link cursorline to normal
--       CursorLine { some_colorscheme.Normal }
--     }
--   end)
--
--   return spec
-- <
