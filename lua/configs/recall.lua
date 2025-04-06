local recall = require("recall")
recall.setup({
  -- sign = "",
  -- sign_highlight = "@comment.note",
  sign = "",
  sign_highlight = "RecallMark",
  telescope = {
    autoload = true,
    mappings = {
      unmark_selected_entry = {
        normal = "dd",
        insert = "<M-d>",
      },
    },
  },

  wshada = vim.fn.has("nvim-0.10") == 0,
})
-- Using commands:
vim.keymap.set("n", "mm", recall.toggle, { noremap = true, silent = true, desc = "marks toggle" })
vim.keymap.set(
  "n",
  "mn",
  recall.goto_next,
  { noremap = true, silent = true, desc = "marks goto next" }
)
vim.keymap.set(
  "n",
  "mp",
  recall.goto_prev,
  { noremap = true, silent = true, desc = "marks goto prev" }
)
vim.keymap.set("n", "mc", recall.clear, { noremap = true, silent = true, desc = "marks clear" })
vim.keymap.set(
  "n",
  "m/",
  ":Telescope recall<CR>",
  { noremap = true, silent = true, desc = "marks view in telescope" }
)
-- -- In your Neovim configuration:
-- vim.opt.exrc = true
-- vim.opt.secure = true
--
-- -- /path/to/your/project/.nvim.lua:
-- vim.opt.shadafile = ".vim/project.shada"
--
-- -- Optionally, in the project's .gitignore or ~/.config/git/ignore:
-- .vim
