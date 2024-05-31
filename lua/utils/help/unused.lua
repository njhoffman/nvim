-- helpgrep keyword
-- copen
-- :h :command                        " help for ex-command 'command'
-- :h 'option'                        " help for option 'option'
-- :h function()                      " help for function 'function'
-- :h modifier-key                    " help for 'modifier'-'key' in normal mode
-- :h mode_modifier-key               " help for 'modifier'-'key' in 'mode'
-- :h mode_modifier-key_modifier-key  " help for 'modifier'-'key' 'modifier'-'key' in 'mode'

-- :help z?	jump to help for any "z" command
-- :help z.	jump to the help for "z."
-- :help :?	jump to help for ":?"
-- :help index
-- :tselect /.*mode

-- :helpgrep backspace
-- :cnext, :cwindow
-- Use CTRL-T or CTRL-O to jump back.
-- :tag /min && :tnext

-- vim.api.nvim_create_autocmd('BufWinEnter', { buffer = 0, command = 'vertical resize 81' })
-- https://vim.fandom.com/wiki/Learn_to_use_help
-- TODO: reconcile with zoom

local timer_id
local debounce = function(func, delay)
  return function(...)
    if timer_id then
      vim.fn.timer_stop(timer_id)
    end
    local args = { ... }
    timer_id = vim.fn.timer_start(delay, function()
      vim.schedule_wrap(func(unpack(args)))
    end)
  end
end

local help_history = {}
local history_file = vim.fn.stdpath('data') .. '/help_history.json'

local read_history = function()
  local file = io.open(history_file, 'r')
  if false and file then
    local content = file:read('*a')
    file:close()
    help_history = vim.fn.json_decode(content)
    -- vim.dbglog('help history: ' .. history_file .. ' - ' .. vim.inspect(help_history))
  end
end

local write_history = function()
  local file = io.open(history_file, 'w')
  if false and file and help_history ~= {} then
    -- vim.dbglog('writing help history ', help_history)
    file:write(vim.fn.json_encode(help_history))
    file:close()
  end
end

local get_history_by_bufname = function(bufname)
  for _, entry in ipairs(help_history) do
    if entry.name == bufname then
      return entry
    end
  end
end

local get_help_bufnr = function()
  local help_bufnr = vim.fn.bufnr('*help*')
  if help_bufnr == -1 then
    help_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(help_bufnr, '*help*')
  end
  return help_bufnr
end
