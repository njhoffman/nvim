local cmp = require('cmp')
local cmp_types = require('cmp.types.cmp')
local luasnip = require('luasnip')

--       節 缾      了ﴰ   ﮕ ﳎ        陋 גּ גּ      ﴯ   
local pfx = ' '

local preserve_mapping_verticality = false
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local main = {
  ['<C-x><C-o>'] = cmp.mapping.complete({ desc = pfx .. 'start completion source' }),
  ['<C-x><C-s>'] = cmp.mapping.complete({
    desc = pfx .. 'start snippets completion',
    config = { sources = { { name = 'luasnip' } } },
  }),
  ['<C-x><C-f>'] = cmp.mapping.complete({
    desc = pfx .. 'start ai completions',
    config = { sources = { { name = 'faker.quick_data' } } },
  }),
  ['<C-g>'] = cmp.mapping.complete({
    desc = pfx .. 'start github copilot completion',
    config = { sources = { { name = 'codeium', max_item_count = 10 }, { name = 'copilot', max_item_count = 10 } } },
  }),
  ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false }), { 'i' }),
  ['<C-D>'] = cmp.mapping(cmp.mapping.abort(), { 'i' }),
  ['<Down>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i' }),
  ['<Up>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i' }),
  ['<C-e>'] = cmp.mapping(cmp.mapping.close(), { 'i' }),
  ['<M-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-6), { 'i' }),
  ['<M-f>'] = cmp.mapping(cmp.mapping.scroll_docs(6), { 'i' }),
  ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i' }),
  ['<C-n>'] = {
    i = function()
      if cmp.visible() then
        cmp.mapping(cmp.select_next_item({ behavior = cmp_types.SelectBehavior.Select }))
      else
        cmp.complete()
      end
    end,
  },
  ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }), { 'i' }),
  ['<C-B>'] = cmp.mapping(
    cmp.mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
    { 'i' }
  ),
  ['<C-F>'] = cmp.mapping(
    cmp.mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
    { 'i' }
  ),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item({ behavior = cmp_types.SelectBehavior.Select })
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
      --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
    elseif has_words_before() then
      cmp.complete()
    elseif type(fallback) == 'function' then
      fallback()
    end
  end, { 'i' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      -- cmp.select_prev_item()
      cmp.select_prev_item({ behavior = cmp_types.SelectBehavior.Select })
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif type(fallback) == 'function' then
      fallback()
    end
  end, { 'i' }),
  -- ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }), { 'i' }),
}

-- TODO: if no words after, C-P = S-Up, C-N = completion open

return main
