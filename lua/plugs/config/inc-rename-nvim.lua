local defaults = {
  cmd_name = "IncRename", -- the name of the command
  hl_group = "Substitute", -- the highlight group used for highlighting the identifier's new name
  preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
  multifile_preview = true, -- whether to enable the command preview across multiple buffers
  show_message = true, -- whether to display a `Renamed m instances in n files` message after a rename operation
  post_hook = nil, -- callback to run after renaming, receives the result table (from LSP handler) as an argument
}

require("inc_rename").setup({})

-- prevent input box from covering word being renamd
require("dressing").setup({
  input = {
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
})
-- vim.keymap.set("n", "<leader>rn", ":IncRename ")
-- If you want to prefill the word under the cursor you can use the following:

-- vim.keymap.set("n", "<leader>rn", function()
--   return ":IncRename " .. vim.fn.expand("<cword>")
-- end, { expr = true })
-- cherry_blossom dressing.nvim support

-- If your are using dressing.nvim or a similar plugin that uses a separate buffer for typing the new name, you can call the rename function that inc-rename provides:
-- require("inc_rename").rename(opts | nil)

-- -- To prefill the word under the cursor, pass a default value:
-- require("inc_rename").rename({ default = vim.fn.expand("<cword>") })
