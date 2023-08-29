local cmp = require('cmp')

-- local cmp_mappings = require("configs.nvim-cmp-mapping")
local compare = require('cmp.config.compare')
local sources = require('configs.nvim-cmp.sources')
local mappings = require('configs.nvim-cmp.mappings')
local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 40
local MIN_LABEL_WIDTH = 20

local sort_under = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find('^_+')
  local _, entry2_under = entry2.completion_item.label:find('^_+')
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }
vim.opt.dictionary:append('/usr/share/dict/words')

local cmp_helper = {
  -- Deprioritize items starting with underscores (private or protected)
  deprioritize_underscore = function(lhs, rhs)
    local l = (lhs.completion_item.label:find('^_+')) and 1 or 0
    local r = (rhs.completion_item.label:find('^_+')) and 1 or 0
    if l ~= r then
      return l < r
    end
  end,
  -- Prioritize items that ends with "= ..." (usually for argument completion).
  prioritize_argument = function(lhs, rhs)
    local l = (lhs.completion_item.label:find('=$')) and 1 or 0
    local r = (rhs.completion_item.label:find('=$')) and 1 or 0
    if l ~= r then
      return l > r
    end
  end,
}

local setupConfig = {
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
  },
  -- preselect = cmp.types.cmp.PreselectMode.Item, -- cmp.PreselectMode.None/Item,
  completion = {
    -- completeopt = "noinsert,noselect",
    completeopt = 'menu,menuone,noinsert',
    -- get_trigger_characters = function(trigger_characters)
    --   local new_trigger_characters = {}
    --   for _, char in ipairs(trigger_characters) do
    --     if char ~= ">" then
    --       table.insert(new_trigger_characters, char)
    --     end
    --   end
    --   return new_trigger_characters
    -- end,
    -- keyword_length = 1,
    -- autocomplete = {
    --   cmp.TriggerEvent.TextChanged,
    -- },
  },

  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
    if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require('cmp.config.context')
    local in_parameter = context.in_treesitter_capture('punctuation.bracket') == true
      or context.in_syntax_group('luaParen')
    local in_comment = context.in_treesitter_capture('comment') == true or context.in_syntax_group('Comment')
    return not (in_comment or in_parameter)
  end,
  mapping = mappings.main,
  view = {
    entries = {
      name = 'custom', -- can be "custom", "wildmenu" or "native"
      selection_order = 'top_down', -- near_cursor, top_down
    },
  },
  window = {
    completion = cmp.config.window.bordered({
      --   border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
      --   winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
      winhighlight = 'Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None',
      -- max_width = 40,
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = 'Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None',
      -- max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      -- max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }),
  },
  formatting = {
    fields = {
      'menu',
      'abbr',
      'kind',
    },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end
      vim_item.dup = ({ nvim_lua = 0 })[entry.source.name] or 1
      vim_item.menu = sources.names[entry.source.name] .. ' '
      vim_item.kind = ' ' .. sources.symbols[vim_item.kind]
      return vim_item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      require('cmp_fuzzy_path.compare'),
      require('cmp_fuzzy_buffer.compare'),
      sort_under,
      function(...)
        return cmp_helper.prioritize_argument(...)
      end,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  sources = cmp.config.sources(sources.definitions),
}

cmp.setup(setupConfig)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  -- sources = cmp.config.sources({
  --   {
  --     name = "fuzzy_path",
  --     group_index = 2,
  --   },
  --   {
  --     name = "fuzzy_buffer",
  --     group_index = 2,
  --   },
  -- }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {
      name = 'cmdline',
      priority = 50,
    },
    {
      name = 'fuzzy_path',
      priority = 30,
    },
  }),
})

require('cmp').setup.filetype('DressingInput', {
  sources = cmp.config.sources({ { name = 'omni' } }),
})

-- cmp.setup.filetype({ "markdown", "help" }, {
--   window = {
--     documentation = cmp.config.disable,
--   },
-- })
--

-- for _, cmd_type in ipairs({':', '/', '?', '@'}) do
--   cmp.setup.cmdline(cmd_type, {
--     sources = {
--       { name = 'cmdline_history' },
--     },
--   })
-- end
-- vim.cmd([[
--   augroup NvimCmp
--   au!
--   au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
--   augroup END
-- ]])

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

-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
--
-- 	-- require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
-- 	-- 	sources = {
-- 	-- 		{ name = "dap" },
-- 	-- 	},
-- 	-- })
--
-- 	cmp_ai:setup({
-- 		max_lines = 1000,
-- 		provider = "OpenAI",
-- 		model = "gpt-3.5-turbo",
-- 		notify = true,
-- 		notify_callback = function(msg)
-- 			require("notify").notify(msg, vim.log.levels.INFO, {
-- 				title = "OpenAI",
-- 			})
-- 		end,
-- 		run_on_every_keystroke = true,
-- 		ignored_file_types = {},
-- 	})
-- end

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
