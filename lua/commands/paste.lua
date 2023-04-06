local function visual_paste_without_yank()
  local register = "+"

  if vim.o.clipboard == "unnamed" then
    register = "*"
  end

  vim.fn.setreg("x", vim.fn.getreg(register))
  vim.api.nvim_paste(vim.fn.getreg(register), true, -1)
  vim.fn.setreg(register, vim.fn.getreg("x"))
end

return { visual_paste_without_yank = visual_paste_without_yank }
-- -- ===================
-- vim.keymap.set("n", "J", "mzJ`z") -- Retain cursor position on line join w J
--
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank until EOL to system clipboard" })
--
-- -- Delete into oblivion 😈
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete selection, send to NULL register" })
--
-- -- Replace selection, sending it into oblivion 🙈
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Replace selection, send to NULL register" })
--
