local DEFAULT_SETTINGS = {
  allowed_separators = {
    ",",
    ";",
    "and",
    "or",
    "&&",
    "&",
    "||",
    "|",
    "==",
    "===",
    "!=",
    "!==",
    "-",
    "+",
    ["<"] = ">",
    ["<="] = ">=",
    [">"] = "<",
    [">="] = "<=",
  },
  use_default_keymaps = true,
  -- Highlight recently swapped node. Can be boolean or table
  -- If table: { ms = 500, hl_opts = { link = 'IncSearch' } }
  -- `hl_opts` is a `val` from `nvim_set_hl()`
  highlight_node_at_cursor = false,
  -- keybinding for movements to right or left (and up or down, if `allow_interline_swaps` is true)
  -- (`<C-,>` and `<C-.>` may not map to control chars at system level, so are sent by certain terminals as just `,` and `.`. In this case, just add the mappings you want.)
  keymaps = {
    ["<C-.>"] = "swap_with_right",
    ["<C-,>"] = "swap_with_left",
    ["<space>."] = "swap_with_right_with_opp",
    ["<space>,"] = "swap_with_left_with_opp",
  },
  ignore_injected_langs = false,
  -- allow swaps across lines
  allow_interline_swaps = true,
  -- swaps interline siblings without separators (no recommended, helpful for swaps html-like attributes)
  interline_swaps_without_separator = false,
  -- Fallbacs for tiny settings for langs and nodes. See #fallback
  fallback = {},
}

require("sibling-swap").setup({
  use_default_keymaps = false,
  -- If table: { ms = 500, hl_opts = { link = 'IncSearch' } }
  -- `hl_opts` is a `val` from `nvim_set_hl()`
  highlight_node_at_cursor = true,
  -- keybinding for movements to right or left (and up or down, if `allow_interline_swaps` is true)
  keymaps = {
    ["]<"] = "swap_with_right",
    ["[<"] = "swap_with_left",
    ["])"] = "swap_with_right",
    ["[("] = "swap_with_left",
  },
  allowed_separators = {
    -- standart
    "=",
    -- with opposite value
    [">>"] = "<<",
    ["<<"] = ">>",
    -- disable
    ["&"] = false,
  },
})
-- local move = require("nvim-treesitter-textobjects.move")
-- local swap = require("nvim-treesitter-textobjects.swap")

-- -- custom moves
-- map({ "n", "x", "o" }, "]a", function()
--   move.goto_next_start("@parameter.inner", "textobjects")
-- end, { desc = "Next Parameter Start" })
-- map({ "n", "x", "o" }, "]A", function()
--   move.goto_next_end("@parameter.inner", "textobjects")
-- end, { desc = "Next Parameter End" })

-- map({ "n", "x", "o" }, "[a", function()
--   move.goto_previous_start({ "@parameter.inner", "@loop.outer" }, "textobjects")
-- end, { desc = "Previous Parameter Start" })

-- map({ "n", "x", "o" }, "[A", function()
--   move.goto_previous_end("@parameter.inner", "locals")
-- end, { desc = "Previous Parameter End" })

-- -- custom swaps
-- map("n", "_a", function()
--   swap.swap_next("@parameter.inner")
-- end, { desc = "Swap with Next Param" })

-- map("n", "_A", function()
--   swap.swap_previous("@parameter.inner")
-- end, { desc = "Swap with Prev Param" })

-- map("n", "_f", function()
--   swap.swap_next("@function.outer")
-- end, { desc = "Swap with Next Func" })

-- map("n", "_F", function()
--   swap.swap_previous("@function.outer")
-- end, { desc = "Swap with Next Func" })
