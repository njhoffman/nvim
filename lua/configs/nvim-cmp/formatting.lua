local icons = require("configs.nvim-cmp.icons")

local MIN_LABEL_WIDTH = 20
local ELLIPSIS_CHAR = "…"
local MAX_LABEL_WIDTH = 35

local config = {
  color_square_width = 2,
}

local format_tailwind = function(vim_item)
  local words = {}
  for word in string.gmatch(vim_item.word, "[^-]+") do
    table.insert(words, word)
  end

  local color_name, color_number
  if
    words[2] == "x"
    or words[2] == "y"
    or words[2] == "t"
    or words[2] == "b"
    or words[2] == "l"
    or words[2] == "r"
  then
    color_name = words[3]
    color_number = words[4]
  else
    color_name = words[2]
    color_number = words[3]
  end

  if color_name == "white" or color_name == "black" then
    local color
    if color_name == "white" then
      color = "ffffff"
    else
      color = "000000"
    end
    local hl_group = "lsp_documentColor_mf_" .. color
    vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
    vim_item.kind_hl_group = hl_group
    -- make the color square 2 chars wide
    vim_item.kind = string.rep("X", config.color_square_width)
    return vim_item
  elseif #words < 3 or #words > 4 then
    -- doesn't look like this is a tailwind css color
    return vim_item
  end

  if not color_name or not color_number then
    return vim_item
  end

  local color_index = tonumber(color_number)
  local tailwind_colors = require("configs.nvim-cmp.tailwind-colors")

  if not tailwind_colors[color_name] then
    return vim_item
  end

  if not tailwind_colors[color_name][color_index] then
    return vim_item
  end

  local color = tailwind_colors[color_name][color_index]
  local hl_group = "lsp_documentColor_mf_" .. color
  vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
  vim_item.kind_hl_group = hl_group

  -- make the color square 2 chars wide
  vim_item.kind = string.rep("X", config.color_square_width)
  return vim_item
end

local format = function(entry, vim_item)
  local label = vim_item.abbr or ""
  local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
  if truncated_label ~= label then
    vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
  elseif string.len(label) < MIN_LABEL_WIDTH then
    local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
    vim_item.abbr = label .. padding
  end

  vim_item.dup = ({ buffer = 1, path = 1, nvim_lsp = 0 })[entry.source.name] or 1
  if type(icons.names[entry.source.name]) == "nil" then
    vim.notify("No source icon: " .. entry.source.name, 2)
  else
    vim_item.menu = icons.names[entry.source.name][1]
    vim_item.menu_hl_group = icons.names[entry.source.name][2]
  end

  if type(icons.symbols[vim_item.kind]) == "nil" then
    vim.notify("No symbol icon: " .. (vim_item.kind or vim.inspect(vim_item)), 2)
  else
    vim_item.kind_hl_group = "CmpItemKind" .. vim_item.kind
    vim_item.kind = icons.symbols[vim_item.kind]
  end

  if vim.tbl_contains({ "nvim_lsp" }, entry.source.name) then
    vim_item = format_tailwind(vim_item)
  end
  return vim_item
end

return {
  expandable_indicator = true,
  fields = { "menu", "abbr", "kind" },
  format = format,
}
