-- Lua
local def_config = {
  on_substitute = nil,
  yank_substituted_text = false,
  range = {
    prefix = "s",
    prompt_current_text = false,
    confirm = false,
    complete_word = false,
    motion1 = false,
    motion2 = false,
    suffix = "",
  },
  exchange = {
    motion = false,
  },
}

require("substitute").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  on_substitute = function(_)
    vim.cmd("call yoink#startUndoRepeatSwap()")
  end,
})

-- Then you can then execute s<motion> to substitute the text object provided by the motion with the contents of the default register (or an explicit register if provided). For example, you could execute siw to replace the current word under the cursor with the current yank, or sip to replace the paragraph, etc.
-- This action is dot-repeatable.

vim.keymap.set("n", "gs", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "gss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
-- vim.keymap.set("n", "gsS", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "gs", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>s", "<cmd>lua require('substitute.range').operator()<cr>", { noremap = true })
vim.keymap.set("x", "<leader>s", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ss", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })

-- Note: in this case you will be shadowing the change character key s so you will have to use the longer form cl.
