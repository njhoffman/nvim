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
