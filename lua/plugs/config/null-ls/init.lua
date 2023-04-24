local u = require('null-ls.utils')
local null_ls = require('null-ls')
local my_sources = require('plugs.config.null-ls.sources')

-- autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

local supports_method_for_filetype = function(filetype, method)
  local sources = require('null-ls.sources')
  local available = sources.get_available(filetype, method)
  return #available > 0
end

local map_buf = function(bufnr, lhs, rhs)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', lhs, rhs, opts)
end

local handlers = require('lsp.handlers')
local on_attach = function(_, bufnr)
  local filetype = vim.bo.filetype

  if supports_method_for_filetype(filetype, 'NULL_LS_FORMATTING') then
    handlers.documentFormattingProvider('null-ls', bufnr)
    -- map_buf(bufnr, "gQ", lsp_document_format("null-ls"))
    -- format_on_save(bufnr, "null-ls")
    -- attach.keybindings_formatting(bufnr, "null-ls")
  end

  if supports_method_for_filetype(filetype, 'NULL_LS_CODE_ACTION') then
    map_buf(bufnr, 'cxa', vim.lsp.buf.code_action)
    -- attach.keybindings_codeaction(bufnr)
  end
end

null_ls.setup({
  cmd = { 'nvim' },
  log_level = 'info',
  update_in_insert = false,
  sources = my_sources.sources,
  fallback_severity = vim.diagnostic.severity.INFO,
  on_init = function(new_client, _)
    if vim.tbl_contains({ 'h', 'cpp', 'c' }, vim.o.ft) then
      new_client.offset_encoding = 'utf-16' -- , "utf-32" for ccls
    end
  end,
  diagnostic_config = { underline = false },
  on_attach = on_attach,
  debounce = 500,
  default_timeout = 5000,
  root_dir = u.root_pattern('.null-ls-root', 'Makefile', '.git', 'go.mod', 'package.json', 'requirements.txt', 'tsconfig.json'),
  -- should_attach = function(bufnr)
  --   local large_file = require("large_file")
  --
  --   return not large_file.is_large_file(bufnr)
  -- end,
})
