local gen_spec = require('mini.ai').gen_spec

local miniAiGitsigns = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local hunks = require('gitsigns.cache').cache[bufnr].hunks
  hunks = vim.tbl_map(function(hunk)
    local from_line = hunk.added.start
    local from_col = 1
    local to_line = hunk.vend
    local to_col = #vim.api.nvim_buf_get_lines(bufnr, to_line - 1, to_line, false)[1] + 1
    return {
      from = { line = from_line, col = from_col },
      to = { line = to_line, col = to_col },
    }
  end, hunks)

  return hunks
end

local gen_ai_spec = require('mini.extra').gen_ai_spec
local custom_objects = {
  -- argument
  a = gen_spec.argument({ separator = '[,;]' }),
  -- Brackets
  b = { { '%b()', '%b[]', '%b{}' }, '^.().*().$' },
  -- Comments
  -- digits
  d = gen_ai_spec.number(),
  -- diagnostics
  e = gen_ai_spec.diagnostic(),
  -- Function call
  f = gen_spec.function_call(),
  -- grammer (sentence)
  g = {
    {
      '%b{}',
      '\n%s*\n()().-()\n%s*\n[%s]*()', -- normal paragraphs
      '^()().-()\n%s*\n[%s]*()', -- paragraph at start of file
      '\n%s*\n()().-()()$', -- paragraph at end of file
    },
    {
      '[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]', -- normal sentence
      '^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]', -- sentence at start of paragraph
      '[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$', -- sentence at end of paragraph
      '^[%s]*()().-[^%s].-()()[%s]+$', -- sentence at that fills paragraph (no final punctuation)
    },
  },
  -- git hunks
  h = miniAiGitsigns,
  -- Indents
  i = gen_ai_spec.indent(),
  -- Jumps
  -- key (from key value pair)
  k = gen_spec.treesitter({
    i = { '@key.inner', '@assignment.lhs' },
    a = { '@key.inner', '@assignment.lhs' },
  }),
  -- List (quickfix)
  -- blOck
  o = gen_spec.treesitter({
    a = { '@block.outer', '@conditional.outer', '@loop.outer' },
    i = { '@block.inner', '@conditional.inner', '@loop.inner' },
  }),
  -- paragraph
  p = {
    {
      '\n%s*\n()().-()\n%s*\n()[%s]*', -- normal paragraphs
      '^()().-()\n%s*\n[%s]*()', -- paragraph at start of file
      '\n%s*\n()().-()()$', -- paragraph at end of file
    },
  },
  -- Quotes
  q = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
  -- sub-word (below w on my keyboard)
  r = {
    {
      '%u[%l%d]+%f[^%l%d]',
      '%f[%S][%l%d]+%f[^%l%d]',
      '%f[%P][%l%d]+%f[^%l%d]',
      '^[%l%d]+%f[^%l%d]',
    },
    '^().*()$',
  },
  -- scope
  s = gen_spec.treesitter({
    a = { '@function.outer', '@class.outer', '@testitem.outer' },
    i = { '@function.inner', '@class.inner', '@testitem.inner' },
  }),
  -- Tag
  t = { '<(%w-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
  -- value (from key value pair)
  v = gen_spec.treesitter({
    i = { '@value.inner', '@assignment.rhs' },
    a = { '@value.inner', '@assignment.rhs' },
  }),
  -- WORD
  W = { {
    '()()%f[%w%p][%w%p]+()[ \t]*()',
  } },
  -- word
  w = { '()()%f[%w_][%w_]+()[ \t]*()' },
  -- line (same key as visual line in my mappings)
  x = gen_ai_spec.line(),
  -- chunk (as in from vim-textobj-chunk)
  z = {
    '\n.-%b{}.-\n',
    '\n().-()%{\n.*\n.*%}().-\n()',
  },
  ['$'] = gen_spec.pair('$', '$', { type = 'balanced' }),
}
