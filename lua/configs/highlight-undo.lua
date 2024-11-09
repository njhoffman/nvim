local cfg = {
  duration = 300,
  keymaps = {
    redo = {
      hlgroup = "HighlightRedo",
      mode = "n",
      lhs = "<C-r>",
      map = "redo",
      opts = { desc = "󰑎 Redo" },
    },
    undo = {
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "u",
      map = "undo",
      opts = { desc = "󰕌 Undo" },
    },
  },
}

require("highlight-undo").setup(cfg)

local undo_refresh = function()
  require("highlight-undo").setup(cfg)
end

vim.api.nvim_create_user_command("Redo", 'lua require("highlight-undo").redo()', {})
vim.api.nvim_create_user_command("Undo", 'lua require("highlight-undo").undo()', {})
vim.api.nvim_create_user_command("UndoRefresh", undo_refresh, {})

-- TODO: Find a better way to do this to resolve ISwap issues
vim.api.nvim_create_autocmd({ "BufEnter" }, { command = "UndoRefresh" })
