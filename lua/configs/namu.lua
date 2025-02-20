require("namu").setup({
  -- Enable the modules you want
  namu_symbols = {
    enable = true,
    options = {}, -- here you can configure namu
  },
  -- Optional: Enable other modules if needed
  colorscheme = {
    enable = false,
    options = {
      -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
      persist = true, -- very efficient mechanism to Remember selected colorscheme
      write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
    },
  },
  ui_select = { enable = false }, -- vim.ui.select() wrapper
})

-- === Suggested Keymaps: ===
-- local namu = require("namu.namu_symbols")
-- local colorscheme = require("namu.colorscheme")
-- vim.keymap.set("n", "<leader>ss", namu.show, {
--   desc = "Jump to LSP symbol",
--   silent = true,
-- })
-- vim.keymap.set("n", "<leader>th", colorscheme.show, {
--   desc = "Colorscheme Picker",
--   silent = true,
-- })

-- require("namu").setup({
--   namu_symbols = {
--     enable = true,
--     options = {
--       -- symbol navigation options
--     },
--   },
--   ui_select = {
--     enable = true,
--     options = {
--       -- ui select options
--     },
--   },
--   colorscheme = {
--     enable = true,
--     options = {
--       persist = true, -- Remember selected colorscheme
--       write_shada = false, -- For multiple nvim instances
--     },
--   },
-- })

-- -- 'https://github.com/bassamsdata/namu.nvim/blob/main/docs/Namu_config.md'
-- Display
-- Controls how symbols are shown in the picker.

-- display = {
--   mode = "text", -- "icon" or "text" (prefix displayed as icons or text)
--   padding = 2, -- Padding around displayed symbols
-- }
-- options = {
--   preview = {
--     enable = true, -- Enable/disable preview
--     highlight_on_move = true, -- Highlight while moving
--   },
--   auto_select = true, -- Auto-jump on single match
--   initially_hidden = false, -- Start with empty list
--   multiselect = {
--     enabled = true, -- Enable multi-selection
--   },
--   preserve_order = true, -- Keep symbol order while filtering
-- }

-- require("namu").setup({
--   namu_symbols = {
--     enable = true,
--     options = {
--       -- symbol navigation options
--     },
--   },
--   ui_select = {
--     enable = true,
--     options = {
--       -- ui select options
--     },
--   },
--   colorscheme = {
--     enable = true,
--     options = {
--       persist = true, -- Remember selected colorscheme
--       write_shada = false, -- For multiple nvim instances
--     },
--   },
-- })

-- -- featured toggles
-- options = {
--   preview = {
--     enable = true, -- Enable/disable preview
--     highlight_on_move = true, -- Highlight while moving
--   },
--   auto_select = true, -- Auto-jump on single match
--   initially_hidden = false, -- Start with empty list
--   multiselect = {
--     enabled = true, -- Enable multi-selection
--   },
--   preserve_order = true, -- Keep symbol order while filtering
-- }

-- display = {
--   mode = "text", -- "icon" or "text" (prefix displayed as icons or text)
--   padding = 2, -- Padding around displayed symbols

-- -- display = {
-- --   mode = "text", -- "icon" or "text" (prefix displayed as icons or text)
-- --   padding = 2, -- Padding around displayed symbols
-- -- }
--   --
--   --
--   --
