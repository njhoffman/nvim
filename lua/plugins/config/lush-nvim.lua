-- vim.cmd[[
--   set background=dark
--   let g:colors_name="nord-nick"
-- ]]
--   -- cool_name/lua/lush_colorscheme/cool_name.lua
--   -- require lush
--   local lush = require('lush')
--   -- lush(), when given a spec, will parse it and return a table
--   -- containing your color information.
--   -- We should return it for use in other files.
--   return lush(function()
--     return {
--       -- Define what vims Normal highlight group should look like
--       Normal { bg = lush.hsl(208, 90, 30), fg = lush.hsl(208, 80, 80) },
--       -- And make whitespace slightly darker than normal.
--       -- Note you must define Normal before you try to use it.
--       Whitespace { fg = Normal.fg.darken(40) },
--       -- And make comments look the same, but with italic text
--       Comment { Whitespace, gui="italic" },
--       -- and clear all highlighting for CursorLine
--       CursorLine { },
--     }
--   end)
-- <
--
-- And the corresponding colorscheme loading file for nvim:
-- >
--   " cool_name/colors/cool_name.vim
--   " yes, unfortunately you still have to write some Vim Script
--   set background=dark
--   let g:colors_name="cool_name"
--   " you could detect background == dark || light here and require
--   " different files
--   lua require('lush')(require('lush_colorscheme.cool_name'))
-- <
--
-- require('lush')(require('lush_colorscheme.nord-nick'))

vim.cmd([[
  try
    colorscheme nord-nick
    set background=dark
  " hi Normal guibg=none ctermbg=none
  " hi LineNr guibg=none ctermbg=none
  " hi Folded guibg=none ctermbg=none
  " hi NonText guibg=none ctermbg=none
  " hi SpecialKey guibg=none ctermbg=none
  " hi VertSplit guibg=none ctermbg=none
  " hi SignColumn guibg=none ctermbg=none
  " hi EndOfBuffer guibg=none ctermbg=none
  " hi StatusLine guibg=NONE
  " hi StatusLineNC guibg=NONE guifg=NONE
    syntax sync fromstart
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
]])
