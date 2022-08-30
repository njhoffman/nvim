local cfg = {
  containers = {
    lua = {
      table_constructor = { final_separator = ",", final_end_line = true },
      arguments = { final_separator = false, final_end_line = true },
      parameters = { final_separator = false, final_end_line = true },
    },
  },
}

require("trevj").setup()

vim.keymap.set("n", "<leader>j", function()
  require("trevj").format_at_cursor()
end)
