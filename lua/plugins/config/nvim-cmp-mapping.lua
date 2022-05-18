local ok, cmp = pcall(require, "cmp")
if not ok then return end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local mapping = {
  ["<C-x><C-o>"] = cmp.mapping.complete(),
  ["<C-x><C-s>"] = cmp.mapping.complete({ config = { sources = { { name = "vsnip" } } } }),
  ["<C-n>"] = function()
    if cmp.visible() then
      cmp.select_next_item()
    else
      -- fallback()
      cmp.mapping.complete()
    end
  end,
  ["<C-p>"] = function()
    if cmp.visible() then
      cmp.select_prev_item()
    else
      -- fallback()
      cmp.mapping.complete()
    end
  end,
  ["<PageUp>"] = cmp.mapping.scroll_docs(-4),
  ["<PageDown>"] = cmp.mapping.scroll_docs(4),
  ["<c-b>"] = function(fallback)
    for i = 1, 10 do
      cmp.mapping.select_prev_item()(nil)
    end
  end,
  ["<c-f>"] = function()
    for i = 1, 10 do
      cmp.mapping.select_next_item()(nil)
    end
  end,
  -- ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<Tab>"] = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-n>")
    elseif vim.fn.call("vsnip#available", { 1 }) == 1 then
      return t("<Plug>(vsnip-expand-or-jump)")
    elseif check_back_space() then
      return t("<Tab>")
    else
      return cmp.mapping.complete()
    end
  end,
  ["<S-Tab>"] = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-p>")
    elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
      return t("<Plug>(vsnip-jump-prev)")
    else
      -- If <S-Tab> is not working in your terminal, change it to <C-h>
      return t("<S-Tab>")
    end
  end
}

local insertOnlyMapping = {
  ["<C-x><C-o>"] = cmp.mapping.complete(),
  ["<C-x><C-s>"] = cmp.mapping.complete({ config = { sources = { { name = "vsnip" } } } }),
  ["<C-n>"] = {
    i = function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        -- fallback()
        cmp.mapping.complete()
      end
    end
    -- c = cmp.config.disable
  },
  ["<C-p>"] = {
    i = function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        -- fallback()
        cmp.mapping.complete()
      end
    end
    -- c = cmp.config.disable
  },
  ["<PageUp>"] = {
    i = cmp.mapping.scroll_docs(-4)
  },
  ["<PageDown>"] = {
    i = cmp.mapping.scroll_docs(4)
  },
  ["<c-b>"] = {
    i = function()
      for i = 1, 10 do
        cmp.mapping.select_prev_item()(nil)
      end
    end
  },
  ["<c-f>"] = {
    i = function()
      for i = 1, 10 do
        cmp.mapping.select_next_item()(nil)
      end
    end
  },
  -- ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = {
    i = cmp.mapping.abort()
  },
  ["<Tab>"] = {
    i = function()
      if vim.fn.pumvisible() == 1 then
        return t("<C-n>")
      elseif vim.fn.call("vsnip#available", { 1 }) == 1 then
        return t("<Plug>(vsnip-expand-or-jump)")
      elseif check_back_space() then
        return t("<Tab>")
      else
        return cmp.mapping.complete()
      end
    end
    -- c = cmp.config.disable
  },
  ["<S-Tab>"] = {
    i = function()
      if vim.fn.pumvisible() == 1 then
        return t("<C-p>")
      elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
        return t("<Plug>(vsnip-jump-prev)")
      else
        -- If <S-Tab> is not working in your terminal, change it to <C-h>
        return t("<S-Tab>")
      end
    end
    -- c = cmp.config.disable
  }
}

return mapping
