local helputils = require('utils.helptags')

local busy = {
  helptags = false,
  references = false,
  code_actions = false,
}

local get_code_actions = function()
  local bufnr = tonumber(vim.g.actual_curbuf) or 0
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local res = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if client.result then
      n = n + #client.result
    end
  end
  return n
end

local update_help_tags = function(bufnr)
  busy.helptags = true
  return function()
    local ok, match = pcall(vim.api.nvim_buf_get_var, bufnr, 'status_help_tag')
    local new_match = helputils.search_cursor_word()
    if new_match ~= match then
      vim.api.nvim_buf_set_var(bufnr, 'status_help_tag', new_match)
      vim.api.nvim_exec_autocmds('User', { pattern = 'StatusCountHelp' })
    end
    busy.helptags = false
  end
end

-- local timerutils = require('utils.timer')
-- local update_lsp = timerutils.debounce_trailing(update_lsp_counts, 500)

local get_references = function(bufnr)
  busy.references = true
  return function()
    -- vim.lsp.client.requests
    local params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
    local res = vim.lsp.buf_request_sync(0, 'textDocument/references', params) or {}
    local n = 0
    for _, client in ipairs(res) do
      if client.result then
        n = n + #client.result
      end
    end
    local ok, old_n = pcall(vim.api.nvim_buf_get_var, bufnr, 'lsp_cursor_references')
    if n ~= old_n then
      vim.api.nvim_buf_set_var(bufnr, 'lsp_cursor_references', n)
      vim.api.nvim_exec_autocmds('User', { pattern = 'StatusCountReferences' })
    end
    busy.references = false
  end
end

local get_cursor_counts = function(ev)
  return function()
    if busy.helptags == false and vim.bo.filetype == 'lua' then
      vim.defer_fn(update_help_tags(ev.buf), 200)
    end
    -- if busy.references == false and vim.bo.buftype == '' then
    --   if #vim.lsp.get_active_clients() > 0 then
    --     vim.defer_fn(get_references(ev.buf), 1000)
    --   end
    -- end
    -- vim.api.nvim_buf_set_var(ev.buf, 'lsp_cursor_code_actions', get_code_actions())
  end
end

-- local au_group = vim.api.nvim_create_augroup('StatusbarCounts', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'lua', 'javascript', 'typescript', 'python', 'go', 'sh' },
--   group = au_group,
--   callback = function(ev)
--     vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
--       group = au_group,
--       buffer = ev.buf,
--       callback = function()
--         vim.defer_fn(get_cursor_counts(ev), 200)
--       end,
--     })
-- })
--   end,
