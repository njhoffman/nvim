local filetypes = { "lua", "python" }

local cfg = {}

local keymaps = function()
  vim.keymap.set("i", "<A-f>", function()
    require("neocodeium").accept()
  end)
  vim.keymap.set("i", "<A-w>", function()
    require("neocodeium").accept_word()
  end)
  vim.keymap.set("i", "<A-a>", function()
    require("neocodeium").accept_line()
  end)
  vim.keymap.set("i", "<A-e>", function()
    require("neocodeium").cycle_or_complete()
  end)
  vim.keymap.set("i", "<A-r>", function()
    require("neocodeium").cycle_or_complete(-1)
  end)
  vim.keymap.set("i", "<A-c>", function()
    require("neocodeium").clear()
  end)

  -- Disable NeoCodeium in .env files
  local filter = function(bufnr)
    if vim.tbl_contains(filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
      return true
    end
    -- function accepts one argument `bufnr`
  end
end

require("neocodeium").setup(cfg)

-- local neocodeium = require("neocodeium")
-- -- Accepts the suggestion
-- neocodeium.accept()
-- -- Accepts only part of the suggestion if the full suggestion doesn't make sense
-- neocodeium.accept_word()
-- neocodeium.accept_line()
-- -- Clears the current suggestion
-- neocodeium.clear()
-- -- Cycles through suggestions by `n` (1 by default) items.
-- -- Use a negative value to cycle in reverse order
-- neocodeium.cycle(n)
-- -- Same as `cycle()`, but also tries to show a suggestion if none is visible.
-- -- Mostly useful with the enabled `manual` option
-- neocodeium.cycle_or_complete(n)
-- -- Checks if a suggestion's virtual text is visible or not (useful for some complex mappings)
-- neocodeium.visible()
