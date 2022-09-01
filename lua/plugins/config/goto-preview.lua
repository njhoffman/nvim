-- require('goto-preview').setup {
--   width = 120; -- Width of the floating window
--   height = 15; -- Height of the floating window
--   border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }; -- Border characters of the floating window
--   default_mappings = false; -- Bind default mappings
--   debug = false; -- Print debug information
--   opacity = 80; -- 0-100 opacity level of the floating window where 100 is fully transparent.
--   resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
--   post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
--   -- references = { -- Configure the telescope UI for slowing the references cycling window.
--   --   telescope = telescope.themes.get_dropdown({ hide_preview = false })
--   -- };
--   -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
--   focus_on_open = false; -- Focus the floating window when opening it.
--   dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
--   force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
--   bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
-- }

require("goto-preview").setup({
  opacity = 20,
  default_mappings = false,
  force_close = true,
  resizing_mappings = false,
  focus_on_open = false,
})

vim.api.nvim_set_keymap(
  "n",
  "gpt",
  "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "gpi",
  "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "gpd",
  "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "gpr",
  "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap("n", "", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })

vim.cmd([[
  " nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<cr>
  " nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<cr>
  " nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<cr>
  " nnoremap gp <cmd>lua require('goto-preview').close_all_win()<cr>
  " nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<cr>
  " nnoremap gDd <cmd>lua require('goto-preview').goto_preview_definition()<cr>
  " nnoremap gDt <cmd>lua require('goto-preview').goto_preview_type_definition()<cr>
  " nnoremap gDi <cmd>lua require('goto-preview').goto_preview_implementation()<cr>
  " nnoremap gD0 <cmd>lua require('goto-preview').close_all_win()<cr>
  " nnoremap gDr <cmd>lua require('goto-preview').goto_preview_references()<cr>
]])
