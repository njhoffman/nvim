local icons = require('configs.nvim-cmp.icons')

local MIN_LABEL_WIDTH = 20
local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 35
local SYMBOL_MAP = require('utils.lspkind').SYMBOL_MAP

local function get_lsp_completion_context(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end
  if source_name == 'tsserver' then
    return completion.detail
  elseif source_name == 'pyright' then
    if completion.labelDetails ~= nil then
      return completion.labelDetails.description
    end
  end
end

-- format = require('tailwindcss-colorizer-cmp').formatter,
local format = function(entry, vim_item)
  local label = vim_item.abbr or ''
  local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
  if truncated_label ~= label then
    vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
  elseif string.len(label) < MIN_LABEL_WIDTH then
    local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
    vim_item.abbr = label .. padding
  end
  -- vim_item.menu = ({ nvim_lsp = '', buffer   = '', })[entry.source.name]
  -- vim_item.kind = ({ Text          = '', TypeParameter = '', })[vim_item.kind]
  vim_item.dup = ({ buffer = 1, path = 1, nvim_lsp = 0 })[entry.source.name] or 1
  if type(icons.names[entry.source.name]) == 'nil' then
    vim.notify('No source icon: ' .. entry.source.name, 2)
  else
    vim_item.menu = icons.names[entry.source.name][1] .. ' '
    vim_item.menu_hl_group = icons.names[entry.source.name][2]
  end
  if type(icons.symbols[vim_item.kind]) == 'nil' then
    vim.notify('No symbol icon: ' .. vim_item.kind, 2)
    vim_item.kind = ' '
  else
    vim_item.kind = ' ' .. icons.symbols[vim_item.kind]
  end
  return vim_item
end
-- format = function(entry, vim_item)
--   local item_with_kind = require('lspkind').cmp_format({
--     mode = 'symbol_text',
--     maxwidth = MAX_LABEL_WIDTH,
--     symbol_map = SYMBOL_MAP,
--   })(entry, vim_item)
--
--   local kind_s_menu = vim.split(item_with_kind.kind, '%s', { trimempty = true })
--   item_with_kind.kind = ' ' .. (kind_s_menu[1] or '') .. ' '
--   item_with_kind.menu = '    (' .. (kind_s_menu[2] or '') .. ')'
--   item_with_kind.menu = vim.trim(item_with_kind.menu)
--
--   local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
--   if completion_context ~= nil and completion_context ~= '' then
--     item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
--   end
--   return item_with_kind
-- end,

return {
  fields = { 'menu', 'abbr', 'kind' },
  format = format,
}
