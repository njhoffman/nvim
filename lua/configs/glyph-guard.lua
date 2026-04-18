require("glyph-guard").setup({
  registry_path = vim.fn.stdpath("config") .. "/glyphs.json",

  detect = {
    pua = true,
    non_ascii = false,
  },

  filetypes = { "lua", "sh", "bash", "zsh" },
  extensions = { ".lua", ".sh", ".zsh", ".bash" },

  scan = {
    ignore = { ".git", "node_modules", "dist", ".direnv", "target" },
  },

  ui = {
    highlight = "WarningMsg",
    auto_open_qf = "on_results",
  },

  write = {
    behavior = "notify",
  },

  progress = {
    enabled = true,
  },
})
