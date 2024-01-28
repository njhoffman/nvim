local logger = require('logger').init('qf-diagnostics')
local q = require('quickfix.diagnostics.qflist')

local setup = function(config)
  local augroup = vim.api.nvim_create_augroup('LspDiagQuickfix', { clear = true })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = augroup,
    callback = function(ev)
      local diagnostics = ev.data.diagnostics
      logger:trace(ev.event .. ' ' .. ev.buf .. ' ' .. #diagnostics)
      q.diagnostics_hook(true)
    end,
  })

  -- vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'BufWritePost' }, {
  --   group = augroup,
  --   callback = function(ev)
  --     vim.dbglog(ev.event)
  --     require('quickfix.diagnostics').diagnostics_hook(false)
  --   end,
  -- })

  vim.api.nvim_create_user_command('QfDiagAll', function(ev)
    -- if none notify that workplace diagnostics being watched
    q.open_all_diagnostics()
  end, { desc = 'populate quickfix with workspace diagnostics' })

  -- vim.api.nvim_create_user_command('LspQfRefs', function()
  --   vim.lsp.buf.references()
  -- end, {})
  -- vim.keymap.set("n", "<leader>qd", function()
  --     vim.diagnostic.setqflist({
  --         open = true,
  --         title = "Diagnostics",
  --         severity = {min = vim.diagnostic.severity.HINT}
  --     })
  -- end, {desc = "populate quickfix with diagnostics"})
end

return {
  setup = setup,
}
