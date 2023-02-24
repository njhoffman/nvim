-- mapping.preset.cmdline = function(override)
--   return misc.merge(override or {}, {
-- end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function cmp_mappings()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local sb_select = cmp.SelectBehavior.Select
  local sb_insert = cmp.SelectBehavior.Insert

  return {
    ["<C-x><C-o>"] = cmp.mapping.complete(),
    ["<C-x><C-s>"] = cmp.mapping.complete({
      config = { sources = { { name = "luasnip" } } },
    }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = sb_insert })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "c" }),

    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = sb_insert })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = sb_select })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- cmp.select_prev_item()
        cmp.select_prev_item({ behavior = sb_select })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<C-f>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = sb_select,
          })(nil)
        end
      end
    end, { "c", "i", "s" }),
    ["<C-B>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = sb_select,
          })(nil)
        end
      end
    end, { "c", "i", "s" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "c", "i", "s" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "c", "i", "s" }),
    ["<C-D>"] = cmp.mapping(cmp.mapping.abort(), { "c", "i", "s" }),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    -- ESC: only C ->
    -- if cmp.visible() then
    --   cmp.close()
    -- else
    --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
    -- end
    ["<C-Space>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "c", "i", "s" }
    ),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-e>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.abort()
      end
      cmp.complete()
    end, { "i", "c" }),

    -- ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }),
    -- ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }),
    -- ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Insert }),
    -- ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Insert }),
  }
end

return cmp_mappings
