local cmp = require('cmp')
local cmp_types = require('cmp.types.cmp')
local MIN_LABEL_WIDTH = 20
local ELLIPSIS_CHAR = '…'
local MAX_DOCUMENT_WIDTH = 50
local MAX_LABEL_WIDTH = 40
local SYMBOL_MAP = require('utils.lspkind').SYMBOL_MAP
-- local WIN_HIGHLIGHT = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"
local WIN_HIGHLIGHT = 'Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None'

local function get_lsp_completion_context(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end
  if source_name == 'tsserver' then
    return completion.detail
  elseif source_name == 'pyright' then
    if completion.labelDetails ~= nil then
      return completion.labelDetails.description
    end
  end
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local sources = {
  main = {
    {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'emoji' },
    },
    {
      { name = 'treesitter' },
      { name = 'path' },
      -- Distracting!
      -- { name = "spell" },
      -- { name = "dictionary" },
    },
  },
  gitcommit = {
    { name = 'cmp_git' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },

    { name = 'nvim_lsp_document_symbol' },
    { name = 'buffer' },
    { name = 'dictionary' },
    { name = 'spell' },
    { name = 'path' },
  },
  cmdsearch = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'dictionary' },
    { name = 'buffer' },
  },
  cmdline = {
    -- { name = "cmdline_history" },
    { name = 'cmdline' },
    { name = 'path', options = { trailing_slash = false, label_trailing_slash = false } },
    -- { name = "dictionary" },
    -- { name = "buffer" },
  },
}
local mapping = {
  main = {
    ['<Up>'] = cmp.mapping.scroll_docs(-1),
    ['<Down>'] = cmp.mapping.scroll_docs(1),
    ['<C-Up>'] = cmp.mapping.scroll_docs(-6),
    ['<C-Down>'] = cmp.mapping.scroll_docs(6),
    ['<M-b>'] = cmp.mapping.scroll_docs(-6),
    ['<M-f>'] = cmp.mapping.scroll_docs(6),
    ['<C-f>'] = cmp.mapping.select_next_item({ count = 6 }),
    ['<C-b>'] = cmp.mapping.select_prev_item({ count = 6 }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- special: trigger snippets without typing the full trigger
    ['<A-;>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
        cmp.mapping.confirm({ select = false })()
      end
    end, { 'i', 's' }),
    -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  },
  cmdline = {
    ['<C-f>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      else
        fallback()
      end
    end, { 'c' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp_types.SelectBehavior.Select,
          })(nil)
        end
      else
        fallback()
      end
    end, { 'c' }),
  },
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
    --   native_menu = true,
  },
  formatting = {
    -- format = require('tailwindcss-colorizer-cmp').formatter,
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      local item_with_kind = require('lspkind').cmp_format({
        mode = 'symbol_text',
        maxwidth = MAX_LABEL_WIDTH,
        symbol_map = SYMBOL_MAP,
      })(entry, vim_item)

      local kind_s_menu = vim.split(item_with_kind.kind, '%s', { trimempty = true })
      item_with_kind.kind = ' ' .. (kind_s_menu[1] or '') .. ' '
      item_with_kind.menu = '    (' .. (kind_s_menu[2] or '') .. ')'
      item_with_kind.menu = vim.trim(item_with_kind.menu)

      local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
      if completion_context ~= nil and completion_context ~= '' then
        item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
      end
      return item_with_kind
    end,
  },
  window = {
    max_width = MAX_DOCUMENT_WIDTH,
    col_offset = -3,
    side_padding = 0,
    completion = cmp.config.window.bordered({ winhighlight = WIN_HIGHLIGHT }),
    documentation = cmp.config.window.bordered({ winhighlight = WIN_HIGHLIGHT }),
    preview = cmp.config.window.bordered({ winhighlight = WIN_HIGHLIGHT }),
  },
  mapping = cmp.mapping.preset.insert(mapping.main),
  sources = cmp.config.sources(sources.main[1], sources.main[2]),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
})

cmp.setup.filetype('gitcommit', { sources = cmp.config.sources(sources.gitcommit) })

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
  sources = sources.cmdsearch,
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
  sources = cmp.config.sources(sources.cmdline),
})

-- -- LuaSnip Settings
-- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
--
-- luasnip.config.set_config({
--   history = true,
--   updateevents = "TextChanged, TextChangedI",
--   enable_autosnippets = true,
-- })
--
-- -- Keymaps
-- vim.keymap.set({ "i", "s" }, "<a-p>", function()
--   if luasnip.expand_or_jumpable() then
--     luasnip.expand()
--   end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<a-k>", function()
--   if luasnip.jumpable(1) then
--     luasnip.jump(1)
--   end
-- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<a-j>", function()
--   if luasnip.jumpable(-1) then
--     luasnip.jump(-1)
--   end
-- end, { silent = true })
--
-- -- special function
-- vim.keymap.set({ "i", "s" }, "<a-l>", function()
--   if luasnip.choice_active() then
--     luasnip.change_choice(1)
--   end
-- end)
--
-- vim.keymap.set({ "i", "s" }, "<a-h>", function()
--   if luasnip.choice_active() then
--     luasnip.change_choice(-1)
--   end
-- end)
--
-- vim.keymap.set("i", "<A-CR>", function()
--   if LAST_TRIGGERED_SNIPPET then
--     vim.api.nvim_input("<A-o>")
--     vim.schedule(function()
--       luasnip.expand_repeat()
--     end)
--   end
-- end, {})
-- vim.keymap.set("i", "<A-S-CR>", function()
--   if LAST_TRIGGERED_SNIPPET then
--     vim.api.nvim_input("<A-S-O>")
--     vim.schedule(function()
--       luasnip.expand_repeat()
--     end)
--   end
-- end, {})

-- ===================
-- QoL and consistency
-- ===================

-- Navigate tab completion w/ <C-j> and <C-k>

--- Map `key` to `mapped_to` if the nvim-native popup - menu is visible.
---
--- @param mode string  Mode shortstring
--- @param lhs  string  LHS
--- @param rhs  string  RHS
--- @param fb   string|nil  Fallback key triggered on popup absence.
---                         If `nil`, `lhs` is triggered instead.
---
--- @see https://vim.fandom.com/wiki/Improve_completion_popup_menu
local function map_if_pumvisible_else(mode, lhs, rhs, fb)
  vim.keymap.set(mode, lhs, function()
    return vim.fn.pumvisible() == 1 and rhs or fb or lhs
  end, { expr = true, noremap = true })
end

local function map_if_pumvisible(mode, lhs, rhs)
  map_if_pumvisible_else(mode, lhs, rhs, nil)
end

-- Better command-completion mappings
-- map_if_pumvisible_else("c", "<C-p>", "<Up>")
-- map_if_pumvisible_else("c", "<C-n>", "<Down>")
-- map_if_pumvisible_else("c", "<C-[>", "<C-u>")
-- map_if_pumvisible("c", "<C-[>", "<C-u>")
-- map_if_pumvisible("c", "<Esc>", "<C-e>")
-- map_if_pumvisible("c", "<CR>", "<C-y>")
