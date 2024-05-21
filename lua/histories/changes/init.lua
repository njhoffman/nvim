local utils = require('histories.utils')
local view = require('histories.changes.view')

local get_change_list = function(bufnr)
  return vim.fn.getchangelist(bufnr or vim.api.nvim_get_current_buf()) or {}
end

local get_items = function(bufnr)
  local changelist = get_change_list(bufnr)
  return utils.process_list(changelist[1] or {}, changelist[2] or {})
end

local is_popup = function(winnr)
  return vim.tbl_get(vim.api.nvim_win_get_config(winnr), 'relative') ~= ''
end

local watch_changes = function()
  local timer = vim.loop.new_timer()
  local last_hash = 0
  if timer then
    timer:start(
      1000,
      2000,
      vim.schedule_wrap(function()
        local winnr = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        if is_popup(winnr) then
          return false
        end
        local changes, hash_id = get_items(bufnr)
        if hash_id ~= last_hash then
          view.load(changes)
          last_hash = hash_id
        end
      end)
    )
  end
end

local set_keys = function()
  local mappings = {
    ['g;'] = 'next',
    ['g:'] = 'prev',
    ['<esc>'] = 'close',
  }

  for key, action in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      key,
      string.format(':lua require("histories.changes.actions").%s()<CR>', action),
      { noremap = true, silent = true }
    )
  end
end

-- local close = function()
--   view.close()
-- end

local start = function(opts)
  opts = opts or {}
  if opts.setkeys then
    set_keys()
  end
  if opts.watch then
    watch_changes()
  else
    local changes = get_items()
    view.load(changes)
  end
end

-- watch_changes()

return { start = start }
