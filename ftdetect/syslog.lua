vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/var/log/syslog*",
  callback = function()
    vim.bo.filetype = "syslog"
  end,
})
