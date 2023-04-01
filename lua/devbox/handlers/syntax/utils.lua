local highlighter = require("vim.treesitter.highlighter")
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

local function get_ts_node(opts)
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

  local root_lang_tree = parsers.get_parser(bufnr)
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
  return results, node_under_cursor
end

local function get_hl_groups_at_position(bufnr, row, col)
  local buf_highlighter = highlighter.active[bufnr]
  if not buf_highlighter then
    return {}
  end

  local matches = {}
  buf_highlighter.tree:for_each_tree(function(tstree, tree)
    if not tstree then
      return
    end

    local root = tstree:root()
    local root_start_row, _, root_end_row, _ = root:range()

    -- Only worry about trees within the line range
    if root_start_row > row or root_end_row < row then
      return
    end

    -- Some injected languages may not have highlight queries.
    local query = buf_highlighter:get_query(tree:lang())
    if not query:query() then
      return
    end

    local iter = query:query():iter_captures(root, buf_highlighter.bufnr, row, row + 1)
    for capture, node, metadata in iter do
      local hl = query.hl_cache[capture]

      if hl and vim.treesitter.is_in_node_range(node, row, col) then
        local c = query._query.captures[capture] -- name of the capture in the query
        if c ~= nil then
          table.insert(matches, { capture = c, priority = metadata.priority })
        end
      end
    end
  end, true)
  return matches
end

-- require("nvim-treesitter-playground.hl-info").show_hl_captures()
local function get_treesitter_hl(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  -- require("nvim-treesitter-playground.utils").get_hl_groups_at_position(bufnr, row, col)
  local results = get_hl_groups_at_position(bufnr, row, col)
  local highlights = {}
  for _, hl in pairs(results) do
    local line = "* **@" .. hl.capture .. "**"
    if hl.priority then
      line = line .. "(" .. hl.priority .. ")"
    end
    table.insert(highlights, line)
  end
  return highlights
end

local function get_syntax_hl()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local matches = {}

  for _, i1 in ipairs(vim.fn.synstack(line, col)) do
    local i2 = vim.fn.synIDtrans(i1)
    local n1 = vim.fn.synIDattr(i1, "name")
    local n2 = vim.fn.synIDattr(i2, "name")
    table.insert(matches, "* " .. n1 .. " -> **" .. n2 .. "**")
  end

  return matches
end
local function get_hl_captures(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local captures = { treesitter = {}, syntax = {} }

  local function add_to_result(matches, source)
    if #matches == 0 then
      return
    end
    captures[source] = matches
  end

  if highlighter.active[bufnr] then
    local matches = get_treesitter_hl(opts)
    add_to_result(matches, "treesitter")
  end

  local current_syntax = vim.tbl_get(vim.b, "current_syntax")
  if current_syntax ~= nil then
    local matches = get_syntax_hl()
    add_to_result(matches, "syntax")
  end
  return captures
end

return {
  get_captures = get_hl_captures,
  get_node = get_ts_node,
}
