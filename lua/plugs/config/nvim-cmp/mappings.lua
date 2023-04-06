local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_types = require("cmp.types.cmp")
local keymap = require("cmp.utils.keymap")
local feedkeys = require("cmp.utils.feedkeys")
local sb_select = cmp.SelectBehavior.Select
local sb_insert = cmp.SelectBehavior.Insert

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local main = {
  ["<C-x><C-o>"] = cmp.mapping.complete({}),
  ["<C-x><C-s>"] = cmp.mapping.complete({ config = { sources = { { name = "luasnip" } } } }),
  ["<C-f>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      for _ = 1, 5 do
        cmp.mapping.select_next_item({
          behavior = cmp_types.SelectBehavior.Select,
        })(nil)
      end
    else
      fallback()
    end
  end, { "i" }),
  ["<C-B>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      for _ = 1, 5 do
        cmp.mapping.select_prev_item({
          behavior = cmp_types.SelectBehavior.Select,
        })(nil)
      end
    else
      fallback()
    end
  end, { "i" }),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item({ behavior = cmp_types.SelectBehavior.Select })
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "c" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      -- cmp.select_prev_item()
      cmp.select_prev_item({ behavior = cmp_types.SelectBehavior.Select })
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i" }),
  ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }), { "i", "c" }),
  ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }), { "i", "c" }),
  ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i" }),
  ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i" }),
  ["<C-D>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
  -- if cmp.core.view:visible() then
  --   local release = cmp.core:suspend()
  --   cmp.core.view:select_prev_item(option)
  --   vim.schedule(release)
  --   return true
  -- elseif vim.fn.pumvisible() == 1 then
  --   if option.behavior == cmp.SelectBehavior.Insert then
  --     feedkeys.call(keymap.t(string.rep('<C-p>', option.count)), 'in')
  --   else
  --     feedkeys.call(keymap.t(string.rep('<Up>', option.count)), 'in')
  --   end
  --   return true
}

local main_alt = {
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
  end, { "i", "s" }),

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
  end, { "i", "s" }),

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
  ["<C-f>"] = cmp.mapping(function()
    if cmp.visible() then
      for _ = 1, 5 do
        cmp.mapping.select_next_item({
          behavior = sb_select,
        })(nil)
      end
    end
  end, { "c", "i", "s" }),
  ["<C-B>"] = cmp.mapping(function()
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
  ["<C-Space>"] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Insert,
    select = true,
  }),
  -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
  ["<C-e>"] = cmp.mapping(function()
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

local in_history = false
local cmdline = {
  mapping = {
    ["<C-z>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end, { "c" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "c" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "c" }),
    ["<C-D>"] = cmp.mapping(cmp.mapping.abort(), { "c" }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        in_history = false
      elseif in_history == true then
        feedkeys.call(keymap.t("<Down>"), "c")
      else
        fallback()
        -- cmp.mapping(cmp.complete())
        -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
      end
    end, { "c" }),
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.select_prev_item({
          -- behavior = cmp.SelectBehavior.Insert,
        })
        in_history = false
      else
        -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
        feedkeys.call(keymap.t("<Up>"), "c")
        in_history = true
      end
    end, { "c" }),
    ["<C-f>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      else
        fallback()
      end
    end, { "c" }),
    ["<C-b>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      else
        fallback()
      end
    end, { "c" }),
    ["<Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end, { "c" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end, { "c" }),
    -- ['<C-n>'] = {
    --   c = function(fallback)
    --     local cmp = require('cmp')
    --     if cmp.visible() then
    --       cmp.select_next_item()
    --     else
    --       fallback()
    --     end
    --   end,
    -- },
    -- ['<C-p>'] = {
    --   c = function(fallback)
    --     local cmp = require('cmp')
    --     if cmp.visible() then
    --       cmp.select_prev_item()
    --     else
    --       fallback()
    --     end
    --   end,
    -- },
  },
}

return {
  main = main,
  main_alt = main_alt,
  cmdline = cmdline,
}
