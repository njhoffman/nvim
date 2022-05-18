local M = {
  preview = { cmd = ":MarkdownPreview<CR>", short = "display markdown preview", long = "display markdown preview" },
  toggle_cb_v = { cmd = "<plug>(mkdx-toggle-checkbox-v)", short = "toggle cb vis", long = "toggle checkbox visual" },
  toggle_cb_n = { cmd = "<plug>(mkdx-toggle-checkbox-n)", short = "toggle cb", long = "toggle checkbox" },
  toggle_cb_value = { cmd = "<cmd>ToggleCB<cr>", short = "toggle cb value", long = "toggle checkbox value" },
  table_realign_n = { cmd = "<cmd>TableModeRealign<cr>", short = "realign table", long = "realign table" },
  table_realign_v = { cmd = "<plug>tablemode#Realign()", short = "realign table", long = "realign table" },
  -- table_realign_n = { short = "realign table", long = "realign table" }, -- virtual
  -- table_realign_v = { short = "realign table", long = "realign table" }, -- virtual

  tablemode_toggle = { short = "toggle tablemode", long = "toggle tablemode" }, -- virtual
  tableize_n = { short = "tableize cursor", long = "tableize cursor" }, -- virtual
  tableize_v = { short = "tableize selection", long = "tableize selection" }, -- virtual
  table_insert_col_n = { short = "insert table column", long = "insert table column" }, -- virtual
  table_insert_col_v = { short = "insert table column", long = "insert table column" }, -- virtual
  table_delete_col_n = { short = "delete table column", long = "delete table column" }, -- virtual
  table_delete_col_v = { short = "delete table column", long = "delete table column" } -- virtual
}

return M

