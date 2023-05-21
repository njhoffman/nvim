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

-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
-- end
-- M.methods.has_words_before = has_words_before
--
-- ---@deprecated use M.methods.has_words_before instead
-- M.methods.check_backspace = function()
--   return not has_words_before()
-- end
--
-- local T = function(str)
--   return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
--
-- local function feedkeys(key, mode)
--   vim.api.nvim_feedkeys(T(key), mode, true)
-- end
--
-- M.methods.feedkeys = feedkeys
--
-- ---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
-- ---@param dir number 1 for forward, -1 for backward; defaults to 1
-- ---@return boolean true if a jumpable luasnip field is found while inside a snippet
-- local function jumpable(dir)
--   local luasnip_ok, luasnip = pcall(require, 'luasnip')
--   if not luasnip_ok then
--     return false
--   end
--
--   local win_get_cursor = vim.api.nvim_win_get_cursor
--   local get_current_buf = vim.api.nvim_get_current_buf
--
--   ---sets the current buffer's luasnip to the one nearest the cursor
--   ---@return boolean true if a node is found, false otherwise
--   local function seek_luasnip_cursor_node()
--     -- TODO(kylo252): upstream this
--     -- for outdated versions of luasnip
--     if not luasnip.session.current_nodes then
--       return false
--     end
--
--     local node = luasnip.session.current_nodes[get_current_buf()]
--     if not node then
--       return false
--     end
--
--     local snippet = node.parent.snippet
--     local exit_node = snippet.insert_nodes[0]
--
--     local pos = win_get_cursor(0)
--     pos[1] = pos[1] - 1
--
--     -- exit early if we're past the exit node
--     if exit_node then
--       local exit_pos_end = exit_node.mark:pos_end()
--       if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
--         snippet:remove_from_jumplist()
--         luasnip.session.current_nodes[get_current_buf()] = nil
--
--         return false
--       end
--     end
--
--     node = snippet.inner_first:jump_into(1, true)
--     while node ~= nil and node.next ~= nil and node ~= snippet do
--       local n_next = node.next
--       local next_pos = n_next and n_next.mark:pos_begin()
--       local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
--         or (pos[1] == next_pos[1] and pos[2] < next_pos[2])
--
--       -- Past unmarked exit node, exit early
--       if n_next == nil or n_next == snippet.next then
--         snippet:remove_from_jumplist()
--         luasnip.session.current_nodes[get_current_buf()] = nil
--
--         return false
--       end
--
--       if candidate then
--         luasnip.session.current_nodes[get_current_buf()] = node
--         return true
--       end
--
--       local ok
--       ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
--       if not ok then
--         snippet:remove_from_jumplist()
--         luasnip.session.current_nodes[get_current_buf()] = nil
--
--         return false
--       end
--     end
--
--     -- No candidate, but have an exit node
--     if exit_node then
--       -- to jump to the exit node, seek to snippet
--       luasnip.session.current_nodes[get_current_buf()] = snippet
--       return true
--     end
--
--     -- No exit node, exit from snippet
--     snippet:remove_from_jumplist()
--     luasnip.session.current_nodes[get_current_buf()] = nil
--     return false
--   end
--
--   if dir == -1 then
--     return luasnip.in_snippet() and luasnip.jumpable(-1)
--   else
--     return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
--   end
-- end
--
-- M.methods.jumpable = jumpable

local source = require('plugs.config.nvim-cmp.sources')
local sources = {
  main = {
    {
      {
        name = 'nvim_lsp',
        entry_filter = function(entry, ctx)
          local kind = require('cmp.types.lsp').CompletionItemKind[entry:get_kind()]
          if kind == 'Snippet' and ctx.prev_context.filetype == 'java' then
            return false
          end
          return true
        end,
      },
      { name = 'path' },
      {
        name = 'buffer',
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
    },
    {
      {
        name = 'copilot',
        max_item_count = 3,
        trigger_characters = {
          {
            '.',
            ':',
            '(',
            "'",
            '"',
            '[',
            ',',
            '#',
            '*',
            '@',
            '|',
            '=',
            '-',
            '{',
            '/',
            '\\',
            '+',
            '?',
            ' ',
            -- "\t",
            -- "\n",
          },
        },
      },
      { name = 'treesitter' },
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
    ['<S-CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }), -- Accept curr
    -- ['<tab>'] = function()
    --     return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
    --   end,
    --   expr = true,
    --   silent = true,
    --   mode = 'i',
    -- },
    -- ['<tab>'] = function()
    --     require('luasnip').jump(1)
    --   end,
    --   mode = 's',
    -- },
    -- ['<s-tab>'] =  function()
    --     require('luasnip').jump(-1)
    --   end,
    --   mode = { 'i', 's' },
    -- },
    -- special: trigger snippets without typing the full trigger
    ['<A-;>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
        cmp.mapping.confirm({ select = false })()
      end
    end, { 'i', 's' }),
    -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
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
    --  ["<C-Space>"] = cmp_mapping.complete(),
    --  ["<C-e>"] = cmp_mapping.abort(),
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

local types = require('cmp.types')

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require('copilot_cmp.comparators').prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(entry1, entry2)
        local kind1 = entry1:get_kind()
        kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
        local kind2 = entry2:get_kind()
        kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
          if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
          end
          local diff = kind1 - kind2
          if diff < 0 then
            return true
          elseif diff > 0 then
            return false
          end
        end
      end,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
    --   native_menu = true,
  },

  -- fields = {
  --   "menu",
  --   "abbr",
  --   "kind",
  -- },
  -- -- offset, exact, score, recently_used, locality, kind, sort_text, length, order

  -- format = function(entry, vim_item)
  --   local label = vim_item.abbr
  --   local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
  --   if truncated_label ~= label then
  --     vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
  --   elseif string.len(label) < MIN_LABEL_WIDTH then
  --     local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
  --     vim_item.abbr = label .. padding
  --   end
  --   vim_item.dup = ({ nvim_lua = 0 })[entry.source.name] or 1
  --   vim_item.menu = sources.names[entry.source.name] .. " "
  --   vim_item.kind = " " .. sources.symbols[vim_item.kind]
  --   return vim_item
  -- end,

  formatting = {
    -- format = require('tailwindcss-colorizer-cmp').formatter,
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, vim_item)
      local label = vim_item.abbr or ''
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end
      -- vim_item.menu = ({ nvim_lsp = '', buffer   = '', })[entry.source.name]
      -- vim_item.kind = ({ Text          = '', TypeParameter = '', })[vim_item.kind]
      -- vim_item.dup = ({ nvim_lua = 0 })[entry.source.name] or 1
      vim_item.dup = ({
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
      })[entry.source.name] or 0
      vim_item.menu = source.names[entry.source.name]
      vim_item.kind = source.symbols[vim_item.kind]
      return vim_item
    end,
    -- format = function(entry, vim_item)
    --   local item_with_kind = require('lspkind').cmp_format({
    --     mode = 'symbol_text',
    --     maxwidth = MAX_LABEL_WIDTH,
    --     symbol_map = SYMBOL_MAP,
    --   })(entry, vim_item)
    --
    --   local kind_s_menu = vim.split(item_with_kind.kind, '%s', { trimempty = true })
    --   item_with_kind.kind = ' ' .. (kind_s_menu[1] or '') .. ' '
    --   item_with_kind.menu = '    (' .. (kind_s_menu[2] or '') .. ')'
    --   item_with_kind.menu = vim.trim(item_with_kind.menu)
    --
    --   local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
    --   if completion_context ~= nil and completion_context ~= '' then
    --     item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
    --   end
    --   return item_with_kind
    -- end,
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
