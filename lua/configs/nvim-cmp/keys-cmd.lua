local cmdline = {
  -- ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }),
  ["<M-'>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        })
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  ['<C-n>'] = {
    c = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  ['<C-p>'] = {
    c = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  -- ['<C-n>'] = {
  --   c = function(fallback)
  --     if cmp.visible() and not in_history then
  --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  --     elseif in_history == true then
  --       feedkeys.call(keymap.t('<Down>'), 'c')
  --       -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
  --       -- cmp.complete()
  --     elseif has_chars_before() or not in_history then
  --       in_history = false
  --       -- cmp.complete()
  --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  --     else
  --       cmp.complete()
  --       -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  --       -- elseif type(fallback) == 'function' then
  --       -- fallback()
  --     end
  --   end,
  -- },
  -- ['<C-p>'] = {
  --   c = function(fallback)
  --     if cmp.visible() and cmp.get_selected_entry() then
  --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
  --     elseif in_history == true then
  --       -- cmp.mapping.complete({ config = { sources = { { name = 'cmdline_history' } } } })
  --       feedkeys.call(keymap.t('<Up>'), 'c')
  --     -- elseif type(fallback) == 'function' then
  --     --   fallback()
  --     else
  --       cmp.complete()
  --     end
  --   end,
  -- },
  ['<C-f>'] = {
    c = function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  ['<C-b>'] = {
    c = function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
}

return cmdline
