local filetypes = { "lua", "python" }

local cfg = {
  silent = false,
  filter = function(bufnr)
    if vim.tbl_contains(filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
      return require("cmp").get_selected_index() ~= ""
    end
  end,
  debounce = true,
  single_line = {
    enabled = true,
    label = "...", -- Label indicating that there is multi-line suggestion.
  },
}

require("neocodeium").setup(cfg)

local keymaps = function()
  vim.keymap.set("i", "<M-Space>", function()
    require("neocodeium").accept()
  end, { desc = "neocodeium accept suggestion" })

  vim.keymap.set("i", "<F8>", function()
    require("neocodeium").accept()
  end, { desc = "neocodeium accept suggestion" })

  vim.keymap.set("i", "<M-'>", function()
    require("neocodeium").accept_word()
  end, { desc = "neocodeium accept word suggestion" })

  vim.keymap.set("i", '<M-">', function()
    require("neocodeium").accept_line()
  end, { desc = "neocodeium accept line suggestion" })

  -- C-S-j
  vim.keymap.set("i", "<M-S-Down>", function()
    require("neocodeium").cycle_or_complete()
  end, { desc = "neocodeium next suggestion" })

  -- C-S-k
  vim.keymap.set("i", "<M-S-Up>", function()
    require("neocodeium").cycle_or_complete(-1)
  end, { desc = "neocodeium prev suggestion" })

  vim.keymap.set("i", "<M-c>", function()
    require("neocodeium").clear()
  end, { desc = "neocodeium clear suggestion" })
end

keymaps()

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
