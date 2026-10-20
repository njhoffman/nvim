local init = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
      local bt = vim.api.nvim_get_option_value("buftype", { buf = 0 })
      local ft_exclude = {
        "alpha",
        "dap.*",
        "dashboard",
        "guihua",
        "help",
        "lazy",
        "lspinfo",
        "markdown",
        "mason",
        "neo-tree",
        "noice",
        "noice.log",
        "null-ls-info",
        "qf",
        "sidekick",
        "neo-tree",
        "NvimTree",
        "tablegen",
        "Trouble",
      }
      local bt_exclude = { "terminal", "prompt", "nofile", "quickfix" }
      if vim.tbl_contains(ft_exclude, ft) or vim.tbl_contains(bt_exclude, bt) then
        vim.b.miniindentscope_disable = true
      end
    end,
  })
end

return init
