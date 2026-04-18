local cmp = require("cmp")
local mapping = require("cmp.config.mapping")

local pfx = " "

local scroll_docs = function(direction)
  return function(fallback)
    if cmp.visible() and cmp.visible_docs() then
      local winheight = math.abs(direction)
      for i = 1, winheight do
        vim.defer_fn(function()
          require("cmp").scroll_docs(direction < 0 and -1 or 1)
        end, i * 30)
      end
    else
      fallback()
    end
  end
end

local toggle_docs = function()
  if cmp.visible() and cmp.visible_docs() then
    cmp.close_docs()
  else
    cmp.open_docs()
  end
end

-- TODO: if no words after, C-P = S-Up, C-N = completion open

local main = {
  ["<C-x><C-o>"] = { i = mapping.complete({ desc = pfx .. "start completion source" }) },
  ["<C-x><C-f>"] = {
    i = mapping.complete({
      desc = pfx .. "start ai completions",
      config = { sources = { { name = "faker.quick_data" } } },
    }),
  },
  ["<C-g>"] = {
    i = mapping.complete({
      desc = pfx .. "start ai completion (github copilot and codeium)",
      config = {
        sources = {
          { name = "codeium", max_item_count = 10 },
          { name = "copilot", max_item_count = 10 },
        },
      },
    }),
  },

  -- stylua: ignore start
  ["<M-/>"]      = { i = toggle_docs },
  ["<M-C-_>"]    = { i = toggle_docs },
  ["<M-S-Down>"] = { i = mapping.scroll_docs(1) },
  ["<M-S-Up>"]   = { i = mapping.scroll_docs(-1) },
  ["<C-e>"]      = { i = mapping.close() },
  ["<M-b>"]      = { i = scroll_docs(-6) },
  ["<M-f>"]      = { i = scroll_docs(6) },
  ["<C-n>"] = {
    i = function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ["<C-p>"] = {
    i = function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ["<C-B>"] = {
    i = mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ["<C-F>"] = {
    i = mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },

  ["<C-Space>"] = {
    i = function()
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      else
        cmp.complete()
      end
    end,
  },

  ["<CR>"] = mapping({
    i = function(fallback)
      local confirm_opts = { behavior = cmp.ConfirmBehavior.Insert, select = false }
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        local is_copilot = entry and entry.source.name == 'copilot'
        if is_copilot then
          confirm_opts.behavior = cmp.ConfirmBehavior.Replace
          confirm_opts.select = false
        end
        if cmp.confirm(confirm_opts) then
          return
        end
      end
      fallback() -- if not exited early, always fallback
    end,
  }),
  ["<C-Y>"] = mapping({
    i = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }),
  ["<C-d>"] = {
    i = function(fallback)
      if not require("cmp").abort() then
        fallback()
      end
    end,
  },
  ["<C-t>"] = {
    i = function(fallback)
      if not require("cmp").abort() then
        fallback()
      end
    end,
  },
  ["<M-d>"] = {
    i = function()
      if cmp.visible() then
        cmp.abort()
      end
      vim.cmd("norm de")
    end,
  },
  ["<Tab>"] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),
}

return main
