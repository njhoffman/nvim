local opts = {
  window = {
    -- { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
    border = "rounded",
    size = { width = "60%" }, -- no height: fits the lists, up to max_height
    max_height = "21%", -- 14 rows on a 68-row terminal
    position = "100%", -- 50%
    sections = {
      left = { size = "30%" },
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
