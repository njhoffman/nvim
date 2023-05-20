local get_references = function()
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
  local res = vim.lsp.buf_request_sync(0, 'textDocument/references', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if client.result then
      n = n + #client.result
    end
  end
  return n
end

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

local update_lsp_code_actions = function(bufnr)
  vim.api.nvim_buf_set_var(bufnr, 'status_count_code_actions', get_code_actions())
end

local helputils = require('utils.helptags')
local get_help_tag = function()
  local match = helputils.search_cursor_word()
  return match
end

local update_help_tags = function(bufnr)

  local ok, match = pcall(vim.api.nvim_buf_get_var, bufnr, 'status_help_tag')
  -- local ok, match = vim.api.nvim_buf_get_var(bufnr, 'status_help_tag')
  local new_match = get_help_tag()
  if new_match ~= match then
    vim.api.nvim_buf_set_var(bufnr, 'status_help_tag', new_match)
    vim.api.nvim_exec_autocmds('User', { pattern = 'StatusCountHelp' })
  end
end

local update_lsp_references = function(bufnr)
  vim.api.nvim_buf_set_var(bufnr, 'status_count_references', get_references())
end

local timerutils = require('utils.timer')
-- local update_lsp = timerutils.debounce_trailing(update_lsp_counts, 500)

local au_group = vim.api.nvim_create_augroup('StatusCount', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'javascript', 'typescript', 'python', 'go', 'sh' },
  group = au_group,
  callback = function(ev)
    vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
      group = au_group,
      buffer = ev.buf,
      callback = function()
        if vim.bo.filetype == 'lua' then
          update_help_tags(ev.buf)
        end
        -- if #vim.lsp.get_active_clients() > 0 then
        --   vim.dbglog('autocmd', ev.buf)
        --   -- if vim.bo.buftype == '' then
        --   --   -- vim.api.nvim_buf_set_var(ev.buf, 'lsp_count_code_actions', 0)
        --   --   -- vim.api.nvim_buf_set_var(ev.buf, 'lsp_count_references', 0)
        --   --   update_lsp_code_actions(ev.buf)
        --   --   update_lsp_references(ev.buf)
        --   -- end
        -- end
      end,
    })
  end,
})
