local default_config = require('mini.surround.default_config')
local Span = require('mini.surround.Span')
local utils = require('mini.surround.utils')

local Config = {}

-- Helper data ================================================================
-- Module default config
Config.default_config = vim.deepcopy(default_config)

-- Namespaces to be used within module
Config.ns_id = {
  highlight = vim.api.nvim_create_namespace('MiniSurroundHighlight'),
  input = vim.api.nvim_create_namespace('MiniSurroundInput'),
}

--stylua: ignore
-- Builtin surroundings
Config.builtin_surroundings = {
  -- Use balanced pair for brackets. Use opening ones to possibly
  -- replace/delete innder edge whitespace.
  ['('] = { input = { '%b()', '^.%s*().-()%s*.$' }, output = { left = '( ', right = ' )' } },
  [')'] = { input = { '%b()', '^.().*().$' },       output = { left = '(',  right = ')' } },
  ['['] = { input = { '%b[]', '^.%s*().-()%s*.$' }, output = { left = '[ ', right = ' ]' } },
  [']'] = { input = { '%b[]', '^.().*().$' },       output = { left = '[',  right = ']' } },
  ['{'] = { input = { '%b{}', '^.%s*().-()%s*.$' }, output = { left = '{ ', right = ' }' } },
  ['}'] = { input = { '%b{}', '^.().*().$' },       output = { left = '{',  right = '}' } },
  ['<'] = { input = { '%b<>', '^.%s*().-()%s*.$' }, output = { left = '< ', right = ' >' } },
  ['>'] = { input = { '%b<>', '^.().*().$' },       output = { left = '<',  right = '>' } },
  -- Derived from user prompt
  ['?'] = {
    input = function()
      local left = Config.user_input('Left surrounding')
      if left == nil or left == '' then return end
      local right = Config.user_input('Right surrounding')
      if right == nil or right == '' then return end

      return { vim.pesc(left) .. '().-()' .. vim.pesc(right) }
    end,
    output = function()
      local left = Config.user_input('Left surrounding')
      if left == nil then return end
      local right = Config.user_input('Right surrounding')
      if right == nil then return end
      return { left = left, right = right }
    end,
  },
  -- Brackets
  ['b'] = { input = { { '%b()', '%b[]', '%b{}' }, '^.().*().$' }, output = { left = '(', right = ')' } },
  -- Function call
  ['f'] = {
    input = { '%f[%w_%.][%w_%.]+%b()', '^.-%(().*()%)$' },
    output = function()
      local fun_name = Config.user_input('Function name')
      if fun_name == nil then return nil end
      return { left = ('%s('):format(fun_name), right = ')' }
    end,
  },
  -- Tag
  ['t'] = {
    input = { '<(%w-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
    output = function()
      local tag_full = Config.user_input('Tag')
      if tag_full == nil then return nil end
      local tag_name = tag_full:match('^%S*')
      return { left = '<' .. tag_full .. '>', right = '</' .. tag_name .. '>' }
    end,
  },
  -- Quotes
  ['q'] = { input = { { "'.-'", '".-"', '`.-`' }, '^.().*().$' }, output = { left = '"', right = '"' } },
}

-- Cache for dot-repeatability. This table is currently used with these keys:
-- - 'input' - surround info for searching (in 'delete' and 'replace' start).
-- - 'output' - surround info for adding (in 'add' and 'replace' end).
-- - 'direction' - direction in which `MiniSurround.find()` should go. Used to
--   enable same `operatorfunc` pattern for dot-repeatability.
-- - 'search_method' - search method.
-- - 'msg_shown' - whether helper message was shown.
Config.cache = {}

-- Helper functionality =======================================================
-- Settings -------------------------------------------------------------------
Config.setup_config = function(user_config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config
  vim.validate('config', user_config, 'table', true)
  local config = vim.tbl_deep_extend('force', vim.deepcopy(default_config), user_config or {})

  -- Validate per nesting level to produce correct error message
  vim.validate('custom_surroundings', config.custom_surroundings, 'table')
  vim.validate('mappings.highlight', config.mappings.highlight, 'string')
  vim.validate('mappings.replace', config.mappings.replace, 'string')
  vim.validate('mappings.update_n_lines', config.mappings.update_n_lines, 'string')

  vim.validate('mappings.suffix_last', config.mappings.suffix_last, 'string')
  vim.validate('mappings.suffix_next', config.mappings.suffix_next, 'string')

  return config
end

Config.map = function(mode, lhs, rhs, opts)
  if lhs == '' then
    return
  end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

Config.apply_config = function(config)
  local expr_map = function(lhs, rhs, desc)
    Config.map('n', lhs, rhs, { expr = true, desc = desc })
  end

  Config.config = config

  --stylua: ignore start
  -- Make regular mappings
  local m = config.mappings

  expr_map(m.add,       Config.make_operator('add', nil, nil, true), 'Add surrounding')
  expr_map(m.delete,    Config.make_operator('delete'),              'Delete surrounding')
  expr_map(m.replace,   Config.make_operator('replace'),             'Replace surrounding')
  expr_map(m.find,      Config.make_operator('find', 'right'),       'Find right surrounding')
  expr_map(m.find_left, Config.make_operator('find', 'left'),        'Find left surrounding')
  expr_map(m.highlight, Config.make_operator('highlight'),           'Highlight surrounding')

  Config.map('n', m.update_n_lines, Config.update_n_lines, { desc = 'Update `MiniSurround.config.n_lines`' })
  Config.map('x', m.add, [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = 'Add surrounding to selection' })

  -- Make extended mappings
  local suffix_map = function(lhs, suffix, rhs, desc)
    -- Don't create extended mapping if user chose not to create regular one
    if lhs == '' then return end
    expr_map(lhs .. suffix, rhs, desc)
  end

  if m.suffix_last ~= '' then
    local operator_prev = function(method, direction)
      return Config.make_operator(method, direction, 'prev')
    end

    local suff = m.suffix_last
    suffix_map(m.delete,    suff, operator_prev('delete'),        'Delete previous surrounding')
    suffix_map(m.replace,   suff, operator_prev('replace'),       'Replace previous surrounding')
    suffix_map(m.find,      suff, operator_prev('find', 'right'), 'Find previous right surrounding')
    suffix_map(m.find_left, suff, operator_prev('find', 'left'),  'Find previous left surrounding')
    suffix_map(m.highlight, suff, operator_prev('highlight'),     'Highlight previous surrounding')
  end

  if m.suffix_next ~= '' then
    local operator_next = function(method, direction)
      return Config.make_operator(method, direction, 'next')
    end

    local suff = m.suffix_next
    suffix_map(m.delete,    suff, operator_next('delete'),        'Delete next surrounding')
    suffix_map(m.replace,   suff, operator_next('replace'),       'Replace next surrounding')
    suffix_map(m.find,      suff, operator_next('find', 'right'), 'Find next right surrounding')
    suffix_map(m.find_left, suff, operator_next('find', 'left'),  'Find next left surrounding')
    suffix_map(m.highlight, suff, operator_next('highlight'),     'Highlight next surrounding')
  end

  --stylua: ignore end
end

Config.get_config = function(user_config)
  return vim.tbl_deep_extend(
    'force',
    Config.default_config,
    vim.b.minisurround_config or {},
    Config.config or {},
    user_config or {}
  )
end

Config.create_default_hl = function()
  vim.api.nvim_set_hl(0, 'MiniSurround', { default = true, link = 'IncSearch' })
end

Config.is_disabled = function()
  return vim.g.minisurround_disable == true or vim.b.minisurround_disable == true
end

Config.get_default_opts = function()
  local config = Config.get_config()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  return {
    n_lines = config.n_lines,
    n_times = Config.cache.count or vim.v.count1,
    -- Empty region at cursor position
    reference_region = { from = { line = cur_pos[1], col = cur_pos[2] + 1 } },
    search_method = Config.cache.search_method or config.search_method,
  }
end

Config.get_default_surrounding_info = function(char)
  local char_esc = vim.pesc(char)
  return { input = { char_esc .. '().-()' .. char_esc }, output = { left = char, right = char } }
end

Config.is_search_method = function(x, x_name)
  x = x or Config.get_config().search_method
  x_name = x_name or '`config.search_method`'

  local allowed_methods = vim.tbl_keys(Span.span_compare_methods)
  if vim.tbl_contains(allowed_methods, x) then
    return true
  end

  table.sort(allowed_methods)
  local allowed_methods_string = table.concat(vim.tbl_map(vim.inspect, allowed_methods), ', ')
  local msg = ([[%s should be one of %s.]]):format(x_name, allowed_methods_string)
  return false, msg
end

Config.validate_search_method = function(x, x_name)
  local is_valid, msg = Config.is_search_method(x, x_name)
  if not is_valid then
    Config.error(msg)
  end
end

--- Ask user for input
---
--- This is mainly a wrapper for |input()| which allows empty string as input,
--- cancelling with `<Esc>` and `<C-c>`, and slightly modifies prompt. Use it
--- to ask for input inside function custom surrounding (see |MiniSurround.config|).
Config.user_input = function(prompt, text)
  -- Major issue with both `vim.fn.input()` is that the only way to distinguish
  -- cancelling with `<Esc>` and entering empty string with immediate `<CR>` is
  -- through `cancelreturn` option (see `:h input()`). In that case the return
  -- of `cancelreturn` will mean actual cancel, which removes possibility of
  -- using that string. Although doable with very obscure string, this is not
  -- very clean.
  -- Overcome this by adding temporary keystroke listener.
  local on_key = vim.on_key or vim.register_keystroke_callback
  local was_cancelled = false
  on_key(function(key)
    if key == vim.api.nvim_replace_termcodes('<Esc>', true, true, true) then
      was_cancelled = true
    end
  end, Config.ns_id.input)

  -- Ask for input
  -- NOTE: it would be GREAT to make this work with `vim.ui.input()` but I
  -- didn't find a way to make it work without major refactor of whole module.
  -- The main issue is that `vim.ui.input()` is designed to perform action in
  -- callback and current module design is to get output immediately. Although
  -- naive approach of
  -- `local res; vim.ui.input({...}, function(input) res = input end)`
  -- works in default `vim.ui.input`, its reimplementations can return from it
  -- immediately and proceed in main event loop. Couldn't find a relatively
  -- simple way to stop execution of this current function until `ui.input()`'s
  -- callback finished execution.
  local opts = { prompt = '(mini.surround) ' .. prompt .. ': ', default = text or '' }
  vim.cmd('echohl Question')
  -- Use `pcall` to allow `<C-c>` to cancel user input
  local ok, res = pcall(vim.fn.input, opts)
  vim.cmd([[echohl None | echo '' | redraw]])

  -- Stop key listening
  on_key(nil, Config.ns_id.input)

  if not ok or was_cancelled then
    return
  end
  return res
end

--- Update `MiniSurround.config.n_lines`
---
--- Convenient wrapper for updating `MiniSurround.config.n_lines` in case the
--- default one is not appropriate.
Config.update_n_lines = function()
  if Config.is_disabled() then
    return '<Esc>'
  end
  local old_n_lines = Config.get_config().n_lines
  local n_lines = Config.user_input('New number of neighbor lines', old_n_lines)
  n_lines = math.floor(tonumber(n_lines) or old_n_lines)
  Config.apply_config({ n_lines = n_lines })
end

-- Mappings -------------------------------------------------------------------
Config.make_operator = function(task, direction, search_method, ask_for_textobject)
  return function()
    if Config.is_disabled() then
      -- Using `<Esc>` helps to stop moving cursor caused by current
      -- implementation detail of adding `' '` inside expression mapping
      return [[\<Esc>]]
    end

    Config.cache = { count = vim.v.count1, direction = direction, search_method = search_method }

    vim.o.operatorfunc = 'v:lua.MiniSurround.' .. task

    -- NOTEs:
    -- - Prepend with command to reset `vim.v.count1` to allow
    -- `[count1]sa[count2][textobject]`.
    -- - Concatenate `' '` to operator output to "disable" motion
    --   required by `g@`. It is used to enable dot-repeatability.
    return '<Cmd>echon ""<CR>g@' .. (ask_for_textobject and '' or ' ')
  end
end

Config.message = function(msg)
  utils.echo(msg, true)
end

Config.error = function(msg)
  error(string.format('(mini.surround) %s', msg))
end

Config.error_treesitter = function(failed_get, lang)
  local bufnr = vim.api.nvim_get_current_buf()
  local msg =
    string.format([[Can not get %s for buffer %d and language '%s'.]], failed_get, bufnr, lang)
  Config.error(msg)
end

return Config
