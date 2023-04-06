local cmp = require("cmp")
local cmp_types = require("cmp.types.cmp")
local sources = require("plugs.config.nvim-cmp.sources")
local ELLIPSIS_CHAR = "…"
local MAX_LABEL_WIDTH = 40
local MIN_LABEL_WIDTH = 20

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      -- max_width = 40,
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      -- max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      -- max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }),
  },
  formatting = {
    fields = {
      "menu",
      "abbr",
      "kind",
    },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end
      vim_item.dup = ({ nvim_lua = 0 })[entry.source.name] or 1
      vim_item.menu = sources.names[entry.source.name] .. " "
      vim_item.kind = " " .. sources.symbols[vim_item.kind]
      return vim_item
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<Up>"] = cmp.mapping.scroll_docs(-1),
    ["<Down>"] = cmp.mapping.scroll_docs(1),
    ["<C-Up>"] = cmp.mapping.scroll_docs(-6),
    ["<C-Down>"] = cmp.mapping.scroll_docs(6),
    ["<M-b>"] = cmp.mapping.scroll_docs(-6),
    ["<M-f>"] = cmp.mapping.scroll_docs(6),
    ["<C-f>"] = cmp.mapping.select_next_item({ count = 6 }),
    ["<C-b>"] = cmp.mapping.select_prev_item({ count = 6 }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline({
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
  }),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
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
  }),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
