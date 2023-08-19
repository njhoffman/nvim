-- opts = function(_, opts)
--   local format_kinds = opts.formatting.format
--   opts.formatting.format = function(entry, item)
--     format_kinds(entry, item) -- add icons
--     return require('tailwindcss-colorizer-cmp').formatter(entry, item)
--   end
-- end,
require('tailwindcss-colorizer-cmp').setup({
  color_square_width = 2,
})
