vim.cmd([[
    command! NeotestSummary lua require("neotest").summary.toggle()
    command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
    command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
    command! NeotestNearest lua require("neotest").run.run()
    command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
    command! NeotestAttach lua require("neotest").run.attach()
    command! NeotestOutput lua require("neotest").output_panel.toggle()
]])

return {
  adapters = {
    require("neotest-vim-test")({ ignore_filetypes = { "python", "lua" } }),
    require("neotest-rust"),
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
}
