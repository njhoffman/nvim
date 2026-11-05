-- Keymaps for quitting, clearing search and launching terminal tools through WezTerm.

local map = vim.keymap.set
local wez = require("core.commands.termints.wezterm-cli")

map("n", "<BS><BS><BS>", ":qall!<CR>", {
  noremap = true,
  silent = true,
  desc = "Quit",
})

map("n", "<BS>", ":noh<cr>", {
  noremap = true,
  silent = true,
  desc = "Clear current search",
})

map("n", "<leader>ls", function()
  wez.spawn({
    "/usr/bin/zsh",
    "-c",
    "ls -lash; read -sk",
  })
end)

require("core.commands.termints.git")
require("core.commands.termints.repl")
