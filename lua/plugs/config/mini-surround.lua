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

-- keys = function(_, keys)
--   -- Populate the keys based on the user's options
--   local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
--   local opts = require("lazy.core.plugin").values(plugin, "opts", false)
--   local mappings = {
--     { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
--     { opts.mappings.delete, desc = "Delete surrounding" },
--     { opts.mappings.find, desc = "Find right surrounding" },
--     { opts.mappings.find_left, desc = "Find left surrounding" },
--     { opts.mappings.highlight, desc = "Highlight surrounding" },
--     { opts.mappings.replace, desc = "Replace surrounding" },
--     { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
--   }
--   mappings = vim.tbl_filter(function(m)
--     return m[1] and #m[1] > 0
--   end, mappings)
--   return vim.list_extend(mappings, keys)
-- end,
-- opts = {
--   mappings = {
--     add = "gza", -- Add surrounding in Normal and Visual modes
--     delete = "gzd", -- Delete surrounding
--     find = "gzf", -- Find surrounding (to the right)
--     find_left = "gzF", -- Find surrounding (to the left)
--     highlight = "gzh", -- Highlight surrounding
--     replace = "gzr", -- Replace surrounding
--     update_n_lines = "gzn", -- Update `n_lines`
--   },
-- },
-- config = function(_, opts)
--   -- use gz mappings instead of s to prevent conflict with leap
--   require("mini.surround").setup(opts)
-- end,

-- -- Remap adding surrounding to Visual mode selection
-- vim.keymap.del("x", "ys")
-- vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
--
-- -- Make special mapping for "add surrounding for line"
-- vim.keymap.set("n", "yss", "ys_", { remap = true })
--
