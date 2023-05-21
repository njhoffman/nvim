-- :h MiniAlign-glossary, MiniAlign-algorithm, MiniAlign-examples

local default = {
  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = nil,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last variants
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },

  -- Number of lines within which textobject is searched
  n_lines = 50,

  -- How to search for object (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
  search_method = 'cover_or_next',

  -- Whether to disable showing non-error feedback
  silent = false,
}

local ai = require('mini.ai')
local opts = {
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last variants
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 500,
  custom_textobjects = {
    a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }, { desc = 'around parameter' }),
    b = ai.gen_spec.treesitter({
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }, { desc = 'around block' }),
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, { desc = 'around function' }),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, { desc = 'around class' }),
  },
}

ai.setup(opts)

local vmap = require('mapper').vmap
local prefix = require('mapper').prefix

-- stylua: ignore
local text_obj = {
  [' ']    = '*inside whitespace',
  ['"']    = '*inside quote "',
  ["'"]    = "*inside s-quote '",
  ['`']    = '*inside apostrophe `',
  ['(']    = '*inside (',
  [')']    = '*inside ) including white-space',
  ['>']    = '*inside > including white-space',
  ['<lt>'] = '*inside <',
  [']']    = '*inside ] including white-space',
  ['[']    = '*inside [',
  ['}']    = '*inside } including white-space',
  ['{']    = '*inside {',
  ['?']    = '*inside user prompt',
  _        = '*inside underscore',
  a        = '*inside argument',
  b        = '*inside balanced: ), ], }',
  c        = '*inside class',
  f        = '*inside function',
  o        = '*inside block, conditional, loop',
  q        = '*inside quote: `, ", \'',
  t        = '*inside tag',
}

local prefixes = {
  ['i'] = { name = 'inside' },
  ['in'] = { name = 'next' },
  ['il'] = { name = 'last' },
  ['a'] = { name = 'around' },
  ['an'] = { name = 'next' },
  ['al'] = { name = 'last' },
  ['g['] = { name = 'goto left' },
  ['g]'] = { name = 'goto right' },
}

for k, v in ipairs(prefixes) do
  prefix({ 'o', 'x' }, k, v.name)
end

local virtual_map = function(lhs, desc, modes)
  modes = modes or { 'o', 'x' }
  vmap(modes, lhs, { desc = desc, plugin = 'mini.ai', category = 'Motion' })
end

-- for k, v in pairs(vim.deepcopy(text_obj)) do
--   virtual_map('i' .. k, v)
-- end
--
for k, v in pairs(vim.deepcopy(text_obj)) do
  local desc = string.gsub(tostring(v), 'including.*', '')
  desc = string.gsub(desc, 'inside', 'around')
  virtual_map('a' .. k, desc)
end

-- for k, v in pairs(vim.deepcopy(text_obj)) do
--   local desc = string.gsub(tostring(v), 'including.*', '')
--   desc = string.gsub(desc, 'inside', 'inside last')
--   virtual_map('il' .. k, desc)
-- end
--
-- for k, v in pairs(vim.deepcopy(text_obj)) do
--   local desc = string.gsub(tostring(v), 'including.*', '')
--   desc = string.gsub(desc, 'inside', 'inside next')
--   virtual_map('in' .. k, desc)
-- end
--
-- for k, v in pairs(vim.deepcopy(text_obj)) do
--   local desc = string.gsub(tostring(v), 'including.*', '')
--   desc = string.gsub(desc, 'inside', 'around last')
--   virtual_map('al' .. k, desc)
-- end
--
-- for k, v in pairs(vim.deepcopy(text_obj)) do
--   local desc = string.gsub(tostring(v), 'including.*', '')
--   desc = string.gsub(desc, 'inside', 'around next')
--   virtual_map('an' .. k, desc)
-- end

for k, v in pairs(vim.deepcopy(text_obj)) do
  local desc = string.gsub(tostring(v), 'including.*', '')
  desc = string.gsub(desc, 'inside', 'goto left')
  virtual_map('g[' .. k, desc, { 'x', 'o', 'n' })
end

for k, v in pairs(vim.deepcopy(text_obj)) do
  local desc = string.gsub(tostring(v), 'including.*', '')
  desc = string.gsub(tostring(desc), 'inside', 'goto right')
  virtual_map('g]' .. k, desc, { 'x', 'o', 'n' })
end

-- w word
-- gn the next search pattern match
-- s inner sentence
-- b '(' ')' block
-- p`` paragraph
-- = @.assignment
-- b @.block
-- m @.call (function)
--   @.comment (only outer)
--   @.conditional
--   @.frame
-- f @.function
-- l @.loop
--   @.number (only inner)
-- a @.parameter
--   @.return
-- s @.statement
-- c @.class ?
-- register all text objects with mapper
