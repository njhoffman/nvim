local cmp = require('cmp')
local cmp_types = require('cmp.types.cmp')
local keymap = require('cmp.utils.keymap')
local luasnip = require('luasnip')
local feedkeys = require('cmp.utils.feedkeys')

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  vim.api.nvim_feedkeys(enter_key, 'n', false)
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
--       節 缾      了ﴰ   ﮕ ﳎ        陋 גּ גּ      ﴯ   
local pfx = ' '
local preserve_mapping_verticality = false
local in_history = false
local mapping = {
  main = {
    ['<C-x><C-o>'] = cmp.mapping.complete({ desc = pfx .. 'start completion source' }),
    ['<C-x><C-s>'] = cmp.mapping.complete({
      desc = pfx .. 'start snippets completion',
      config = { sources = { { name = 'luasnip' } } },
    }),
    ['<C-x><C-d>'] = cmp.mapping.complete({
      desc = pfx .. 'start ai completions',
      config = { sources = { { name = 'faker.quick_data ' } } },
    }),
    ['<C-g>'] = cmp.mapping.complete({
      desc = pfx .. 'start github copilot completion',
      config = {
        sources = {
          {
            name = 'codeium',
            max_item_count = 10,
          },
          { name = 'copilot', max_item_count = 10 },
        },
      },
    }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({
          preserve_mapping_verticality = preserve_mapping_verticality,
          count = 1,
          behavior = cmp.SelectBehavior.Select,
        })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      elseif type(fallback) == 'function' then
        cmp.complete({})
        -- fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({
          preserve_mapping_verticality = preserve_mapping_verticality,
          count = 1,
          behavior = cmp.SelectBehavior.Select,
        })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      elseif type(fallback) == 'function' then
        cmp.complete({})
        -- fallback()
      end
    end, { 'i', 's' }),
    ['<Up>'] = cmp.mapping.scroll_docs(-1),
    ['<Down>'] = cmp.mapping.scroll_docs(1),
    ['<M-b>'] = cmp.mapping.scroll_docs(-6),
    ['<M-f>'] = cmp.mapping.scroll_docs(6),
    ['<C-f>'] = cmp.mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
    ['<C-b>'] = cmp.mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-d>'] = cmp.mapping.abort(),
    -- ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
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
        -- elseif has_words_before() then
        --   cmp.complete()
      elseif type(fallback) == 'function' then
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
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
    ['<C-n>'] = cmp.mapping({
      c = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          in_history = false
        elseif in_history == true then
          cmp.mapping(cmp.complete())
          feedkeys.call(keymap.t('<Down>'), 'c')
          -- elseif type(fallback) == 'function' then
          --   fallback()
          -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
        end
      end,
    }),
    ['<C-p>'] = cmp.mapping({
      c = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          })
          in_history = false
        else
          cmp.mapping.complete({ config = { sources = { { name = 'cmdline_history' } } } })
          feedkeys.call(keymap.t('<Up>'), 'c')
          in_history = true
        end
      end,
    }),
    ['<C-f>'] = cmp.mapping({
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
    }),

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
