-- local notify = require('notify').notify
local notify = vim.notify

local delay = 2000
local timeout = 2000

local notify_errors = function()
  -- error2 gives eol problem
  local errors = require('notify.examples.errors')
  notify(errors[6], 4, { timeout = timeout })
  -- local delay = 1000
  -- for i, example in pairs(examples) do
  --   vim.defer_fn(function()
  --     notify(example, 4, { timeout = 4000, title = i })
  --   end, delay)
  --   delay = delay + 5000
  -- end
end

local notify_simple = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering simple level: ' .. level, level, { timeout = timeout, render = 'simple' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_simple_notitle = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering simple level: ' .. level, level, { timeout = timeout, render = 'simple-notitle' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_minimal = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering simple level: ' .. level, level, { timeout = timeout, render = 'minimal' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_compact = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering simple level: ' .. level, level, { timeout = timeout, render = 'compact' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_wrapped_compact = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering simple level: ' .. level, level, { timeout = timeout, render = 'wrapped-compact' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_basic = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering basic level: ' .. level, level, { timeout = timeout })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_basic_merge = function()
  local level = 'info'
  for i = 1, 5 do
    notify('Rendering merge ' .. i, level, { timeout = timeout })
  end
  level = 'debug'
  for _ = 1, 5 do
    notify('Rendering merge', level, { timeout = timeout })
  end
end

local notify_basic_repeat = function()
  local level = 'info'
  local _delay = 0
  for _ = 1, 8 do
    vim.defer_fn(function()
      notify('Rendering repeat', level, { timeout = timeout })
    end, _delay)
    _delay = _delay + 200
  end
  local level = 'debug'
  for _ = 1, 10 do
    vim.defer_fn(function()
      notify('Rendering repeat', level, { timeout = timeout })
    end, _delay)
    _delay = _delay + 200
  end
end

local notify_titles = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering titles level: ' .. level, level, { timeout = timeout, title = level .. ' title' })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_titles_2 = function()
  local _delay = 0
  for _, level in ipairs({ 'trace', 'debug', 'info', 'warn', 'error' }) do
    vim.defer_fn(function()
      notify('Rendering titles 2 level: ' .. level, level, {
        timeout = timeout,
        title = { level .. ' title', level },
      })
    end, _delay)
    _delay = _delay + delay
  end
end

local custom_messages = {
  {
    { { 'Notify', 'Keyword' }, { ' ' }, { 'Custom highlights', 'Comment' } },
  },
  {
    {
      { 'Notify', 'Keyword' },
      { ' ' },
      { 'Custom highlights', 'Comment' },
    },
    {
      { 'Line 2 Operator', 'Operator' },
      { ' Normal ' },
      { 'highlight', 'Comment' },
    },
  },
}

local notify_custom_hl = function()
  local _delay = 0
  for _, msg in ipairs(custom_messages) do
    vim.defer_fn(function()
      notify(msg, 2, {
        render = 'simple-notitle',
        timeout = timeout,
      })
    end, _delay)
    _delay = _delay + delay
  end
  _delay = _delay + delay
  for _, msg in ipairs(custom_messages) do
    vim.defer_fn(function()
      notify(msg, 1, {
        render = 'simple-notitle',
        timeout = timeout,
        title = 'custom hl title',
      })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_long = function()
  local msg =
    'Use parentheses to group and prioritize calculations. For example, <Ctrl>+<R>=3*(4+2) will calculate the result of the expression 3*(4+2).'
end

-- stylua: ignore
local funcs = {
  errors           = notify_errors,
  minimal          = notify_minimal,
  simple           = notify_simple,
  simple_notitle   = notify_simple_notitle,
  compact          = notify_compact,
  wrappped_compact = notify_wrapped_compact,
  basic            = notify_basic,
  basic_merge      = notify_basic_merge,
  basic_repeat     = notify_basic_repeat,
  titles           = notify_titles,
  titles_2         = notify_titles_2,
  custom_hl        = notify_custom_hl,
}

local notify_test = function(category)
  if category ~= nil then
    category = type(category) == 'string' and { category } or category
    local _delay = 0
    for _, cat in ipairs(category) do
      if not funcs[cat] then
        vim.dbglog('*** invalid category ***', cat)
      else
        vim.defer_fn(funcs[cat], _delay)
        _delay = _delay + delay * 5
      end
    end
  else
    notify_minimal()
    notify_simple()
    notify_simple_notitle()
    notify_compact()
    notify_wrapped_compact()
    notify_basic()
    notify_basic_merge()
    notify_basic_repeat()
    notify_titles()
    notify_titles_2()
    notify_custom_hl()
    notify_errors()
  end
end

-- require('noice').setup({ views = { notify = { level = vim.lsp.log_levels['TRACE'] } } })
-- require('notify').setup({ level = vim.lsp.log_levels['INFO'] })
-- vim.dbglog('level', require('notify')._config().level())
-- require('notify.config').setup({ level = vim.lsp.log_levels['INFO'] })
-- require('notify').instance({ level = vim.lsp.log_levels['INFO'] })
notify_test({
  -- 'errors',
  -- 'minimal',
  -- 'simple',
  -- 'simple_notitle',
  -- 'compact',
  -- 'wrapped_compact',
  -- 'basic',
  -- 'basic_merge',
  -- 'basic_repeat',
  -- 'titles',
  -- 'titles_2',
  'custom_hl',
  -- 'custom_hl_raw',
})

-- vim.api.nvim_create_user_command('NotifyTest', notify_test, { desc = 'Notifications renderings' })
