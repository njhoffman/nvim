local opts = {
  window = {
    -- { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
    border = "rounded",
    size = "60%", -- 60%
    position = "100%", -- 50%
    sections = {
      left = { size = "30%", hide_empty = true },
      mid = { size = "30%" },
      right = {},
    },
  },
  lsp = {
    auto_attach = true,
  },
  source_buffer = {
    reorient = "smart", -- "smart", "top", "mid" or "none"
  },
}

require("nvim-navbuddy").setup(opts)
