require('action-hints').setup({
  template = {
    definition = { text = ' ⊛', color = '#517c8a' },
    references = { text = ' ↱%s', color = '#8b0000' },
    codeactions = { text = ' %s', color = '#006ea5' },
  },
  use_virtual_text = true,
})
