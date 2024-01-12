local luasnip = require('luasnip')
local mapping = require('cmp.config.mapping')
local types = require('cmp.types')

--       節 缾      了ﴰ   ﮕ ﳎ        陋 גּ גּ      ﴯ   
local pfx = ' '

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- TODO: if no words after, C-P = S-Up, C-N = completion open

local main = {
  ['<C-x><C-o>'] = { i = mapping.complete({ desc = pfx .. 'start completion source' }) },
  ['<C-x><C-s>'] = {
    i = mapping.complete({
      desc = pfx .. 'start snippets completion',
      config = { sources = { { name = 'luasnip' } } },
    }),
  },
  ['<C-x><C-f>'] = {
    i = mapping.complete({
      desc = pfx .. 'start ai completions',
      config = { sources = { { name = 'faker.quick_data' } } },
    }),
  },
  ['<C-g>'] = {
    i = mapping.complete({
      desc = pfx .. 'start github copilot completion',
      config = { sources = { { name = 'codeium', max_item_count = 10 }, { name = 'copilot', max_item_count = 10 } } },
    }),
  },
  ['<Down>'] = { i = mapping.scroll_docs(1) },
  ['<Up>'] = { i = mapping.scroll_docs(-1) },
  ['<C-e>'] = { i = mapping.close() },
  ['<M-b>'] = { i = mapping.scroll_docs(-6) },
  ['<M-f>'] = { i = mapping.scroll_docs(6) },
  ['<C-n>'] = {
    i = function()
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ['<C-p>'] = {
    i = function()
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ['<C-B>'] = {
    i = mapping.select_prev_item({
      count = 6,
      behavior = types.cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ['<C-F>'] = {
    i = mapping.select_next_item({
      count = 6,
      behavior = types.cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  -- ['<C-space>'] = mapping.complete(),
  ['<C-Space>'] = { i = mapping.complete() },
  ['<CR>'] = { i = mapping.confirm({ select = false }) },
  -- if cmp.get_active_entry() then
  --        cmp.confirm()
  --    else
  --        require'ultimate-autopair.maps.cr'.cmpnewline()
  --    end
  ['<C-D>'] = { i = mapping.abort() },
  ['<Tab>'] = {
    i = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      elseif has_words_before() then
        cmp.complete()
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  ['<S-Tab>'] = {
    i = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        -- cmp.select_prev_item()
        cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Select })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
}

return main
