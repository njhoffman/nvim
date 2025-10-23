local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')

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
      return table.concat(reverse, ' -> ')
    end
    return get_full_path(parent, vim.list_extend(array or {}, { node }))
  end

  opts = vim.tbl_deep_extend('keep', opts or {}, {
    full_path = false,
    show_range = true,
    include_anonymous = false,
    highlight_node = true,
    hl_group = 'TSPlaygroundFocus',
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
  if not root_lang_tree then
    return { results = results }
  end
  local lang_tree = root_lang_tree:language_for_range({ line, col, line, col })
  for _, tree in ipairs(lang_tree:trees()) do
    local root = tree:root()
    if root and vim.treesitter.is_in_node_range(root, line, col) then
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

-- Get column positions of all nodes to the left and right of cursor
local function get_node_columns_around_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1] - 1  -- Convert to 0-indexed
  local cursor_col = cursor[2]

  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    return {}, {}
  end

  parser:parse(true)
  local left_columns = {}
  local right_columns = {}

  local lang_tree = parser:language_for_range({ current_line, 0, current_line, -1 })

  for _, tree in ipairs(lang_tree:trees()) do
    local root = tree:root()

    local function traverse(node)
      local start_row, start_col, end_row, end_col = node:range()

      -- Check if node starts on current line
      if start_row == current_line then
        if start_col < cursor_col then
          table.insert(left_columns, start_col)
        elseif start_col > cursor_col then
          table.insert(right_columns, start_col)
        end
      end

      -- Only traverse children if they could be on our line
      if start_row <= current_line and end_row >= current_line then
        for child in node:iter_children() do
          traverse(child)
        end
      end
    end

    traverse(root)
  end

  -- Remove duplicates and sort
  local function dedupe_and_sort(columns)
    local unique = {}
    for _, col in ipairs(columns) do
      unique[col] = true
    end

    local result = {}
    for col in pairs(unique) do
      table.insert(result, col)
    end
    table.sort(result)
    return result
  end

  local left_sorted = dedupe_and_sort(left_columns)
  local right_sorted = dedupe_and_sort(right_columns)

  return left_sorted, right_sorted
end

return {
  get_node = get_node,
  highlight_node = ts_utils.highlight_node,
  get_node_columns_around_cursor = get_node_columns_around_cursor,
}
