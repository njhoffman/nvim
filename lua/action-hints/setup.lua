require("action-hints").setup({
  template = {
    definition = { text = " ⊛ ", color = "#016c8a" },
    references = { text = " ↱%s ", color = "#6b40a0" },
    codeactions = { text = " %s ", color = "#006ef5" },
  },
  use_virtual_text = true,
})
