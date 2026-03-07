require("ui.utils.highlights").setup()
require("ui.utils.color_sync")
require("ui.utils.ts_regen").setup()
require("ui.utils.color").setup()

-- Autocmd for the custom *dynamic highlight group modifier*.
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = function()
    require("ui.utils.highlights").setup({ dynamic = true })
  end,
})
