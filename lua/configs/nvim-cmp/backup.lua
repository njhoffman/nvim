
-- mapping.preset.cmdline = function(override)
--   return misc.merge(override or {}, {
-- end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function cmp_mappings()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local luasnip = require("luasnip")
  -- local insert = {
  --   ["<C-x><C-o>"] = { i = cmp.mapping.complete() },
  --   ["<C-x><C-s>"] = { i = cmp.mapping.complete({
  --     config = { sources = { { name = "luasnip" } } },
  --   }) },
  --   ["<CR>"] = { i = cmp.mapping.confirm({ select = false }) },
  -- }
  local insert = {
    ["<C-x><C-o>"] = cmp.mapping.complete(),
    ["<C-x><C-s>"] = cmp.mapping.complete({
      config = { sources = { { name = "luasnip" } } },
    }),
    -- ["<C-n>"] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
    -- ["<C-p>"] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
    ["<Up>"] = cmp.mapping.scroll_docs(-1),
    ["<Down>"] = cmp.mapping.scroll_docs(1),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i" }),
    -- ["<C-Space>"] = {
    --   i = cmp.mapping.confirm({
    --     behavior = cmp.ConfirmBehavior.Insert,
    --     select = true,
    --   }),
    -- },
    -- ["<C-e>"] = cmp.mapping.close(),
    -- ["<CR>"] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Insert,
    --   select = false,
    -- }),
  }
  local cmdline = {}

  return { insert = insert, cmdline = cmdline }
  -- return {
  --   ["<C-n>"] = {
  --     cmp.mapping(cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }), { "i", "c" }),
  --   },
  --   ["<C-p>"] = {
  --     cmp.mapping(cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }), { "i", "c" }),
  --   },

  -- ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
  -- ["<C-p>"] = cmp.mapping(cmp.mapipng.select_prev_item(), { "i", "c" }),
  -- ["<S-Tab>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.select_prev_item()
  --   elseif luasnip.jumpable(-1) then
  --     luasnip.jump(-1)
  --   else
  --     fallback()
  --   end
  -- end, { "i", "s", "c" }),
  -- ["<Tab>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.select_next_item()
  --   elseif luasnip.expand_or_jumpable() then
  --     luasnip.expand_or_jump()
  --   elseif has_words_before() then
  --     cmp.complete()
  --   else
  --     fallback()
  --   end
  -- end, { "i", "s", "c" }),
  -- ["<C-f>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     for _ = 1, 5 do
  --       cmp.select_next_item({
  --         behavior = require("cmp.types").cmp.SelectBehavior.Select,
  --       })(nil)
  --     end
  --   end
  -- end, { "c", "i", "s" }),
  -- ["<C-b>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     for _ = 1, 5 do
  --       cmp.select_prev_item({
  --         behavior = require("cmp.types").cmp.SelectBehavior.Select,
  --       })(nil)
  --     end
  --   end
  -- end, { "c", "i", "s" }),
  -- ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "c", "i", "s" }),
  -- ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "c", "i", "s" }),
  -- ["<C-E>"] = cmp.mapping(function(_)
  --   if cmp.visible() then
  --     cmp.abort()
  --   end
  --   cmp.complete()
  -- end, { "i", "c" }),
  -- ["<C-D>"] = cmp.mapping(cmp.abort(), { "c", "i", "s" }),
  -- ["<Esc>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.abort()
  --   else
  --     fallback()
  --   end
  -- end, { "c", "i" }),
  -- ["<C-Space>"] = cmp.mapping(
  --   cmp.mapping.confirm({
  --     behavior = cmp.ConfirmBehavior.Insert,
  --     select = true,
  --   }),
  --   { "c", "i", "s" }

  -- ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }),
  -- ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }),
  -- ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Insert }),
  -- ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Insert }),
end

return cmp_mappings
