-- Registers the TailStart and TailStop commands.

local commands = require("modules.tail.commands")

vim.api.nvim_create_user_command(
  "TailStart",
  commands.start_tail,
  { desc = "Start tailing the current file" }
)

vim.api.nvim_create_user_command(
  "TailStop",
  commands.stop_tail,
  { desc = "Stop tailing the current file" }
)
