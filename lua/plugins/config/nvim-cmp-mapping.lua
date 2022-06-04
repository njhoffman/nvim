-- mapping.preset.cmdline = function(override)
--   return misc.merge(override or {}, {
-- end


local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function cmp_mappings()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  return {
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      'i',
      's',
      'c',
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      'i',
      's',
      'c',
    }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping({ c = cmp.mapping.confirm({ select = true }) }),
    ['<Right>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.mapping.confirm({ select = true })()
      else
        fallback()
      end
    end, {
      'c',
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.mapping.close()()
      else
        fallback()
      end
    end, {
      'i',
      'c',
    }),
  }
end

-- local insert_override = {
--   ["<C-x><C-o>"] = cmp.mapping.complete(),
--   ["<C-x><C-s>"] = cmp.mapping.complete(
--     {
--       config = { sources = { { name = "luasnip" } } }
--     }
--   ),
--   ["<C-F>"] = cmp.mapping(
--     function(fallback)
--       if cmp.visible() then
--         for _ = 1, 10 do
--           cmp.mapping.select_next_item()(nil)
--         end
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--   ["<C-B>"] = cmp.mapping(
--     function(fallback)
--       if cmp.visible() then
--         for _ = 1, 10 do
--           cmp.mapping.select_prev_item()(nil)
--         end
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--   ['<Tab>'] = function(fallback)
--     if cmp.visible() then
--       cmp.select_next_item()
--     elseif luasnip.expand_or_jumpable() then
--       vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
--     else
--       fallback()
--     end
--   end,
--   ['<S-Tab>'] = function(fallback)
--     if cmp.visible() then
--       cmp.select_prev_item()
--     elseif luasnip.jumpable(-1) then
--       vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
--     else
--       fallback()
--     end
--   end,

--   ['<C-e>'] = cmp.mapping(cmp.mapping.close(), { "i" }),
--   ["<C-D>"] = cmp.mapping({
--     cmp.mapping.abort()
--   }, { "i", "s" }),
--   ["<C-Space>"] = cmp.mapping.confirm {
--     behavior = cmp.ConfirmBehavior.Insert,
--     select = true,
--   },
--   ["<CR>"] = cmp.mapping.confirm({
--     behaviour = cmp.ConfirmBehavior.Replace,
--     select = false
--   }),
--   -- ["<CR>"] = cmp.mapping.confirm({ select = false }),
--   ["<PageUp>"] = cmp.mapping.scroll_docs(-2),
--   ["<PageDown>"] = cmp.mapping.scroll_docs(2),
--   ["<Up>"] = cmp.mapping.scroll_docs(-2),
--   ["<Down>"] = cmp.mapping.scroll_docs(2)
-- }

-- local cmdline_override = {
--   -- TODO: reconcile C-F, C-P with history
--   ["<C-F>"] = cmp.mapping(
--     function(fallback)
--       cmp = require("cmp")
--       if cmp.visible() then
--         for _ = 1, 10 do
--           cmp.mapping.select_next_item()(nil)
--         end
--       else
--         fallback()
--       end
--     end, { "i", "c" }),
--   ["<C-B>"] = cmp.mapping(
--     function(fallback)
--       cmp = require("cmp")
--       if cmp.visible() then
--         for _ = 1, 10 do
--           cmp.mapping.select_prev_item()(nil)
--         end
--       else
--         fallback()
--       end
--     end, { "i", "c" }),
--   ["<C-d>"] = cmp.mapping.close(),
--   ["<C-n>"] = cmp.mapping.select_next_item(),
--   ["<C-p>"] = cmp.mapping.select_prev_item(),
--   ["<Tab>"] = cmp.mapping.select_next_item(),
--   ["<S-Tab>"] = cmp.mapping.select_prev_item(),
--   ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--   ["<C-e>"] = cmp.mapping.confirm({
--     behavior = cmp.ConfirmBehavior.Insert,
--     select = true,
--   }),
--   ["<PageUp>"] = cmp.mapping(function(fallback)
--     for i = 1, 8 do
--       cmp.mapping.select_prev_item()(nil)
--     end
--   end),
--   ["<PageDown>"] = cmp.mapping(function(fallback)
--     for i = 1, 8 do
--       cmp.mapping.select_next_item()(nil)
--     end
--   end),
-- }

return {
  insert_override  = insert_override,
  cmdline_override = {},
  cmp_mappings     = cmp_mappings
}
