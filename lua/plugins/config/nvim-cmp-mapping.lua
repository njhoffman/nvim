local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- mapping.preset.cmdline = function(override)
--   return misc.merge(override or {}, {
-- end

local insert_override = {
  ["<C-x><C-o>"] = cmp.mapping.complete(),
  ["<C-x><C-s>"] = cmp.mapping.complete(
    {
      config = { sources = { { name = "luasnip" } } }
    }
  ),
  ["<C-F>"] = {
    i = function(fallback)
      if cmp.visible() then
        for _ = 1, 10 do
          cmp.mapping.select_next_item()(nil)
        end
      else
        fallback()
      end
    end
  },
  ["<C-B>"] = {
    i = function(fallback)
      if cmp.visible() then
        for _ = 1, 10 do
          cmp.mapping.select_prev_item()(nil)
        end
      else
        fallback()
      end
    end
  },
  ["<C-D>"] = {
    i = cmp.mapping.abort()
  },
  ["<C-Space>"] = { i = cmp.mapping.complete() },
  ["<CR>"] = { i = cmp.mapping.confirm({ select = false }) },
  ["<PageUp>"] = { i = cmp.mapping.scroll_docs(-2) },
  ["<PageDown>"] = { i = cmp.mapping.scroll_docs(2) },
  ["<Up>"] = { i = cmp.mapping.scroll_docs(-2) },
  ["<Down>"] = { i = cmp.mapping.scroll_docs(2) }
}

local cmdline_override = {
  -- TODO: reconcile C-F, C-P with history
  -- ["<C-F>"] = {
  --   c = function(fallback)
  --     cmp = require("cmp")
  --     if cmp.visible() then
  --       for _ = 1, 10 do
  --         cmp.mapping.select_next_item()(nil)
  --       end
  --     else
  --       fallback()
  --     end
  --   end
  -- },
  -- ["<C-B>"] = {
  --   c = function(fallback)
  --     cmp = require("cmp")
  --     if cmp.visible() then
  --       for _ = 1, 10 do
  --         cmp.mapping.select_prev_item()(nil)
  --       end
  --     else
  --       fallback()
  --     end
  --   end
  -- },
  ["<C-D>"] = {
    c = cmp.mapping.close()
  },
  -- ["<C-Space>"] = { c = cmp.mapping.complete() },
  -- ["<CR>"] = { c = cmp.mapping.confirm({ select = true }) },
  ["<PageUp>"] = { c = cmp.mapping.scroll_docs(-2) },
  ["<PageDown>"] = { c = cmp.mapping.scroll_docs(2) },
  ["<Up>"] = { c = cmp.mapping.scroll_docs(-2) },
  ["<Down>"] = { c = cmp.mapping.scroll_docs(2) }
}

local feedkeys = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return { insert_override = insert_override, cmdline_override = cmdline_override }
