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
    around_last = 'ap',
    inside_last = 'ip',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 500,
  custom_textobjects = {
    a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }, { desc = 'around parameter' }),
    b = ai.gen_spec.treesitter({ a = { '@block.outer', '@conditional.outer', '@loop.outer' }, i = { '@block.inner', '@conditional.inner', '@loop.inner' } }, { desc = 'around block' }),
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, { desc = 'around function' }),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, { desc = 'around class' }),
  },
}
ai.setup(opts)
-- local vmap = require('mapper').vmap

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
-- local textobjects = {
--   [' '] = 'Whitespace',
--   ['"'] = 'Balanced "',
--   ["'"] = "Balanced '",
--   ['`'] = 'Balanced `',
--   ['('] = 'Balanced (',
--   [')'] = 'Balanced ) including white-space',
--   ['>'] = 'Balanced > including white-space',
--   ['<lt>'] = 'Balanced <',
--   [']'] = 'Balanced ] including white-space',
--   ['['] = 'Balanced [',
--   ['}'] = 'Balanced } including white-space',
--   ['{'] = 'Balanced {',
--   ['?'] = 'User Prompt',
--   _ = 'Underscore',
--   a = 'Argument',
--   b = 'Balanced ), ], }',
--   c = 'Class',
--   f = 'Function',
--   o = 'Block, conditional, loop',
--   q = 'Quote `, ", \'',
--   t = 'Tag',
-- }
-- m('n', maps.goto_left,  [[v:lua.MiniAi.expr_motion('left')]],   { desc = 'Move to left "around"' })
-- m('n', maps.goto_right, [[v:lua.MiniAi.expr_motion('right')]],  { desc = 'Move to right "around"' })
-- m('x', maps.goto_left,  [[v:lua.MiniAi.expr_motion('left')]],   { desc = 'Move to left "around"' })
-- m('x', maps.goto_right, [[v:lua.MiniAi.expr_motion('right')]],  { desc = 'Move to right "around"' })
-- m('o', maps.goto_left,  [[v:lua.MiniAi.expr_motion('left')]],   { desc = 'Move to left "around"' })
-- m('o', maps.goto_right, [[v:lua.MiniAi.expr_motion('right')]],  { desc = 'Move to right "around"' })
--
-- m('x', maps.around, [[v:lua.MiniAi.expr_textobject('x', 'a')]], { desc = 'Around textobject' })
-- m('x', maps.inside, [[v:lua.MiniAi.expr_textobject('x', 'i')]], { desc = 'Inside textobject' })
-- m('o', maps.around, [[v:lua.MiniAi.expr_textobject('o', 'a')]], { desc = 'Around textobject' })
-- m('o', maps.inside, [[v:lua.MiniAi.expr_textobject('o', 'i')]], { desc = 'Inside textobject' })
--
-- m('x', maps.around_next, [[v:lua.MiniAi.expr_textobject('x', 'a', {'search_method': 'next'})]], { desc = 'Around next textobject' })
-- m('x', maps.around_last, [[v:lua.MiniAi.expr_textobject('x', 'a', {'search_method': 'prev'})]], { desc = 'Around last textobject' })
-- m('x', maps.inside_next, [[v:lua.MiniAi.expr_textobject('x', 'i', {'search_method': 'next'})]], { desc = 'Inside next textobject' })
-- m('x', maps.inside_last, [[v:lua.MiniAi.expr_textobject('x', 'i', {'search_method': 'prev'})]], { desc = 'Inside last textobject' })
-- m('o', maps.around_next, [[v:lua.MiniAi.expr_textobject('o', 'a', {'search_method': 'next'})]], { desc = 'Around next textobject' })
-- m('o', maps.around_last, [[v:lua.MiniAi.expr_textobject('o', 'a', {'search_method': 'prev'})]], { desc = 'Around last textobject' })
-- m('o', maps.inside_next, [[v:lua.MiniAi.expr_textobject('o', 'i', {'search_method': 'next'})]], { desc = 'Inside next textobject' })
-- m('o', maps.inside_last, [[v:lua.MiniAi.expr_textobject('o', 'i', {'search_method': 'prev'})]], { desc = 'Inside last textobject' })
--

-- for to_key, to_name in pairs(textobjects) do
--   vim.dbglog({"x", "o"}, 'an',  )
-- end

-- for dir_key, dir_name in pairs({ n = 'Next', l = 'Last' }) do
--   for lhs, name in pairs(inside) do
--     vmap({ 'o', 'x' }, lhs, {
--       label = 'inside ' .. name .. ' (' .. dir_key .. ')',
--       desc = 'inside ' .. dir_name .. ' ' .. name .. ' textobject ',
--       plugin = 'mini.ai',
--       category = 'Motion',
--     })
--   end
--   for lhs, name in pairs(around) do
--     vmap({ 'o', 'x' }, lhs, {
--       label = 'around ' .. name .. ' (' .. dir_key .. ')',
--       desc = 'around ' .. dir_name .. ' ' .. name .. ' textobject ',
--       plugin = 'mini.ai',
--       category = 'Motion',
--     })
--   end
-- end
--
-- mappings = {
--   -- Main textobject prefixes
--   around = 'a',
--   inside = 'i',
--
--   -- Next/last variants
--   around_next = 'an',
--   inside_next = 'in',
--   around_last = 'al',
--   inside_last = 'il',
--
--   -- Move cursor to corresponding edge of `a` textobject
--   goto_left = 'g[',
--   goto_right = 'g]',
-- },

-- local to_include = {
--   [' '] = 'Whitespace',
--   ['"'] = 'Balanced "',
--   ["'"] = "Balanced '",
--   ['`'] = 'Balanced `',
--   ['('] = 'Balanced (',
--   [')'] = 'Balanced ) including white-space',
--   ['>'] = 'Balanced > including white-space',
--   ['<lt>'] = 'Balanced <',
--   [']'] = 'Balanced ] including white-space',
--   ['['] = 'Balanced [',
--   ['}'] = 'Balanced } including white-space',
--   ['{'] = 'Balanced {',
--   ['?'] = 'User Prompt',
--   _ = 'Underscore',
--   a = 'Argument',
--   b = 'Balanced ), ], }',
--   c = 'Class',
--   f = 'Function',
--   o = 'Block, conditional, loop',
--   q = 'Quote `, ", \'',
--   t = 'Tag',
-- }
--
-- for dirkey, dirname in pairs({ n = 'Next', l = 'Last' }) do
--   inside[] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, insidec)
--   around[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, aroundc)
-- end
--
-- vim.dbglog('INSIDE', { i = inside, a = around })
-- require('which-key').register({
--   mode = { 'o', 'x' },
--   i = i,
--   a = a,
-- })

--
