local utils = require('quickfix.diagnostics.utils')
local state = require('quickfix.diagnostics.state')
local config = require('quickfix.diagnostics.config')

local is_open = function()
  for i = 0, vim.fn.winnr('$') - 1 do
    local bufnr = vim.fn.winbufnr(i)
    if vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == 'quickfix' then
      return i
    end
  end
  return false
end

local is_foreign = function()
  return vim.fn.getqflist({ title = 0 }).title ~= config.title
end

local sort_by_type = function(priority_uri)
  return function(a, b)
    local atypen = utils.type_to_num(a.type)
    local btypen = utils.type_to_num(b.type)

    if atypen < btypen then
      return true
    end

    if atypen == btypen then
      local aok, auri = pcall(vim.uri_from_bufnr(a.bufnr))
      local bok, buri = pcall(vim.uri_from_bufnr(b.bufnr))

      if aok and bok and auri == buri then
        return a.lnum < b.lnum
      end

      if aok and priority_uri then
        return auri == priority_uri
      end
    end
    return false
  end
end

local get_qflist = function(opts)
  local all_diags = vim.diagnostic.get(opts.bufnr)
  local qflist = vim.diagnostic.toqflist(all_diags)

  if opts.sort_by_type then
    table.sort(qflist, sort_by_type(opts.priority_uri))
  end
  return qflist
end

local populate_qflist = function()
  local priority_uri = vim.uri_from_bufnr(0)

  -- entering same buffer as we were before focusing quickfix
  -- if not state.change_since_render and priority_uri == state.last_priority_uri then
  --   return
  -- end

  if string.sub(priority_uri, 0, 7) == 'file://' and string.len(priority_uri) > 7 then
    state.last_priority_uri = priority_uri
  else
    priority_uri = state.last_priority_uri
  end

  local all_diagnostics = get_qflist({
    priority_uri = priority_uri,
    bufnr = nil,
  })

  require('qf').set('c', { title = config.title, items = all_diagnostics })
  require('qf').follow('c', 'nearest')
  -- vim.fn.setqflist({}, 'r', { title = config.title })
  -- vim.fn.setqflist(all_diagnostics, 'r')
  -- vim.diagnostic.setqflist({
  --   open = false,
  --   title = config.title,
  --   severity = { min = vim.diagnostic.severity.HINT },
  -- })
  state.change_since_render = false
end

local open_all_diagnostics = function()
  populate_qflist()
  -- vim.api.nvim_command('copen')
end

local debounced_fn = utils.debounce_trailing(config.debounce_ms, populate_qflist)

local diagnostics_hook = function(lsp_changed)
  state.change_since_render = true
  if not is_foreign() and is_open() then
    debounced_fn()
    -- elseif debug then
    --   vim.dbglog('foreign quickfix, not populating  ' .. tostring(lsp_changed))
  end
end

local setup = function(opts)
  config = opts
  debounced_fn = utils.debounce_trailing(opts.debounce_ms, populate_qflist)
end

return {
  setup = setup,
  diagnostics_hook = diagnostics_hook,
  open_all_diagnostics = open_all_diagnostics,
  populate_qflist = populate_qflist,
  is_open = is_open,
}
