local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

local function get_node(opts)
  opts = opts or {}
  local function get_full_path(node, array)
    local parent = node:parent()
    if parent == nil then
      if array == nil then
        return node:type()
      end
      local reverse = vim.tbl_map(function(index)
        return array[#array + 1 - index]:type()
      end, vim.tbl_keys(array))
      return table.concat(reverse, " -> ")
    end
    return get_full_path(parent, vim.list_extend(array or {}, { node }))
  end

  opts = vim.tbl_deep_extend("keep", opts or {}, {
    full_path = false,
    show_range = true,
    include_anonymous = false,
    highlight_node = true,
    hl_group = "TSPlaygroundFocus",
  })

  if not parsers.has_parser() then
    return
  end

  local node_under_cursor
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local col = cursor[2]

  local results = {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local root_lang_tree = parsers.get_parser(bufnr)
  local lang_tree = root_lang_tree:language_for_range({ line, col, line, col })
  for _, tree in ipairs(lang_tree:trees()) do
    local root = tree:root()
    if root and vim.treesitter.is_in_node_range(root, line, col) then
      vim.dbglog("line", line, col, line, col)
      local node = root:named_descendant_for_range(line, col, line, col)
      local anonymous_node = root:descendant_for_range(line, col, line, col)
      node_under_cursor = node

      local srow, scol, erow, ecol = ts_utils.get_vim_range({ node:range() }, bufnr)

      local text = vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
      local result = {
        parser = lang_tree:lang(),
        text = text,
        path = node:type(),
        full_path = get_full_path(node),
        anonymous = anonymous_node:type(),
        range = { srow = srow, erow = erow, scol = scol, ecol = ecol },
      }
      table.insert(results, result)
    end
  end
  return { results, node_under_cursor }
end

return {
  get_node = get_node,
  highlight_node = ts_utils.highlight_node,
}
