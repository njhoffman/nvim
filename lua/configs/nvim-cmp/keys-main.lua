local cmp = require('cmp')
local cmp_types = require('cmp.types.cmp')
local keymap = require('cmp.utils.keymap')
local luasnip = require('luasnip')
local feedkeys = require('cmp.utils.feedkeys')

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  vim.api.nvim_feedkeys(enter_key, 'n', false)
end

local in_history = true

local has_chars_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('.%+') == nil
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

--       節 缾      了ﴰ   ﮕ ﳎ        陋 גּ גּ      ﴯ   
local pfx = ' '
local preserve_mapping_verticality = false
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
  ['<C-n>'] = {
    i = function()
      if cmp.visible() then
        -- cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
        cmp.select_next_item({
          preserve_mapping_verticality = preserve_mapping_verticality,
          count = 1,
          behavior = cmp.SelectBehavior.Select,
        })
      else
        cmp.complete()
        -- vim.api.nvim_set_option_value('omnifunc', nil, {})
        -- if cmp.visible() then
        -- vim.dbglog('visible')
        -- elseif luasnip.expand_or_jumpable() then
        --   luasnip.expand_or_jump()
        --   -- elseif type(fallback) == 'function' then
        --   -- fallback()
        -- else
        -- cmp.complete({})
        vim.dbglog('complete')
        -- end
      end
    end,
  },
  ['<C-p>'] = {
    i = function(fallback)
      if cmp.visible() then
        vim.dbglog('visible')
        cmp.select_prev_item({
          preserve_mapping_verticality = preserve_mapping_verticality,
          count = 1,
          behavior = cmp.SelectBehavior.Select,
        })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        cmp.complete()
        vim.dbglog('complete')
        -- elseif type(fallback) == 'function' then
        -- fallback()
      end
    end,
  },
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
  -- ['<CR>'] = cmp.mapping.confirm({ select = false }),
  ['<CR>'] = {
    i = function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  -- s = cmp.mapping.confirm({ select = true }),
  -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  ['<M-/>'] = {
    i = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
  },
  -- require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
  ['<Tab>'] = {
    i = function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  ['<S-Tab>'] = {
    i = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },

  -- ["<M-'>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.complete_common_string()
  --     -- cmp.select_next_item({ behavior = cmp.ConfirmBehavior.Select })
  --     cmp.confirm({ select = true })
  --   end
  -- end, { 'i', 's' }),
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
}
-- TODO: if no words after, C-P = S-Up, C-N = completion open

return main
