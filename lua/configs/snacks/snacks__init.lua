vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    -- vim.print = _G.dd -- Override print to use snacks for `:=` command
    Snacks.toggle({
      name = "Mini Animate",
      get = function()
        return not vim.g.minianimate_disable
      end,
      set = function(state)
        vim.g.minianimate_disable = not state
      end,
    }):map("<leader>ua")

    -- -- Create some toggle mappings
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>_s")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>_w")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>_L")
    Snacks.toggle.diagnostics():map("<leader>_d")
    Snacks.toggle.line_number():map("<leader>_l")
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
      :map("<leader>_c")
    Snacks.toggle.treesitter():map("<leader>_T")
    Snacks.toggle
      .option("background", { off = "light", on = "dark", name = "Dark Background" })
      :map("<leader>_b")
    Snacks.toggle.inlay_hints():map("<leader>_h")
  end,
})
