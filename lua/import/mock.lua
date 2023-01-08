vim.api.nvim_create_augroup("ImportTest", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    vim.dbglog("BufEnter Test")
  end,
  group = "ImportTest",
})

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(ev)
    vim.dbglog("BufLeave Test")
  end,
  group = "ImportTest",
})

local mock = function()
  return "you are a poop head"
end

return mock
