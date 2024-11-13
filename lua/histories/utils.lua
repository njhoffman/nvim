local get_change_hash = function(c)
  return table.concat({
    tostring(c.col),
    tostring(c.coladd),
    tostring(c.lnum),
  }, ""),
    c.col + c.lnum
end

local process_list = function(list, pos_idx, unique)
  local new_list = {}
  local hashes = {}
  local hash_id = pos_idx
  local new_idx = 0
  for i, item in ipairs(vim.fn.reverse(list)) do
    local hash, hash_n = get_change_hash(item)
    hash_id = hash_id + i + hash_n
    item.idx = i
    if not unique or vim.list_contains(hashes, hash) then
      if i == (#list - pos_idx) then
        new_idx = #new_list
        hash_id = hash_id + i
        item.curr = true
      end
      table.insert(new_list, item)
      table.insert(hashes, hash)
    end
  end
  return new_list, new_idx, hash_id
end

local align_text = function(text, width, type)
  local left, right = 0, 0
  local len = vim.fn.strwidth(text)
  if type == "right" then
    left = width - len
  elseif type == "center" then
    left = math.floor((width - len) / 2)
    right = math.ceil((width - len) / 2)
  else
    right = width - len
  end
  return string.rep(" ", left) .. text .. string.rep(" ", right), { left, len }
end

local build_highlight_table = function(rows, opts)
  local opts = opts or {}
  opts.padding = opts.padding or 2
  if opts.headers then
    local header_row = {}
    for i, header in ipairs(opts.headers) do
      table.insert(header_row, { header, "Title" })
    end
    table.insert(rows, 1, header_row)
  end

  local colwidths = {}
  for _, row in ipairs(rows) do
    for i, item in ipairs(row) do
      local width = colwidths[i] or 0
      colwidths[i] = math.max(width, vim.fn.strwidth(item[1] or ""))
    end
  end

  local lines, highlights = {}, {}
  for _, row in ipairs(rows) do
    local line = ""
    for i, item in ipairs(row) do
      local text, pos = align_text(item[1], colwidths[i] + opts.padding, opts.align[i])
      local start = #line + pos[1]
      local finish = start + pos[2]
      table.insert(highlights, { item[2], #lines, start, finish })
      line = line .. text
    end
    table.insert(lines, line)
  end
  return lines, highlights
end

return {
  align_text = align_text,
  process_list = process_list,
  build_highlight_table = build_highlight_table,
}
