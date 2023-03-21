local function delete_special()
  return true
end

vim.keymap.set("n", "99", delete_special, { noremap = true, expr = true })
