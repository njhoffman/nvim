local lib_get_ts_nodes = require('SelectEase.lib.get_ts_nodes')

local function get_node_text(node, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not node then
    return {}
  end
  local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(node)
  if start_row ~= end_row then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    if next(lines) == nil then
      return {}
    end
    lines[1] = string.sub(lines[1], start_col + 1)
    if #lines == end_row - start_row + 1 then
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return lines
  else
    local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    return line and { string.sub(line, start_col + 1, end_col) } or {}
  end
end

local function node_to_lsp_range(node)
  local start_line, start_col, end_line, end_col = vim.treesitter.get_node_range(node)
  return {
    start = { line = start_line, character = start_col },
    ["end"] = { line = end_line, character = end_col },
  }
end

local function swap_ts_nodes(node_or_range1, node_or_range2, bufnr, cursor_to_second)
  if not node_or_range1 or not node_or_range2 then
    return
  end
  local range1 = node_to_lsp_range(node_or_range1)
  local range2 = node_to_lsp_range(node_or_range2)

  local text1 = get_node_text(node_or_range1, bufnr)
  local text2 = get_node_text(node_or_range2, bufnr)

  local edit1 = { range = range1, newText = table.concat(text2, "\n") }
  local edit2 = { range = range2, newText = table.concat(text1, "\n") }
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  vim.lsp.util.apply_text_edits({ edit1, edit2 }, bufnr, "utf-8")

  if cursor_to_second then
    vim.cmd("normal! m'")

    local char_delta = 0
    local line_delta = 0
    if
      range1["end"].line < range2.start.line
      or (
        range1["end"].line == range2.start.line
        and range1["end"].character <= range2.start.character
      )
    then
      line_delta = #text2 - #text1
    end

    if
      range1["end"].line == range2.start.line
      and range1["end"].character <= range2.start.character
    then
      if line_delta ~= 0 then
        char_delta = #text2[#text2] - range1["end"].character
        if range1.start.line == range2.start.line + line_delta then
          char_delta = char_delta + range1.start.character
        end
      else
        char_delta = #text2[#text2] - #text1[#text1]
      end
    end

    vim.api.nvim_win_set_cursor(
      vim.api.nvim_get_current_win(),
      { range2.start.line + 1 + line_delta, range2.start.character + char_delta }
    )
  end
end

local get_sequential_jump_target = function(opts, nodes, cursor_row, cursor_col)
  local jump_target

  if opts.direction == 'next' then
    for _, node in ipairs(nodes) do
      local start_row, start_col, _, _ = node:range()
      if cursor_row == start_row and cursor_col < start_col then
        jump_target = node
        break
      end
      if not opts.current_line_only and (cursor_row < start_row) then
        jump_target = node
        break
      end
    end
  elseif opts.direction == 'previous' then
    for i = #nodes, 1, -1 do
      local node = nodes[i]
      local start_row, start_col, _, _ = node:range()
      if cursor_row == start_row and cursor_col > start_col then
        jump_target = node
        break
      end
      if not opts.current_line_only and (cursor_row > start_row) then
        jump_target = node
        break
      end
    end
  end

  return jump_target
end

local find_node_with_smallest_range = function(nodes)
  local smallest_row = math.huge
  local smallest_col = math.huge
  local smallest_node = nil

  for _, node in ipairs(nodes) do
    local start_row, start_col, end_row, end_col = node:range()
    local num_rows = end_row - start_row + 1
    local num_cols = end_col - start_col + 1

    if num_rows < smallest_row then
      smallest_row = num_rows
      smallest_col = num_cols
      smallest_node = node
    elseif num_rows == smallest_row and num_cols < smallest_col then
      smallest_col = num_cols
      smallest_node = node
    end
  end

  return smallest_node
end

local node_covers_cursor = function(node, cursor_row, cursor_col)
  local start_row, start_col, end_row, end_col = node:range()

  if start_row ~= end_row and start_row <= cursor_row and end_row >= cursor_row then
    return true
  end

  if start_row == end_row and start_row == cursor_row then
    if start_col <= cursor_col and end_col >= cursor_col then
      return true
    end
  end

  return false
end

local find_nodes_that_cover_cursor = function(nodes, cursor_row, cursor_col)
  local cutoff_index = 1
  local nodes_that_cover_cursor = {}

  for i, node in ipairs(nodes) do
    if node_covers_cursor(node, cursor_row, cursor_col) then
      table.insert(nodes_that_cover_cursor, node)
      cutoff_index = i
    end
  end

  return nodes_that_cover_cursor, cutoff_index
end

local find_left_most_node = function(nodes)
  local left_most = math.huge
  local left_most_node = nodes[1]

  for _, node in ipairs(nodes) do
    local _, start_col, _, _ = node:range()
    if start_col < left_most then
      left_most = start_col
      left_most_node = node
    end
  end

  return left_most_node
end

local function node_is_possible_candidate(start_col, end_col, sn_start_col, sn_end_col)
  return start_col >= sn_start_col and start_col <= sn_end_col
    or end_col >= sn_start_col and end_col <= sn_end_col
    or start_col <= sn_start_col and end_col >= sn_end_col
end

local get_vertical_drill_jump_target = function(opts, nodes, cursor_row, cursor_col)
  local nodes_that_cover_cursor, cutoff_index =
    find_nodes_that_cover_cursor(nodes, cursor_row, cursor_col)
  local smallest_node = find_node_with_smallest_range(nodes_that_cover_cursor)

  if smallest_node then
    local _, sn_start_col, _, sn_end_col = smallest_node:range()

    local candidates = {}

    local loop_start = cutoff_index
    local loop_end = opts.direction == 'next' and #nodes or 1
    local loop_step = opts.direction == 'previous' and -1 or 1

    for i = loop_start, loop_end, loop_step do
      local node = nodes[i]
      local start_row, start_col, _, end_col = node:range()

      if
        (start_row > cursor_row and opts.direction == 'next')
        or (start_row < cursor_row and opts.direction == 'previous')
      then
        if node_is_possible_candidate(start_col, end_col, sn_start_col, sn_end_col) then
          if #candidates == 0 or candidates[1]:range() == start_row then
            table.insert(candidates, node)
          else
            break
          end
        end
      end
    end

    if #candidates > 0 then
      local left_most_node = find_left_most_node(candidates)
      return left_most_node
    end
  end
end

local get_jump_target = function(opts)
  local queries = opts.queries or {}
  local nodes = lib_get_ts_nodes.get_nodes_from_query(opts.query, queries)

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row, cursor_col = cursor[1] - 1, cursor[2]

  local jump_target
  if opts.vertical_drill_jump then
    jump_target = get_vertical_drill_jump_target(opts, nodes, cursor_row, cursor_col)
  else
    jump_target = get_sequential_jump_target(opts, nodes, cursor_row, cursor_col)
  end

  return jump_target
end

local swap_nodes = function(opts)
  if vim.fn.mode() == 's' then
    vim.cmd('norm! ')
  end

  local queries = opts.queries or {}
  local nodes = lib_get_ts_nodes.get_nodes_from_query(opts.query, queries)

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row, cursor_col = cursor[1] - 1, cursor[2]

  local nodes_that_cover_cursor = find_nodes_that_cover_cursor(nodes, cursor_row, cursor_col)
  local smallest_node = find_node_with_smallest_range(nodes_that_cover_cursor)

  if smallest_node then
    local first_node = smallest_node
    local target_node = get_jump_target(opts)

    local bufnr = vim.api.nvim_get_current_buf()
    swap_ts_nodes(first_node, target_node, bufnr, opts.jump_to_target_after_swap or true)
  end
end

return swap_nodes
