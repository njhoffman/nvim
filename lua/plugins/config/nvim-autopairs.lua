
-- require("nvim-autopairs.completion.cmp").setup({
--   map_cr = true,
--   map_complete = true,
--   auto_select = true,
-- })

require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    lua = { "string" }, -- it will not add a pair on that treesitter node
    javascript = { "template_string" },
    java = false, -- don't check treesitter on java
  },
  enable_check_bracket_line = true, --- check bracket in same line
  ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  -- ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", ""),
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = true, -- disable when recording or executing a macro
  enable_moveright = true,
  enable_afterquote = true, -- add bracket pairs after quote
  map_bs = false, -- map the <BS> key
  map_c_w = false, -- map <c-w> to delete an pair if possible
  fast_wrap = {
    map = "<M-S>",
    -- map = '<M-e>',
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment",
  },
})
