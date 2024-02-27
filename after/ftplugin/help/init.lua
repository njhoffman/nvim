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
  if file then
    local content = file:read('*a')
    file:close()
    help_history = vim.fn.json_decode(content)
    vim.dbglog('help history: ' .. history_file .. ' - ' .. vim.inspect(help_history))
  end
end

local write_history = function()
  local file = io.open(history_file, 'w')
  if file and help_history ~= {} then
    vim.dbglog('writing help history ', help_history)
    create = io.open(history_file, 'w')
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

local state = {
  width_cutoff = 60,
  src_bufnr = vim.api.nvim_get_current_buf(),
}

local get_help_bufnr = function()
  local help_bufnr = vim.fn.bufnr('*help*')
  if help_bufnr == -1 then
    help_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(help_bufnr, '*help*')
  end
  return help_bufnr
end

local refresh_state = function()
  local src_valid = type(state.src_bufnr) == 'number'
    and vim.api.nvim_buf_is_loaded(state.src_bufnr)
  if src_valid then
    state.src_winid = vim.fn.bufwinid(state.src_bufnr)
    state.src_winnr = vim.fn.bufwinnr(state.src_bufnr)
    state.src_name = vim.api.nvim_buf_get_name(state.src_bufnr)
  else
    for _, k in pairs({ 'src_bufnr', 'src_winid', 'src_winnr', 'src_name' }) do
      state[k] = nil
    end
  end

  local help_valid = type(state.help_bufnr) == 'number'
    and vim.api.nvim_buf_is_loaded(state.help_bufnr)

  if not help_valid then
    state.help_bufnr = get_help_bufnr()
  end
  state.help_winnr = state.help_bufnr > -1
    and vim.api.nvim_buf_is_loaded(state.help_bufnr)
    and vim.fn.bufwinnr(state.help_bufnr)

  if state.help_winnr and state.help_winnr > -1 then
    state.textwidth = vim.api.nvim_get_option_value('textwidth', { buf = state.help_bufnr })
    state.help_winid = vim.fn.bufwinid(state.help_bufnr)
    state.help_width = vim.api.nvim_win_get_width(state.help_winid)
    state.help_height = vim.api.nvim_win_get_height(state.help_winid)
    local active_winnr = vim.fn.winnr()
    state.vert_split = vim.fn.winnr('j') ~= active_winnr or vim.fn.winnr('k') ~= active_winnr
  else
    for _, k in pairs({
      'help_winnr',
      'help_winid',
      'help_bufnr',
      'help_height',
      'help_width',
      'vert_split',
    }) do
      state[k] = nil
    end
  end
end

local resize_window = function()
  refresh_state()

  if
    state.help_winnr
    and state.help_bufnr > -1
    and vim.api.nvim_buf_is_loaded(state.help_bufnr)
  then
    if state.help_width and state.help_width < state.width_cutoff then
      if not state.vert_split then
        vim.cmd('wincmd J')
      end
      vim.api.nvim_set_option_value('wrap', true, { win = state.help_winid })
    elseif state.help_width and state.help_width < state.textwidth then
      local new_width = math.floor(0.8 * state.help_width)
      vim.api.nvim_win_set_width(state.help_winid, new_width)
      vim.api.nvim_set_option_value('wrap', true, { win = state.help_winid })
    else
      if state.vert_split then
        vim.cmd('wincmd L')
      end
      vim.api.nvim_win_set_width(state.help_winid, state.textwidth)
      vim.api.nvim_set_option_value('wrap', false, { win = state.help_winid })
    end
    local cursor = vim.api.nvim_win_get_cursor(state.help_winid)
    vim.api.nvim_win_set_cursor(state.help_winid, { cursor[1], 1 })
  end
end

local is_helpsplit = function(bufnr)
  return bufnr == state.src_bufnr
    or bufnr == state.help_bufnr
    or (
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_get_option_value('filetype', { buf = bufnr }) == 'help'
    )
end

local augroup = vim.api.nvim_create_augroup('helpfile', { clear = true })

local create_autocmds = function()
  local aucmd = vim.api.nvim_create_autocmd
  aucmd({ 'WinResized' }, {
    group = augroup,
    callback = function(opts)
      if is_helpsplit(opts.buf) then
        debounce(resize_window(), 500)
      end
    end,
  })

  aucmd({ 'BufWinEnter' }, {
    group = augroup,
    callback = function(opts)
      if is_helpsplit(opts.buf) then
        debounce(refresh_state(), 500)
      end
    end,
  })

  local load_file = function(opts)
    if opts.buf then
      local ft = vim.api.nvim_get_option_value('filetype', { buf = opts.buf })
      if ft == 'help' then
        refresh_state()
        local bufname = vim.api.nvim_buf_get_name(opts.buf)
        local entry = get_history_by_bufname(bufname)
        if not entry then
          entry = { name = bufname, tags = {}, dates = {} }
          table.insert(entry.dates, { os.time(), state.src_name })
          table.insert(help_history, entry)
        else
          table.insert(entry.dates, { os.time(), state.src_name })
        end
      end
    end
  end

  aucmd({ 'BufNewFile' }, {
    group = augroup,
    callback = function(opts)
      debounce(load_file(opts), 500)
    end,
  })

  local teardown = function(opts)
    if opts.buf == state.help_bufnr or opts.buf == state.src_bufnr then
      refresh_state()
      write_history()
    end
  end

  aucmd({ 'WinClosed' }, {
    group = augroup,
    callback = function(opts)
      debounce(teardown(opts), 500)
    end,
  })
end

local set_options = function()
  local formatoptions = vim.api.nvim_get_option_value('formatoptions', { buf = state.src_bufnr })
    or ''
  if not string.find(formatoptions, 'c') then
    vim.api.nvim_set_option_value('formatoptions', formatoptions .. 'c', { buf = state.src_bufnr })
  end
  -- nnoremap <buffer> <LocalLeader>K  :<C-U>helpgrep <cword><CR>
  -- let b:undo_ftplugin .= '|nunmap <buffer> K'

  vim.api.nvim_set_option_value('tabstop', 2, { buf = state.src_bufnr })
end

local set_keymaps = function()
  local bufmap = vim.api.nvim_buf_set_keymap
  if
    state.help_bufnr
    and state.help_bufnr > -1
    and vim.api.nvim_buf_is_loaded(state.help_bufnr)
  then
    bufmap(state.help_bufnr, 'n', '<C-Space>', '<C-]>', { desc = 'jump to tag definition' })
    bufmap(state.help_bufnr, 'n', '<BS>', '<C-O>', { desc = 'jump to prev visited tag' })
    if
      vim.startswith(tostring(vim.fn.expand('%')) or '', vim.env.VIMRUNTIME or '')
      or vim.bo.readonly
    then
      bufmap(
        state.help_bufnr,
        'n',
        '<leader>ml',
        'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a',
        { desc = 'set default help modeline' }
      )
    end
  end
end

local set_syntax = function()
  local putils = require('telescope.previewers.utils')
  putils.ts_highlighter(state.src_bufnr, 'markdown')
  putils.regex_highlighter(state.src_bufnr, 'pandoc')
  -- vim.treesitter.register('help', 'markdown')
  -- vim.treesitter.start()
end

local init = function()
  resize_window()
  read_history()
  create_autocmds()
  set_options()
  set_keymaps()
  set_syntax()
  -- resize_window()
end

init()
