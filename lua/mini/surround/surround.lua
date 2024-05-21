local Config = require('mini.surround.Config')
local Span = require('mini.surround.Span')
local utils = require('mini.surround.utils')

local H = {}

-- Work with surrounding info -------------------------------------------------
H.get_surround_spec = function(sur_type, use_cache)
  local res

  -- Try using cache
  if use_cache then
    res = Config.cache[sur_type]
    if res ~= nil then
      return res
    end
  else
    Config.cache = {}
  end

  -- Prompt user to enter identifier of surrounding
  local char = H.user_surround_id(sur_type)
  if char == nil then
    return nil
  end

  -- Get surround specification
  res = H.make_surrounding_table()[char][sur_type]

  -- Allow function returning spec or surrounding region(s)
  if vim.is_callable(res) then
    res = res()
  end

  -- Do nothing if supplied not appropriate structure
  if not H.is_surrounding_info(res, sur_type) then
    return nil
  end

  -- Wrap callable tables to be an actual functions. Otherwise they might be
  -- confused with list of patterns.
  if H.is_composed_pattern(res) then
    res = vim.tbl_map(utils.wrap_callable_table, res)
  end

  -- Track identifier for possible messages. Use metatable to pass
  -- `vim.tbl_islist()` check.
  res = setmetatable(res, { __index = { id = char } })

  -- Cache result
  if use_cache then
    Config.cache[sur_type] = res
  end

  return res
end

H.make_surrounding_table = function()
  -- Extend builtins with data from `config`
  local surroundings = vim.tbl_deep_extend(
    'force',
    Config.builtin_surroundings,
    Config.get_config().custom_surroundings or {}
  )

  -- Add possibly missing information from default surrounding info
  for char, info in pairs(surroundings) do
    local default = Config.get_default_surrounding_info(char)
    surroundings[char] = vim.tbl_deep_extend('force', default, info)
  end

  -- Use default surrounding info for not supplied single character identifier
  --stylua: ignore start
  return setmetatable(surroundings, {
    __index = function(_, key) return Config.get_default_surrounding_info(key) end,
  })
  --stylua: ignore end
end

H.is_surrounding_info = function(x, sur_type)
  if sur_type == 'input' then
    return H.is_composed_pattern(x) or H.is_region_pair(x) or H.is_region_pair_array(x)
  elseif sur_type == 'output' then
    return (type(x) == 'table' and type(x.left) == 'string' and type(x.right) == 'string')
  end
end

H.is_region = function(x)
  if type(x) ~= 'table' then
    return false
  end
  local from_is_valid = type(x.from) == 'table'
    and type(x.from.line) == 'number'
    and type(x.from.col) == 'number'
  -- Allow `to` to be `nil` to describe empty regions
  local to_is_valid = true
  if x.to ~= nil then
    to_is_valid = type(x.to) == 'table'
      and type(x.to.line) == 'number'
      and type(x.to.col) == 'number'
  end
  return from_is_valid and to_is_valid
end

H.is_region_pair = function(x)
  if type(x) ~= 'table' then
    return false
  end
  return H.is_region(x.left) and H.is_region(x.right)
end

H.is_region_pair_array = function(x)
  if not vim.tbl_islist(x) then
    return false
  end
  for _, v in ipairs(x) do
    if not H.is_region_pair(v) then
      return false
    end
  end
  return true
end

