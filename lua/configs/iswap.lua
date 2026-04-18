local defaults = {
  -- The keys that will be used as a selection, in order
  -- ('asdfghjklqwertyuiopzxcvbnm' by default)
  keys = "qwertyuiop",

  -- Grey out the rest of the text when making a selection
  -- (enabled by default)
  grey = "disable",

  -- Highlight group for the sniping value (asdf etc.)
  -- default 'Search'
  hl_snipe = "ErrorMsg",

  -- Highlight group for the visual selection of terms
  -- default 'Visual'
  hl_selection = "WarningMsg",

  -- Highlight group for the greyed background
  -- default 'Comment'
  hl_grey = "LineNr",

  -- Post-operation flashing highlight style,
  -- either 'simultaneous' or 'sequential', or false to disable
  -- default 'sequential'
  flash_style = false,

  -- Highlight group for flashing highlight afterward
  -- default 'IncSearch'
  hl_flash = "ModeMsg",

  -- Move cursor to the other element in ISwap*With commands
  -- default false
  move_cursor = true,

  -- Automatically swap with only two arguments
  -- default nil
  autoswap = true,

  -- Other default options you probably should not change:
  debug = nil,
  hl_grey_priority = "1000",
}

local map = require("mapper").map

local swap_with_left = function()
  vim.go.operatorfunc = "v:lua.require'iswap'.iswap_node_with_left"
  return "g@l"
end

local swap_with_right = function()
  vim.go.operatorfunc = "v:lua.require'iswap'.iswap_node_with_right"
  return "g@l"
end

map("n", "<leader><", swap_with_left, { desc = "Swap with [count] left node", expr = true })
map("n", "<leader>>", swap_with_right, { desc = "Swap with [count] right node", expr = true })
map("n", "[s", swap_with_left, { desc = "Swap with [count] left node", expr = true })
map("n", "]s", swap_with_right, { desc = "Swap with [count] right node", expr = true })
map({ "n" }, "<M-;>", "<cmd>ISwapNodeWith<cr>", {
  category = "Format",
  label = "易swap node with",
  desc = "易swap/exchange node objects with",
  plugin = "iswap.nvim",
})

require("iswap").setup()
