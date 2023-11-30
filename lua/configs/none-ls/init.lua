local u = require('null-ls.utils')
local null_ls = require('null-ls')

-- autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
-- vim.fn.input()
local custom_sources = require('configs.none-ls.custom')
local source_categories = {
  require('configs.none-ls.codeactions'),
  require('configs.none-ls.diagnostics'),
  require('configs.none-ls.formatting'),
  custom_sources.formatting,
  custom_sources.diagnostics,
  custom_sources.codeactions,
}

local sources = {}
for _, src in ipairs(source_categories) do
  for _, v in ipairs(src) do
    table.insert(sources, v)
  end
end

local supports_method_for_filetype = function(filetype, method)
  local null_sources = require('null-ls.sources')
  local available = null_sources.get_available(filetype, method)
  return #available > 0
end

local map_buf = function(bufnr, lhs, rhs)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', lhs, rhs, opts)
end

local handlers = require('lsp.handlers')
local on_attach = function(client, bufnr)
  local filetype = vim.bo.filetype
  if supports_method_for_filetype(filetype, 'NULL_LS_FORMATTING') then
    require('lsp.format').on_attach(client)
    -- handlers.documentFormattingProvider('null-ls', bufnr)
    -- map_buf(bufnr, "gQ", lsp_document_format("null-ls"))
    -- format_on_save(bufnr, "null-ls")
    -- attach.keybindings_formatting(bufnr, "null-ls")
  end

  if supports_method_for_filetype(filetype, 'NULL_LS_CODE_ACTION') then
    map_buf(bufnr, 'cxa', vim.lsp.buf.code_action)
    -- attach.keybindings_codeaction(bufnr)
  end
end

local exclude_ft = {
  'TelescopePrompt',
  'alpha',
  'dap.*',
  'dashboard',
  'help',
  'mason',
  'neo-tree',
  'noice',
  'notify',
  'oil',
  'packer',
  'qf',
  'spectre_panel',
  'startify',
  'tablegen',
  'tsplayground',
}

null_ls.setup({
  border = 'rounded',
  cmd = { 'nvim' },
  log_level = 'info',
  update_in_insert = false,
  sources = sources,
  fallback_severity = vim.diagnostic.severity.INFO,
  on_init = function(new_client, _)
    if vim.tbl_contains({ 'h', 'cpp', 'c' }, vim.o.ft) then
      new_client.offset_encoding = 'utf-16' -- , "utf-32" for ccls
    end
  end,
  diagnostic_config = { underline = false },
  on_attach = on_attach,
  debounce = 2000,
  default_timeout = 5000,
  root_dir = u.root_pattern(
    '.null-ls-root',
    'Makefile',
    '.git',
    'go.mod',
    'package.json',
    'requirements.txt',
    'tsconfig.json'
  ),
  should_attach = function(bufnr)
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if not vim.tbl_contains(exclude_ft, ft) and ft ~= '' then
      return true
    end
    -- local large_file = require('large_file')
    -- return not large_file.is_large_file(bufnr)
  end,
})
