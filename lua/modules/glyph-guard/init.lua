-- Glyph-guard defaults and setup: flags private-use glyphs in code.

local M = {}

local defaults = {
  registry_path = vim.fn.stdpath("config") .. "/glyphs.json",
  detect = { pua = true, non_ascii = false },
  filetypes = { "lua", "sh", "bash", "zsh" },
  extensions = { ".lua", ".sh", ".zsh", ".bash" },
  scan = { ignore = { ".git", "node_modules", "dist", ".direnv", "target" } },
  ui = { highlight = "WarningMsg", auto_open_qf = "on_results" },
  write = { behavior = "notify" },
  progress = { enabled = true },
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})
  local registry = require("modules.glyph-guard.registry").load(config.registry_path)
  require("modules.glyph-guard.commands").register(config, registry)
end

return M
