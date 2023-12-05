local visual_str = {
  ['v'] = true, -- Visual by character
  ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode
  ['V'] = true, -- Visual by line
  ['Vs'] = true, -- Visual by line using |v_CTRL-O| in Select mode
  ['CTRL-V'] = true, -- Visual blockwise
  [''] = true, -- Visual blockwise
  ['CTRL-Vs'] = true, -- Visual blockwise using |v_CTRL-O| in Select mode
}

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

local selection_count = function()
  if visual_str[tostring(vim.fn.mode())] then
    return line_count() .. ' ' .. char_count() .. 'ﮜ'
  end
end

-- vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--   callback = function()
--     if visual_str[tostring(vim.fn.mode())] then
--       vim.dbglog(line_count() .. ' ' .. char_count() .. 'ﮜ')
--     end
--   end,
-- })

return {
  name = 'selection_count',
  provider = selection_count,
  -- cond = function()
  --   if visual_str[tostring(vim.fn.mode())] then
  --     return line_count() .. ' ' .. char_count() .. 'ﮜ'
  --   end
  -- end,
}
