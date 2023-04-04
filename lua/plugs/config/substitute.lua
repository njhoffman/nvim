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
local yoinkConfig = {
  on_substitute = function(_)
    vim.cmd("call yoink#startUndoRepeatSwap()")
  end,
}

require("substitute").setup()

local map = require("mapper").map

-- Then you can then execute s<motion> to substitute the text object provided by the motion with the contents of the default register (or an explicit register if provided). For example, you could execute siw to replace the current word under the cursor with the current yank, or sip to replace the paragraph, etc.
-- This action is dot-repeatable.

map(
  "n",
  "gs",
  "<cmd>lua require('substitute').operator()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute operator" }
)
map(
  "n",
  "gss",
  "<cmd>lua require('substitute').line()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute line" }
)
-- vim.keymap.set("n", "gsS", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
map(
  "x",
  "gs",
  "<cmd>lua require('substitute').visual()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute visual" }
)
map(
  "n",
  "<leader>s",
  "<cmd>lua require('substitute.range').operator()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute range operator" }
)
map(
  "x",
  "<leader>s",
  "<cmd>lua require('substitute.range').visual()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute range visual" }
)
map(
  "n",
  "<leader>ss",
  "<cmd>lua require('substitute.range').word()<cr>",
  { category = "Motion", plugin = "substitute.nvim", desc = "substitute range word" }
)

-- Note: in this case you will be shadowing the change character key s so you will have to use the longer form cl.
