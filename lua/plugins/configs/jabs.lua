-- (Optional) easy way to get Neovim current size.
local ui = vim.api.nvim_list_uis()[1]
local config = {
  position = "corner", -- center, corner
  width = 50,
  height = 10,
  border = "shadow", -- none, single, double, rounded, solid, shadow, (or an array or chars)

  -- Options for preview window
  preview_position = "left", -- top, bottom, left, right
  preview = {
    width = 40,
    height = 30,
    border = "double", -- none, single, double, rounded, solid, shadow, (or an array or chars)
  },

}
if type(ui) == 'table' then
-- the options below are ignored when position = 'center'
  config.col = ui.width -- Window appears on the right
  config.row = ui.height / 2 -- Window appears in the vertical middle
else
  -- causes an error if configured with no window
  config.col = 80
  config.row = 40
end

require"jabs".setup(config)  -- vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "j", {nowait = true, noremap = true, silent = true})
-- vim.api.nvim_buf_set_keymap(0, "n", "<S-Tab>", "k", {nowait = true, noremap = true, silent = true})
-- vim.api.nvim_buf_set_keymap(0, "n", "<C-n>", "j", {nowait = true, noremap = true, silent = true})
-- vim.api.nvim_buf_set_keymap(0, "n", "<C-p>", "k", {nowait = true, noremap = true, silent = true})
