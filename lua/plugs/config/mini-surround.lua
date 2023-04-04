---@diagnostic disable-next-line: unused-local
local default_cfg = {
  custom_surroundings = nil,
  highlight_duration = 500,
  mappings = {
    add = "sa", -- Add surrounding in Normal and Visual modes
    delete = "sd", -- Delete surrounding
    find = "sf", -- Find surrounding (to the right)
    find_left = "sF", -- Find surrounding (to the left)
    highlight = "sh", -- Highlight surrounding
    replace = "sr", -- Replace surrounding
    update_n_lines = "sn", -- Update `n_lines`

    suffix_last = "l", -- Suffix to search with "prev" method
    suffix_next = "n", -- Suffix to search with "next" method
  },
  n_lines = 20,
  respect_selection_type = false,
  search_method = "cover",
}

---@diagnostic disable-next-line: unused-local
local vim_surround = {
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",

    -- Add this only if you don't want to use extended mappings
    suffix_last = "",
    suffix_next = "",
  },
  search_method = "cover_or_next",
}

local cfg = {
  mappings = {
    add = "s", -- Add surrounding in Normal and Visual modes
    delete = "ds", -- Add surrounding in Normal and Visual modes
    change = "cs", -- Add surrounding in Normal and Visual modes
  },
  search_method = "cover_or_next",
}
require("mini.surround").setup(cfg)

-- -- Remap adding surrounding to Visual mode selection
-- vim.keymap.del("x", "ys")
-- vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
--
-- -- Make special mapping for "add surrounding for line"
-- vim.keymap.set("n", "yss", "ys_", { remap = true })
--
