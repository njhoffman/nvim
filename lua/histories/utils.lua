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
    if not unique or not vim.list_contains(hashes, hash) then
      if i == (#list - pos_idx) then
        new_idx = #new_list + 1
        hash_id = hash_id + i
        item.curr = true
      end
      table.insert(new_list, item)
      table.insert(hashes, hash)
    end
  end
  -- vim.dbglog("ret", new_idx, pos_idx)
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
    for _, header in ipairs(opts.headers) do
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

local set_keys = function(provider, mappings)
  -- https://github.com/pogyomo/submode.nvim
  local map = require("mapper").map
  local path = "histories." .. provider .. ".actions"
  for key, action in pairs(mappings) do
    map(
      "n",
      key,
      string.format(':lua require("' .. path .. '").%s()<CR>', action),
      { buffer = 0 }
    )
  end
end

local is_popup = function(winnr)
  return vim.tbl_get(vim.api.nvim_win_get_config(winnr), "relative") ~= ""
end

local watch_changes = function(opts, get_items, view)
  local timer = vim.loop.new_timer()
  local last = { hash = 0, idx = -1 }
  if timer then
    timer:start(
      0,
      1000,
      vim.schedule_wrap(function()
        local winnr = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        if is_popup(winnr) then
          return false
        end
        local changes, change_idx, hash_id = get_items(bufnr, opts.unique)
        if hash_id ~= last.hash or change_idx ~= last.idx then
          view.load(changes, change_idx, opts)
          last = { hash = hash_id, idx = change_idx }
        end
      end)
    )
  end
end

return {
  set_keys = set_keys,
  align_text = align_text,
  process_list = process_list,
  watch_changes = watch_changes,
  build_highlight_table = build_highlight_table,
}
