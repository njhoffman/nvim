local state = require('action-hints.state')
local utils = require('action-hints.utils')
local references = require('action-hints.providers.references')
local definitions = require('action-hints.providers.definitions')
local codeactions = require('action-hints.providers.codeactions')
local display = require('action-hints.display')

vim.api.nvim_buf_set_var(vim.api.nvim_get_current_buf(), 'lsp_ready', false)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- if client.server_capabilities.definitionProvider then
    --   vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    -- end
    vim.api.nvim_buf_set_var(bufnr, 'lsp_ready', true)
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local bufnr = args.buf
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- if client.server_capabilities.definitionProvider then
    --   vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    -- end
    vim.api.nvim_buf_set_var(bufnr, 'lsp_ready', false)
  end,
})

local lsp_is_ready = function(bufnr)
  if type(vim.b.lsp_ready) == nil then
    vim.api.nvim_buf_set_var(vim.api.nvim_get_current_buf(), 'lsp_ready', false)
    return false
  else
    return vim.api.nvim_buf_set_var(vim.api.nvim_get_current_buf(), 'lsp_ready', false)
  end
end

local update = function(config)
  local delays = config.debounce_delays
  if lsp_is_ready() and not utils.is_cursor_on_whitespace() then
    if utils.supports_method('definitionProvider') then
      utils.throttle(definitions, delays.definitions, config, 'definitions')
    end
    if utils.supports_method('referencesProvider') then
      utils.throttle(references, delays.references, config, 'references')
    end
    if utils.supports_method('codeactionsProvider') then
      utils.throttle(codeactions, delays.codeactions, config, 'codeactions')
    end
  end
end

return { update = update }
