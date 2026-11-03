return {
  -- loaded before plugin manager for global preferences and resources that may be triggered early by event handlers
  init = function()
    -- WARN: do not include any plugins in this file, any require calls should be local
    require("modules.components.quickfix").setup()
    require("modules.components.lsp_hover").setup()
    require("modules.components.diagnostics").setup()
    require("modules.components.beacon").setup()
    require("modules.components.term_sync").init()
  end,

  -- loaded after plugin manager
  setup = function()
    require("modules.components.highlights").setup()
    require("modules.components.inspect_tree").setup()
    require("modules.components.term_sync").setup()
    require("modules.components.tscli_sync").setup()
    require("modules.components.color").setup()
  end,
}
