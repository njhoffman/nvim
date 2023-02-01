local u = require("null-ls.utils")
local null_ls = require("null-ls")
local my_sources = require("plugins.config.null-ls-sources")

local supports_method_for_filetype = function(filetype, method)
  local sources = require("null-ls.sources")
  local available = sources.get_available(filetype, method)
  return #available > 0
end

local map_buf = function(bufnr, lhs, rhs)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", lhs, rhs, opts)
end

local handlers = require("lsp-handlers")
local on_attach = function(_, bufnr)
  local filetype = vim.bo.filetype

  if supports_method_for_filetype(filetype, "NULL_LS_FORMATTING") then
    handlers.documentFormattingProvider("null-ls", bufnr)
    -- map_buf(bufnr, "gQ", lsp_document_format("null-ls"))
    -- format_on_save(bufnr, "null-ls")
    -- attach.keybindings_formatting(bufnr, "null-ls")
  end

  if supports_method_for_filetype(filetype, "NULL_LS_CODE_ACTION") then
    map_buf(bufnr, "cxa", vim.lsp.buf.code_action)
    -- attach.keybindings_codeaction(bufnr)
  end
end

null_ls.setup({
  log_level = "info",
  sources = my_sources.sources,
  on_attach = on_attach,
  -- default_timeout = 5000,
  root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git"),
  -- should_attach = function(bufnr)
  --   local large_file = require("large_file")
  --
  --   return not large_file.is_large_file(bufnr)
  -- end,
})

-- local defaults = {
--   cmd = { "nvim" },
--   debounce = 250,
--   debug = true,
--   diagnostics_format = "#{m}",
--   fallback_severity = vim.diagnostic.severity.ERROR,
--   log_level = "info",
--   notify_format = "[null-ls] %s",
--   on_attach = nil,
--   on_init = nil,
--   on_exit = nil,
--   update_in_insert = false,
-- }
