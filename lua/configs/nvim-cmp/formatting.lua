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

local config = {
  color_square_width = 2,
}

local format_tailwind = function(vim_item)
  local words = {}
  for word in string.gmatch(vim_item.word, '[^-]+') do
    table.insert(words, word)
  end

  local color_name, color_number
  if words[2] == 'x' or words[2] == 'y' or words[2] == 't' or words[2] == 'b' or words[2] == 'l' or words[2] == 'r' then
    color_name = words[3]
    color_number = words[4]
  else
    color_name = words[2]
    color_number = words[3]
  end

  if color_name == 'white' or color_name == 'black' then
    local color
    if color_name == 'white' then
      color = 'ffffff'
    else
      color = '000000'
    end
    local hl_group = 'lsp_documentColor_mf_' .. color
    vim.api.nvim_set_hl(0, hl_group, { fg = '#' .. color, bg = '#' .. color })
    vim_item.kind_hl_group = hl_group
    -- make the color square 2 chars wide
    vim_item.kind = string.rep('X', config.color_square_width)
    return vim_item
  elseif #words < 3 or #words > 4 then
    -- doesn't look like this is a tailwind css color
    return vim_item
  end

  if not color_name or not color_number then
    return vim_item
  end

  local color_index = tonumber(color_number)
  local tailwind_colors = require('configs.nvim-cmp.tailwind-colors')

  if not tailwind_colors[color_name] then
    return vim_item
  end

  if not tailwind_colors[color_name][color_index] then
    return vim_item
  end

  local color = tailwind_colors[color_name][color_index]
  local hl_group = 'lsp_documentColor_mf_' .. color
  vim.api.nvim_set_hl(0, hl_group, { fg = '#' .. color, bg = '#' .. color })
  vim_item.kind_hl_group = hl_group

  -- make the color square 2 chars wide
  vim_item.kind = string.rep('X', config.color_square_width)
  return vim_item
end

-- vim_item.menu = ({ nvim_lsp = '', buffer   = '', })[entry.source.name]
-- vim_item.kind = ({ Text          = '', TypeParameter = '', })[vim_item.kind]
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

  vim_item.dup = ({ buffer = 1, path = 1, nvim_lsp = 0 })[entry.source.name] or 1
  if type(icons.names[entry.source.name]) == 'nil' then
    vim.notify('No source icon: ' .. entry.source.name, 2)
  else
    vim_item.menu = icons.names[entry.source.name][1]
    vim_item.menu_hl_group = icons.names[entry.source.name][2]
  end

  if type(icons.symbols[vim_item.kind]) == 'nil' then
    vim.notify('No symbol icon: ' .. vim_item.kind, 2)
  else
    vim_item.kind_hl_group = 'CmpItemKind' .. vim_item.kind
    vim_item.kind = icons.symbols[vim_item.kind]
  end

  -- -- switch source and symbol icons
  -- local tmp = vim_item.menu or ''
  -- vim_item.menu = vim_item.kind .. ' '
  -- vim_item.kind = ' ' .. tmp
  -- tmp = vim_item.menu_hl_group or ''
  -- vim_item.menu_hl_group = vim_item.kind_hl_group or ''
  -- vim_item.kind_hl_group = tmp

  if vim.tbl_contains({ 'nvim_lsp' }, entry.source.name) then
    vim_item = format_tailwind(vim_item)
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
--     item_with_kind.menu = item_with_kind.menu .. [[ -> ]]):):):format()format()format()):format() .. completion_context):):format()format()
--   end
--   return item_with_kind
-- end,

return {
  fields = { 'menu', 'abbr', 'kind' },
  format = format,
}
