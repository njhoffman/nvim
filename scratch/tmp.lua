-- stylua: ignore start

local operators = vim.api.nvim_get_keymap('o')
local motions = vim.api.nvim_get_keymap('')

for _, map in pairs(operators) do
  -- print('Operator: ' .. map.lhs)
end

for _, map in pairs(motions) do
  -- print('Motion: ' .. map.lhs)
end
local noop = function() end

local testline = noop('', {}, 1 + 1, false)
local testline2__ = { 'one', 'two',
'three'}
local testline3 =  noop('', {}, 1 + 1, false) -- a comment to ignore
local testline4 = { 'one', 'two', -- a comment to ignore
}

local function get_last_char(row, buf)
  buf = buf or vim.api.nvim_get_current_buf()
  row = row or vim.api.nvim_win_get_cursor(buf)[1]
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

  -- remove trailing comments
  local code = line:match('(.-)%s-%-%-') or line
  -- get last character
  local lastchar = code:sub(#code)
  return lastchar, #code
end

local nvim = vim.api
local ts = vim.treesitter

local function get_root_node(row, col, buf)
  local root_lang_tree = ts.get_parser(buf, ts.language.get_lang(vim.bo[buf].ft))
  local lang_tree = root_lang_tree:language_for_range({ row, col, row, col })
  for _, tree in pairs(lang_tree:trees()) do
    local root = tree:root()
    if root and vim.treesitter.is_in_node_range(root, row, col) then
      return root
    end
  end
  return nil
end

local GUARD_MAX = 1000
local function get_last_char_ts(_row, _buf)
  local buf = _buf or nvim.nvim_get_current_buf()
  local row = _row or (nvim.nvim_win_get_cursor(buf)[1])
  local col = _row and 0 or (nvim.nvim_win_get_cursor(buf)[2] - 1)

  local root = get_root_node(row - 1, col, buf)
  if not root or root:type() == 'comment' then
    return nil, 0
  end
  local line = nvim.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  local node = root:named_descendant_for_range(row - 1, col, row - 1, col)
  local row1, col1, row2, col2 = node:range()
  col = col1
  local iterator = node and node:iter_children()
  local guard, last_col, last_char = 0, col, ''
  while node do
    guard = guard + 1
    if guard >= GUARD_MAX then
      return nil, 'loop exceeded ' .. GUARD_MAX .. ' at node ' .. (node and node:type() or 'nil')
    end
    if row1 == (row - 1) and row2 == (row - 1) then
      local char = line:sub(col2, col2)
      vim.dbglog('3', row - 1, row1, row2, col, col1, col2, '\n\t', line)
      if type(char) == 'string' and char ~= '' then
        last_char = char
        last_col = col2
      end
    end

    local next = iterator()
    if not next then
      break
    else
      local type = next:type()
      if type ~= 'comment' then
        node = next
        local row1, col1, row2, col2 = node:range()
        col = col1
      end
    end
  end
  return last_char, last_col
end

local function iter(parent, row, _col1, _col2, buf)
  local node = parent:named_descendant_for_range(row, _col1, row, _col2)
  local row1, col1, row2, col2 = node:range()
  if  row1 == row and row2 == row then
    vim.dbglog('range: ' ..  node:type(), '\n', vim.treesitter.get_node_text(node, buf), '\n', row1, col1, row2, col2)
  end
  return node, col1, col2
end

local function backup_ts(_row, _buf)
  -- Initialize variables
  local buf = _buf or nvim.nvim_get_current_buf()
  local row = (_row or nvim.nvim_win_get_cursor(buf)[1])
  local col = _row or nvim.nvim_win_get_cursor(buf)[2]
  local root_node = get_root_node(row, col, buf)
  vim.dbglog(root_node:range())
  row = row - 1
  local node, col1, col2 = iter(root_node, row, col, buf)
  node, col1, col2 = iter(node, row, col1 + 1, buf)
  node, col1, col2 = iter(node, row, col1 + 1, buf)
  node, col1, col2 = iter(node, row, col1 + 1, buf)
  node, col1, col2 = iter(node, row, col1 + 1, buf)
  -- Traverse the syntax tree
  -- local n = 0
  -- while node and n < 20 do
  --   node = node:named_descendant_for_range(row - 1, col1, row - 1, col2)
  --   row1, col1, row2, col2 = node:range()
  --   vim.dbglog('range: ' ..  row1, col1, row2, col2)
  --   n = n + 1
  -- end
  -- return last_char, last_col
end


-- local last_char, col = get_last_char(78)
-- local last_char_ts, col_ts = get_last_char_ts(78)
-- vim.dbglog(last_char, col, last_char_ts, col_ts, '\n\n')
-- local last_char,col = get_last_char(79)
-- local last_char_ts,col_ts = get_last_char_ts(79)
-- vim.dbglog(last_char, col, last_char_ts, col_ts, '\n\n')

-- vim.dbglog('---')
-- local last_char,col = get_last_char(18)
-- local last_char_ts,col_ts = get_last_char_ts(18)
-- vim.dbglog(last_char, col, last_char_ts, col_ts)

local row = 15
vim.dbglog('---')
-- local last_char,col = get_last_char(row)
-- local last_char_ts,col_ts = get_last_char_ts(row)
local last_char_ts, col_ts = backup_ts(row)
vim.dbglog(last_char, col, last_char_ts, col_ts)
