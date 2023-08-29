local cmp = require('cmp')
local cmp_types = require('cmp.types.cmp')
local luasnip = require('luasnip')

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  vim.api.nvim_feedkeys(enter_key, 'n', false)
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local mapping = {
  main = {
    ['<C-x><C-o>'] = cmp.mapping.complete({}),
    ['<C-x><C-s>'] = cmp.mapping.complete({ config = { sources = { { name = 'luasnip' } } } }),
    ['<Up>'] = cmp.mapping.scroll_docs(-1),
    ['<Down>'] = cmp.mapping.scroll_docs(1),
    ['<C-p>'] = cmp.mapping.select_prev_item({ count = 1 }),
    ['<C-n>'] = cmp.mapping.select_next_item({ count = 1 }),
    ['<C-Up>'] = cmp.mapping.scroll_docs(-6),
    ['<C-Down>'] = cmp.mapping.scroll_docs(6),
    ['<M-b>'] = cmp.mapping.scroll_docs(-6),
    ['<M-f>'] = cmp.mapping.scroll_docs(6),
    ['<C-f>'] = cmp.mapping.select_next_item({ count = 6 }),
    ['<C-b>'] = cmp.mapping.select_prev_item({ count = 6 }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-d>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<M-/>'] = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
    ['<Tab>'] = cmp.mapping(function(fallback)
      --     return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.ConfirmBehavior.Select })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- cmp.select_prev_item()
        cmp.select_prev_item({ behavior = cmp.ConfirmBehavior.Select })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'i', 's' }),
    ["<M-'>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.complete_common_string()
        -- cmp.select_next_item({ behavior = cmp.ConfirmBehavior.Select })
        cmp.confirm({ select = true })
      end
    end, { 'i', 's' }),
    -- ['<S-CR>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- }), -- Accept curr
    -- special: trigger snippets without typing the full trigger
    -- ["<Tab>"] = cmp_mapping(function(fallback)
    --    if cmp.visible() then
    --      cmp.select_next_item()
    --    elseif luasnip.expand_or_locally_jumpable() then
    --      luasnip.expand_or_jump()
    --    elseif jumpable(1) then
    --      luasnip.jump(1)
    --    elseif has_words_before() then
    --      -- cmp.complete()
    --      fallback()
    --    else
    --      fallback()
    --    end
    --  end, { "i", "s" }),
    --  ["<S-Tab>"] = cmp_mapping(function(fallback)
    --    if cmp.visible() then
    --      cmp.select_prev_item()
    --    elseif luasnip.jumpable(-1) then
    --      luasnip.jump(-1)
    --    else
    --      fallback()
    --    end
    --  end, { "i", "s" }),
    -- ["<CR>"] = cmp_mapping(function(fallback)
    --         if cmp.visible() then
    --           local confirm_opts = vim.deepcopy(lvim.builtin.cmp.confirm_opts) -- avoid mutating the original opts below
    --           local is_insert_mode = function()
    --             return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
    --           end
    --           if is_insert_mode() then -- prevent overwriting brackets
    --             confirm_opts.behavior = ConfirmBehavior.Insert
    --           end
    --           local entry = cmp.get_selected_entry()
    --           local is_copilot = entry and entry.source.name == "copilot"
    --           if is_copilot then
    --             confirm_opts.behavior = ConfirmBehavior.Replace
    --             confirm_opts.select = true
    --           end
    --           if cmp.confirm(confirm_opts) then
    --             return -- success, exit early
    --           end
    --         end
    --         fallback() -- if not exited early, always fallback
    --       end),
  },
  -- TODO: if no words after, C-P = S-Up, C-N = completion open
  cmdline = {
    -- ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }),
    ["<M-'>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        })
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'c' }),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
        send_enter()
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'c' }),
    ['<C-f>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'c' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'c' }),
  },
}

return mapping
