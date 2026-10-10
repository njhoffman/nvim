return {
  -- loaded before plugin manager for global preferences and resources that may be triggered early by event handlers
  init = function()
    -- WARN: do not include any plugins in this file, any require calls should be local
    require("components.quickfix").setup()
    require("components.lsp_hover").setup()
    require("components.diagnostics").setup()
    require("components.beacon").setup()
    require("components.term_sync").init()
  end,

  -- loaded after plugin manager
  setup = function()
    require("components.highlights").setup()
    require("components.inspect_tree").setup()
    require("components.term_sync").setup()
    require("components.tscli_sync").setup()
    require("components.color").setup()
  end,
}
