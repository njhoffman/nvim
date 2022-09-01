local config = require("codebox.config")

local apply_default_mappings = function()
  vim.api.nvim_set_keymap(
    "n",
    "gpt",
    "<cmd>lua require('codebox').goto_preview_type_definition()<CR>",
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "gpi",
    "<cmd>lua require('codebox').goto_preview_implementation()<CR>",
    { noremap = true }
  )

  vim.api.nvim_set_keymap("n", "gpd", "<cmd>lua require('codebox').goto_preview_definition()<CR>", {
    noremap = true,
  })

  vim.api.nvim_set_keymap("n", "<esc>", "<cmd>lua require('codebox').close_all_win()<CR>", {
    noremap = true,
  })

  local dock_cmd = string.format("<cmd>lua require('codebox').toggle_dock()<CR>")
  vim.api.nvim_set_keymap("n", "", dock_cmd, { noremap = true })
end

local apply_resizing_mappings = function()
  vim.api.nvim_set_keymap("n", "<left>", "<C-w>>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<right>", "<C-w><", { noremap = true })
  vim.api.nvim_set_keymap("n", "<up>", "<C-w>+", { noremap = true })
  vim.api.nvim_set_keymap("n", "<down>", "<C-w>-", { noremap = true })
end

return {
  apply_resizing_mappings = apply_resizing_mappings,
  apply_default_mappings = apply_default_mappings,
}
