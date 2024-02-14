-- vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--   callback = function()
--     if visual_str[tostring(vim.fn.mode())] then
--       vim.dbglog(line_count() .. ' ' .. char_count() .. 'ﮜ')
--     end
--   end,
-- })

-- sophisticated count
local function selectioncount()
  local mode = vim.fn.mode()
  local lines = math.abs(vim.fn.line('v') - vim.fn.line('.')) + 1
  if mode == 'v' or mode == 'V' then
    local wc = vim.fn.wordcount()
    local bytecount, linecount = '', ''
    if wc.visual_chars ~= wc.visual_bytes then
      bytecount = string.format('-%d', wc.visual_bytes)
    end
    if lines > 1 then
      linecount = string.format(' / %d', lines)
    end
    return string.format('[%d%s%s]', wc.visual_chars, bytecount, linecount)
  elseif mode == '' then
    local cols = vim.fn.virtcol('.') - vim.fn.virtcol('v')
    local line, col
    if cols >= 0 then
      line = vim.fn.getline('v')
      col = vim.fn.charcol('v') - 1
    else
      line = vim.fn.getline('.')
      col = vim.fn.charcol('.') - 1
      cols = -cols
    end
    local char1width = vim.fn.strwidth(vim.fn.strcharpart(line, col, 1))
    return string.format('[%dx%d]', lines, cols + char1width)
  else
    return ''
  end
end

-- local function selection_count()
--   local mode = vim.fn.mode(true)
--   local line_start, col_start = vim.fn.line('v'), vim.fn.col('v')
--   local line_end, col_end = vim.fn.line('.'), vim.fn.col('.')
--   if mode:match('') then
--     return string.format('%dx%d', math.abs(line_start - line_end) + 1, math.abs(col_start - col_end) + 1)
--   elseif mode:match('V') or line_start ~= line_end then
--     return math.abs(line_start - line_end) + 1
--   elseif mode:match('v') then
--     return math.abs(col_start - col_end) + 1
--   else
--     return ''
--   end
-- end

local words_count = function()
  if vim.fn.wordcount().visual_words == 1 then
    return tostring(vim.fn.wordcount().visual_words)
  elseif not (vim.fn.wordcount().visual_words == nil) then
    return tostring(vim.fn.wordcount().visual_words)
  else
    return tostring(vim.fn.wordcount().words)
  end
end

local char_count = function()
  return tostring(vim.fn.wordcount().visual_chars)
end

local line_count = function()
  local ln_beg = vim.fn.line('v')
  local ln_end = vim.fn.line('.')
  local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1
  return tostring(lines)
end

local colors = { visual = { fg = '#7187f2' }, default = { fg = '#1177a2' } }
local state = 'default'

local is_visual = function()
  local visual_str = {
    ['v'] = true, -- Visual by character
    ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode
    ['V'] = true, -- Visual by line
    ['Vs'] = true, -- Visual by line using |v_CTRL-O| in Select mode
    ['CTRL-V'] = true, -- Visual blockwise
    [''] = true, -- Visual blockwise
    ['CTRL-Vs'] = true, -- Visual blockwise using |v_CTRL-O| in Select mode
  }
  return visual_str[tostring(vim.fn.mode())]
end
--  礪 
local get_line_count = function()
  if is_visual() then
    state = 'visual'
    return line_count() .. ' ' .. char_count() .. 'ﮜ'
  else
    state = 'default'
    return '%L'
  end
end

return {
  name = 'line_count',
  update = { 'CursorMoved', 'BufEnter' },
  provider = get_line_count,
  get_hl = function()
    return colors[state]
  end,
}
