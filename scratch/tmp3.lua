-- Error executing Lua callback: vim/_editor.lua:0: nvim_exec2()..function <SNR>195_bdelete, line 48: Vim(bdelete):E315: ml_get: Invalid lnum: 1
-- stack traceback:
--   [C]: in function 'nvim_exec2'
--   vim/_editor.lua: in function 'cmd'
--   /home/nicholas/.config/nvim/lua/commands/ui.lua:119: in function </home/nicholas/.config/nvim/lua/commands/ui.lua:96>
-- vim.diagnostic.handlers['my/notify'] = {
--   show = function(namespace, bufnr, diagnostics, opts)
--     -- In our example, the opts table has a "log_level" option
--     local level = opts['my/notify'].log_level
--
--     local name = vim.diagnostic.get_namespace(namespace).name
--     local msg = string.format('%d diagnostics in buffer %d from %s', #diagnostics, bufnr, name)
--     vim.notify(msg, level)
--   end,
-- }
--
-- -- Users can configure the handler
-- vim.diagnostic.config({
--   ['my/notify'] = {
--     log_level = vim.log.levels.INFO,
--   },
-- })

local visual_str = {
  ['v'] = true, -- Visual by character
  ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode
  ['V'] = true, -- Visual by line
  ['Vs'] = true, -- Visual by line using |v_CTRL-O| in Select mode
  ['CTRL-V'] = true, -- Visual blockwise
  ['^V'] = true, -- Visual blockwise <--- this never hits, why?
  ['CTRL-Vs'] = true, -- Visual blockwise using |v_CTRL-O| in Select mode
}
local words_count = function()
  if vim.fn.wordcount().visual_words == 1 then
    return tostring(vim.fn.wordcount().visual_words) .. ' word'
  elseif not (vim.fn.wordcount().visual_words == nil) then
    return tostring(vim.fn.wordcount().visual_words) .. ' words'
  else
    return tostring(vim.fn.wordcount().words) .. ' words'
  end
end

local char_and_line_count = function()
  local ln_beg = vim.fn.line('v')
  local ln_end = vim.fn.line('.')
  local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1
  return tostring(vim.fn.wordcount().visual_chars) .. ' chars' .. ' / ' .. tostring(lines) .. ' lines'
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  callback = function()
    if visual_str[tostring(vim.fn.mode())] then
      vim.dbglog(char_and_line_count())
      vim.dbglog(words_count())
    end
  end,
})
-- o[a]   N?: da