H.is_composed_pattern = function(x)
  if not (vim.tbl_islist(x) and #x > 0) then
    return false
  end
  for _, val in ipairs(x) do
    local val_type = type(val)
    if not (val_type == 'table' or val_type == 'string' or vim.is_callable(val)) then
      return false
    end
  end
  return true
end

-- Work with finding surrounding ----------------------------------------------
---@param surr_spec table Composed pattern. Last item(s) - extraction template.
---@param opts table Options.
---@private
H.find_surrounding = function(surr_spec, opts)
  if surr_spec == nil then
    return
  end
  if H.is_region_pair(surr_spec) then
    return surr_spec
  end

  opts = vim.tbl_deep_extend('force', Config.get_default_opts(), opts or {})
  Config.validate_search_method(opts.search_method, 'search_method')

  local region_pair = H.find_surrounding_region_pair(surr_spec, opts)
  if region_pair == nil then
    local msg = ([[No surrounding '%s%s' found within %d line%s and `config.search_method = '%s'`.]]):format(
      opts.n_times > 1 and opts.n_times or '',
      surr_spec.id,
      opts.n_lines,
      opts.n_lines > 1 and 's' or '',
      opts.search_method
    )
    Config.message(msg)
  end

  return region_pair
end

H.find_surrounding_region_pair = function(surr_spec, opts)
  local reference_region, n_times, n_lines = opts.reference_region, opts.n_times, opts.n_lines

  if n_times == 0 then
    return
  end

  -- Find `n_times` matching spans evolving from reference region span
  -- First try to find inside 0-neighborhood
  local neigh = H.get_neighborhood(reference_region, 0)
  local reference_span = neigh.region_to_span(reference_region)

  local find_next = function(cur_reference_span)
    local res = H.find_best_match(neigh, surr_spec, cur_reference_span, opts)

    -- If didn't find in 0-neighborhood, possibly try extend one
    if res.span == nil then
      -- Stop if no need to extend neighborhood
      if n_lines == 0 or neigh.n_neighbors > 0 then
        return {}
      end

      -- Update data with respect to new neighborhood
      local cur_reference_region = neigh.span_to_region(cur_reference_span)
      neigh = H.get_neighborhood(reference_region, n_lines)
      reference_span = neigh.region_to_span(reference_region)
      cur_reference_span = neigh.region_to_span(cur_reference_region)

      -- Recompute based on new neighborhood
      res = H.find_best_match(neigh, surr_spec, cur_reference_span, opts)
    end

    return res
  end

  local find_res = { span = reference_span }
  for _ = 1, n_times do
    find_res = find_next(find_res.span)
    if find_res.span == nil then
      return
    end
  end

  -- Extract final span
  local extract = function(span, extract_pattern)
    -- Use table extract pattern to allow array of regions as surrounding spec
    -- Pair of spans is constructed based on best region pair
    if type(extract_pattern) == 'table' then
      return extract_pattern
    end

    -- First extract local (with respect to best matched span) surrounding spans
    local s = neigh['1d']:sub(span.from, span.to - 1)
    local local_surr_spans = H.extract_surr_spans(s, extract_pattern)

    -- Convert local spans to global
    local off = span.from - 1
    local left, right = local_surr_spans.left, local_surr_spans.right
    return {
      left = { from = left.from + off, to = left.to + off },
      right = { from = right.from + off, to = right.to + off },
    }
  end

  local final_spans = extract(find_res.span, find_res.extract_pattern)
  local outer_span = { from = final_spans.left.from, to = final_spans.right.to }

  -- Ensure that output region is different from reference.
  if Span.is_span_covering(reference_span, outer_span) then
    find_res = find_next(find_res.span)
    if find_res.span == nil then
      return
    end
    final_spans = extract(find_res.span, find_res.extract_pattern)
    outer_span = { from = final_spans.left.from, to = final_spans.right.to }
    if Span.is_span_covering(reference_span, outer_span) then
      return
    end
  end

  -- Convert to region pair
  return {
    left = neigh.span_to_region(final_spans.left),
    right = neigh.span_to_region(final_spans.right),
  }
end

-- Work with treesitter surrounding -------------------------------------------
H.prepare_captures = function(captures)
  local is_capture = function(x)
    return type(x) == 'string' and x:sub(1, 1) == '@'
  end

  if
    not (type(captures) == 'table' and is_capture(captures.outer) and is_capture(captures.inner))
  then
    Config.error(
      'Wrong format for `captures`. See `MiniSurround.gen_spec.input.treesitter()` for details.'
    )
  end

  return { outer = captures.outer, inner = captures.inner }
end

H.get_matched_node_pairs_plugin = function(captures)
  local ts_queries = require('nvim-treesitter.query')
  local ts_parsers = require('nvim-treesitter.parsers')

  -- This is a modified version of `ts_queries.get_capture_matches_recursively`
  -- source code which keeps track of match language
  local matches = {}
  local parser = ts_parsers.get_parser(0)
  if parser then
    parser:for_each_tree(function(tree, lang_tree)
      local lang = lang_tree:lang()
      local lang_matches =
        ts_queries.get_capture_matches(0, captures.outer, 'textobjects', tree:root(), lang)
      for _, m in pairs(lang_matches) do
        m.lang = lang
      end
      vim.list_extend(matches, lang_matches)
    end)
  end

  return vim.tbl_map(
    function(match)
      local node_outer = match.node
      -- Pick inner node as the biggest node matching inner query. This is
      -- needed because query output is not quaranteed to come in order.
      local matches_inner =
        ts_queries.get_capture_matches(0, captures.inner, 'textobjects', node_outer, match.lang)
      local nodes_inner = vim.tbl_map(function(x)
        return x.node
      end, matches_inner)
      return { outer = node_outer, inner = H.get_biggest_node(nodes_inner) }
    end,
    -- This call should handle multiple languages in buffer
    matches
  )
end

H.get_matched_node_pairs_builtin = function(captures)
  -- Fetch treesitter data for buffer
  local lang = vim.bo.filetype
  local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
  if not ok then
    Config.error_treesitter('parser', lang)
  end

  local get_query = vim.fn.has('nvim-0.9') == 1 and vim.treesitter.query.get
    or vim.treesitter.get_query
  local query = get_query(lang, 'textobjects')
  if query == nil then
    Config.error_treesitter('query', lang)
  end

  -- Remove leading '@'
  local capture_outer, capture_inner = captures.outer:sub(2), captures.inner:sub(2)

  -- Compute nodes matching outer capture
  local nodes_outer = {}
  for _, tree in ipairs(parser:trees()) do
    vim.list_extend(nodes_outer, H.get_builtin_matched_nodes(capture_outer, tree:root(), query))
  end

  -- Make node pairs with biggest node matching inner capture inside outer node
  return vim.tbl_map(function(node_outer)
    local nodes_inner = H.get_builtin_matched_nodes(capture_inner, node_outer, query)
    return { outer = node_outer, inner = H.get_biggest_node(nodes_inner) }
  end, nodes_outer)
end

H.get_builtin_matched_nodes = function(capture, root, query)
  local res = {}
  for capture_id, node, _ in query:iter_captures(root, 0) do
    if query.captures[capture_id] == capture then
      table.insert(res, node)
    end
  end
  return res
end

H.get_biggest_node = function(node_arr)
  local best_node, best_byte_count = nil, -math.huge
  for _, node in ipairs(node_arr) do
    local _, _, start_byte = node:start()
    local _, _, end_byte = node:end_()
    local byte_count = end_byte - start_byte + 1
    if best_byte_count < byte_count then
      best_node, best_byte_count = node, byte_count
    end
  end

  return best_node
end

-- Work with matching spans ---------------------------------------------------
---@param neighborhood table Output of `get_neighborhood()`.
---@param surr_spec table
---@param reference_span table Span to cover.
---@param opts table Fields: <search_method>.
---@private
H.find_best_match = function(neighborhood, surr_spec, reference_span, opts)
  local best_span, best_nested_pattern, current_nested_pattern
  local f = function(span)
    if Span.is_better_span(span, best_span, reference_span, opts) then
      best_span = span
      best_nested_pattern = current_nested_pattern
    end
  end

  if H.is_region_pair_array(surr_spec) then
    -- Iterate over all spans representing outer regions in array
    for _, region_pair in ipairs(surr_spec) do
      -- Construct outer region used to find best region pair
      local outer_region =
        { from = region_pair.left.from, to = region_pair.right.to or region_pair.right.from }

      -- Consider outer region only if it is completely within neighborhood
      if neighborhood.is_region_inside(outer_region) then
        -- Make future extract pattern based directly on region pair
        current_nested_pattern = {
          {
            left = neighborhood.region_to_span(region_pair.left),
            right = neighborhood.region_to_span(region_pair.right),
          },
        }

        f(neighborhood.region_to_span(outer_region))
      end
    end
  else
    -- Iterate over all matched spans
    for _, nested_pattern in ipairs(utils.cartesian_product(surr_spec)) do
      current_nested_pattern = nested_pattern
      H.iterate_matched_spans(neighborhood['1d'], nested_pattern, f)
    end
  end

  local extract_pattern
  if best_nested_pattern ~= nil then
    extract_pattern = best_nested_pattern[#best_nested_pattern]
  end
  return { span = best_span, extract_pattern = extract_pattern }
end

H.iterate_matched_spans = function(line, nested_pattern, f)
  local max_level = #nested_pattern
  -- Keep track of visited spans to ensure only one call of `f`.
  -- Example: `((a) (b))`, `{'%b()', '%b()'}`
  local visited = {}

  local process
  process = function(level, level_line, level_offset)
    local pattern = nested_pattern[level]
    local next_span = function(s, init)
      return utils.string_find(s, pattern, init)
    end
    if vim.is_callable(pattern) then
      next_span = pattern
    end

    local is_same_balanced = type(pattern) == 'string' and pattern:match('^%%b(.)%1$') ~= nil
    local init = 1
    while init <= level_line:len() do
      local from, to = next_span(level_line, init)
      if from == nil then
        break
      end

      if level == max_level then
        local found_match = Span.new(from + level_offset, to + level_offset)
        local found_match_id = string.format('%s_%s', found_match.from, found_match.to)
        if not visited[found_match_id] then
          f(found_match)
          visited[found_match_id] = true
        end
      else
        local next_level_line = level_line:sub(from, to)
        local next_level_offset = level_offset + from - 1
        process(level + 1, next_level_line, next_level_offset)
      end

      -- Start searching from right end to implement "balanced" pair.
      -- This doesn't work with regular balanced pattern because it doesn't
      -- capture nested brackets.
      init = (is_same_balanced and to or from) + 1
    end
  end

  process(1, line, 0)
end

-- Work with operator marks ---------------------------------------------------
H.get_marks_pos = function(mode)
  -- Region is inclusive on both ends
  local mark1, mark2
  if mode == 'visual' then
    mark1, mark2 = '<', '>'
  else
    mark1, mark2 = '[', ']'
  end

  local pos1 = vim.api.nvim_buf_get_mark(0, mark1)
  local pos2 = vim.api.nvim_buf_get_mark(0, mark2)

  local selection_type = H.get_selection_type(mode)

  -- Tweak position in linewise mode as marks are placed on the first column
  if selection_type == 'linewise' then
    -- Move start mark past the indent
    local _, line1_indent = vim.fn.getline(pos1[1]):find('^%s*')
    pos1[2] = line1_indent

    -- Move end mark to the last character (` - 2` here because `col()` returns
    -- column right after the last 1-based column)
    pos2[2] = vim.fn.col({ pos2[1], '$' }) - 2
  end

  -- Make columns 1-based instead of 0-based. This is needed because
  -- `nvim_buf_get_mark()` returns the first 0-based byte of mark symbol and
  -- all the following operations are done with Lua's 1-based indexing.
  pos1[2], pos2[2] = pos1[2] + 1, pos2[2] + 1

  -- Tweak second position to respect multibyte characters. Reasoning:
  -- - These positions will be used with `region_replace()` to add some text,
  --   which operates on byte columns.
  -- - For the first mark we want the first byte of symbol, then text will be
  --   insert to the left of the mark.
  -- - For the second mark we want last byte of symbol. To add surrounding to
  --   the right, use `pos2[2] + 1`.
  if mode == 'visual' and vim.o.selection == 'exclusive' then
    -- Respect 'selection' option
    pos2[2] = pos2[2] - 1
  else
    local line2 = vim.fn.getline(pos2[1])
    -- Use `math.min()` because it might lead to 'index out of range' error
    -- when mark is positioned at the end of line (that extra space which is
    -- selected when selecting with `v$`)
    local utf_index = vim.str_utfindex(line2, math.min(#line2, pos2[2]))
    -- This returns the last byte inside character because `vim.str_byteindex()`
    -- 'rounds upwards to the end of that sequence'.
    pos2[2] = vim.str_byteindex(line2, utf_index)
  end

  return {
    first = { line = pos1[1], col = pos1[2] },
    second = { line = pos2[1], col = pos2[2] },
    selection_type = selection_type,
  }
end

H.get_selection_type = function(mode)
  if (mode == 'char') or (mode == 'visual' and vim.fn.visualmode() == 'v') then
    return 'charwise'
  end
  if (mode == 'line') or (mode == 'visual' and vim.fn.visualmode() == 'V') then
    return 'linewise'
  end
  if (mode == 'block') or (mode == 'visual' and vim.fn.visualmode() == '\22') then
    return 'blockwise'
  end
end

-- Work with cursor -----------------------------------------------------------
H.set_cursor = function(line, col)
  vim.api.nvim_win_set_cursor(0, { line, col - 1 })
end

H.set_cursor_nonblank = function(line)
  H.set_cursor(line, 1)
  vim.cmd('normal! ^')
end

H.compare_pos = function(pos1, pos2)
  if pos1.line < pos2.line then
    return '<'
  end
  if pos1.line > pos2.line then
    return '>'
  end
  if pos1.col < pos2.col then
    return '<'
  end
  if pos1.col > pos2.col then
    return '>'
  end
  return '='
end

H.cursor_cycle = function(pos_array, dir)
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  cur_pos = { line = cur_pos[1], col = cur_pos[2] + 1 }

  local compare, to_left, to_right, res_pos
  -- NOTE: `pos_array` should be an increasingly ordered array of positions
  for _, pos in pairs(pos_array) do
    compare = H.compare_pos(cur_pos, pos)
    -- Take position when moving to left if cursor is strictly on right.
    -- This will lead to updating `res_pos` until the rightmost such position.
    to_left = compare == '>' and dir == 'left'
    -- Take position when moving to right if cursor is strictly on left.
    -- This will update result only once leading to the leftmost such position.
    to_right = res_pos == nil and compare == '<' and dir == 'right'
    if to_left or to_right then
      res_pos = pos
    end
  end

  res_pos = res_pos or (dir == 'right' and pos_array[1] or pos_array[#pos_array])
  H.set_cursor(res_pos.line, res_pos.col)
end

-- Work with user input -------------------------------------------------------
H.user_surround_id = function(sur_type)
  -- Get from user single character surrounding identifier
  local needs_help_msg = true
  vim.defer_fn(function()
    if not needs_help_msg then
      return
    end

    local msg = string.format('Enter %s surrounding identifier (single character) ', sur_type)
    utils.echo(msg)
    Config.cache.msg_shown = true
  end, 1000)
  local ok, char = pcall(vim.fn.getcharstr)
  needs_help_msg = false
  utils.unecho()

  -- Terminate if couldn't get input (like with <C-c>) or it is `<Esc>`
  if not ok or char == '\27' then
    return nil
  end

  if char:find('^[%w%p%s]$') == nil then
    Config.message('Input must be single character: alphanumeric, punctuation, or space.')
    return nil
  end

  return char
end

-- Work with positions --------------------------------------------------------
H.pos_to_left = function(pos)
  if pos.line == 1 and pos.col == 1 then
    return { line = pos.line, col = pos.col }
  end
  if pos.col == 1 then
    return { line = pos.line - 1, col = utils.get_line_cols(pos.line - 1) }
  end
  return { line = pos.line, col = pos.col - 1 }
end

H.pos_to_right = function(pos)
  local n_cols = utils.get_line_cols(pos.line)
  -- Using `>` and not `>=` helps with removing '\n' and in the last line
  if pos.line == vim.api.nvim_buf_line_count(0) and pos.col > n_cols then
    return { line = pos.line, col = n_cols }
  end
  if pos.col > n_cols then
    return { line = pos.line + 1, col = 1 }
  end
  return { line = pos.line, col = pos.col + 1 }
end

-- Work with regions ----------------------------------------------------------
H.region_replace = function(region, text)
  -- Compute start and end position for `vim.api.nvim_buf_set_text()`.
  -- Indexing is zero-based. Rows - end-inclusive, columns - end-exclusive.
  local start_row, start_col = region.from.line - 1, region.from.col - 1

  local end_row, end_col
  -- Allow empty region
  if H.region_is_empty(region) then
    end_row, end_col = start_row, start_col
  else
    end_row, end_col = region.to.line - 1, region.to.col

    -- Possibly correct to allow removing new line character
    if end_row < vim.api.nvim_buf_line_count(0) and utils.get_line_cols(end_row + 1) < end_col then
      end_row, end_col = end_row + 1, 0
    end
  end

  -- Allow single string as replacement
  if type(text) == 'string' then
    text = { text }
  end

  -- Allow `\n` in string to denote new lines
  if #text > 0 then
    text = vim.split(table.concat(text, '\n'), '\n')
  end

  -- Replace. Use `pcall()` to do nothing if some position is out of bounds.
  pcall(vim.api.nvim_buf_set_text, 0, start_row, start_col, end_row, end_col, text)
end

H.surr_to_pos_array = function(surr)
  local res = {}

  local append_position = function(pos, correction_direction)
    if pos == nil then
      return
    end
    -- Don't go past the line if it is not empty
    if utils.get_line_cols(pos.line) < pos.col and pos.col > 1 then
      pos = correction_direction == 'left' and H.pos_to_left(pos) or H.pos_to_right(pos)
    end

    -- Don't add duplicate. Assumes that positions are used increasingly.
    local line, col = pos.line, pos.col
    local last = res[#res]
    if not (last ~= nil and last.line == line and last.col == col) then
      table.insert(res, { line = line, col = col })
    end
  end

  -- Possibly correct position towards inside of surrounding region
  -- Also don't add positions from empty regions
  if not H.region_is_empty(surr.left) then
    append_position(surr.left.from, 'right')
    append_position(surr.left.to, 'right')
  end
  if not H.region_is_empty(surr.right) then
    append_position(surr.right.from, 'left')
    append_position(surr.right.to, 'left')
  end

  return res
end

H.region_highlight = function(buf_id, region)
  -- Don't highlight empty region
  if H.region_is_empty(region) then
    return
  end
  local ns_id = Config.ns_id.highlight

  -- Indexing is zero-based. Rows - end-inclusive, columns - end-exclusive.
  local from_line, from_col, to_line, to_col =
    region.from.line - 1, region.from.col - 1, region.to.line - 1, region.to.col
  vim.highlight.range(buf_id, ns_id, 'MiniSurround', { from_line, from_col }, { to_line, to_col })
end

H.region_unhighlight = function(buf_id, region)
  local ns_id = Config.ns_id.highlight

  -- Remove highlights from whole lines as it is the best available granularity
  vim.api.nvim_buf_clear_namespace(
    buf_id,
    ns_id,
    region.from.line - 1,
    (region.to or region.from).line
  )
end

H.region_is_empty = function(region)
  return region.to == nil
end

-- Work with text -------------------------------------------------------------
H.get_range_indent = function(from_line, to_line)
  local n_indent, indent = math.huge, nil

  local lines = vim.api.nvim_buf_get_lines(0, from_line - 1, to_line, true)
  local n_indent_cur, indent_cur
  for _, l in ipairs(lines) do
    _, n_indent_cur, indent_cur = l:find('^(%s*)')

    -- Don't indent blank lines
    if n_indent_cur < n_indent and n_indent_cur < l:len() then
      n_indent, indent = n_indent_cur, indent_cur
    end
  end

  return indent or ''
end

H.shift_indent = function(command, from_line, to_line)
  if to_line < from_line then
    return
  end
  vim.cmd('silent ' .. from_line .. ',' .. to_line .. command)
end

H.is_line_blank = function(line_num)
  return vim.fn.nextnonblank(line_num) ~= line_num
end

-- Work with Lua patterns -----------------------------------------------------
H.extract_surr_spans = function(s, extract_pattern)
  local positions = { s:match(extract_pattern) }

  local is_all_numbers = true
  for _, pos in ipairs(positions) do
    if type(pos) ~= 'number' then
      is_all_numbers = false
    end
  end

  local is_valid_positions = is_all_numbers and (#positions == 2 or #positions == 4)
  if not is_valid_positions then
    local msg = 'Could not extract proper positions (two or four empty captures) from '
      .. string.format([[string '%s' with extraction pattern '%s'.]], s, extract_pattern)
    Config.error(msg)
  end

  if #positions == 2 then
    return { left = Span.new(1, positions[1] - 1), right = Span.new(positions[2], s:len()) }
  end
  return {
    left = Span.new(positions[1], positions[2] - 1),
    right = Span.new(positions[3], positions[4] - 1),
  }
end

-- Work with cursor neighborhood ----------------------------------------------
---@param reference_region table Reference region.
---@param n_neighbors number Maximum number of neighbors to include before
---   start line and after end line.
---@private
H.get_neighborhood = function(reference_region, n_neighbors)
  -- Compute '2d neighborhood' of (possibly empty) region
  local from_line, to_line =
    reference_region.from.line, (reference_region.to or reference_region.from).line
  local line_start = math.max(1, from_line - n_neighbors)
  local line_end = math.min(vim.api.nvim_buf_line_count(0), to_line + n_neighbors)
  local neigh2d = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  -- Append 'newline' character to distinguish between lines in 1d case
  for k, v in pairs(neigh2d) do
    neigh2d[k] = v .. '\n'
  end

  -- '1d neighborhood': position is determined by offset from start
  local neigh1d = table.concat(neigh2d, '')

  -- Convert 2d buffer position to 1d offset
  local pos_to_offset = function(pos)
    if pos == nil then
      return nil
    end
    local line_num = line_start
    local offset = 0
    while line_num < pos.line do
      offset = offset + neigh2d[line_num - line_start + 1]:len()
      line_num = line_num + 1
    end

    return offset + pos.col
  end

  -- Convert 1d offset to 2d buffer position
  local offset_to_pos = function(offset)
    if offset == nil then
      return nil
    end
    local line_num = 1
    local line_offset = 0
    while line_num <= #neigh2d and line_offset + neigh2d[line_num]:len() < offset do
      line_offset = line_offset + neigh2d[line_num]:len()
      line_num = line_num + 1
    end

    return { line = line_start + line_num - 1, col = offset - line_offset }
  end

  -- Convert 2d region to 1d span
  local region_to_span = function(region)
    if region == nil then
      return nil
    end
    local is_empty = region.to == nil
    local to = region.to or region.from
    return { from = pos_to_offset(region.from), to = pos_to_offset(to) + (is_empty and 0 or 1) }
  end

  -- Convert 1d span to 2d region
  local span_to_region = function(span)
    if span == nil then
      return nil
    end
    -- NOTE: this might lead to outside of line positions due to added `\n` at
    -- the end of lines in 1d-neighborhood.
    local res = { from = offset_to_pos(span.from) }

    -- Convert empty span to empty region
    if span.from < span.to then
      res.to = offset_to_pos(span.to - 1)
    end
    return res
  end

  local is_region_inside = function(region)
    local res = line_start <= region.from.line
    if region.to ~= nil then
      res = res and (region.to.line <= line_end)
    end
    return res
  end

  return {
    n_neighbors = n_neighbors,
    region = reference_region,
    ['1d'] = neigh1d,
    ['2d'] = neigh2d,
    pos_to_offset = pos_to_offset,
    offset_to_pos = offset_to_pos,
    region_to_span = region_to_span,
    span_to_region = span_to_region,
    is_region_inside = is_region_inside,
  }
end

return H
