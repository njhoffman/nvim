local api = vim.api

---makes highlight-undo respect `foldopen=undo` (#18)
local function openFoldsOnUndo()
  if vim.tbl_contains(vim.opt.foldopen:get(), "undo") then
    vim.cmd.normal({ "zv", bang = true })
  end
end

local cfg = {
  duration = 300,
  keymaps = {
    undo = {
      desc = "undo",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "u",
      rhs = nil,
      opts = {
        desc = "󰕌 Undo",
        callback = function()
          vim.cmd("undo")
          openFoldsOnUndo()
        end,
      },
    },
    redo = {
      desc = "redo",
      hlgroup = "HighlightRedo",
      mode = "n",
      lhs = "<C-r>",
      rhs = nil,
      opts = {
        desc = "󰑎 Redo",
        callback = function()
          vim.cmd("redo")
          openFoldsOnUndo()
        end,
      },
    },
    paste = {
      desc = "paste",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "p",
      rhs = "p",
      opts = {},
    },
    Paste = {
      desc = "Paste",
      hlgroup = "HighlightUndo",
      mode = "n",
      lhs = "P",
      rhs = "P",
      opts = {},
    },
    -- redo = {
    --   hlgroup = "HighlightRedo",
    --   mode = "n",
    --   lhs = "<C-r>",
    --   desc = "redo",
    --   rhs = nil,
    --   opts = { desc = "󰑎 Redo" },
    -- },
    -- undo = {
    --   hlgroup = "HighlightUndo",
    --   mode = "n",
    --   lhs = "u",
    --   desc = "undo",
    --   rhs = nil,
    --   opts = { desc = "󰕌 Undo" },
    -- },
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
-- vim.api.nvim_create_autocmd({ "BufEnter" }, { command = "UndoRefresh" })
