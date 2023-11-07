-- merge: https://github.com/hrsh7th/cmp-cmdline/pull/25
-- https://github.com/hrsh7th/cmp-cmdline/pull/99
-- https://github.com/hrsh7th/cmp-cmdline/pull/76
-- https://github.com/hrsh7th/cmp-cmdline/pull/83

local cmp = require('cmp')

local debug_flag = false
local MAX_DOCUMENT_WIDTH = 40
-- local WIN_HIGHLIGHT = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"
local WIN_HIGHLIGHT = 'Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None'

local sources = require('configs.nvim-cmp.sources')
local mapping = require('configs.nvim-cmp.keymaps')
local formatting = require('configs.nvim-cmp.formatting')
local sorting = require('configs.nvim-cmp.sorting')

require('configs.nvim-cmp.icons').setup_highlights()

local is_not_comment = function()
  local context = require('cmp.config.context')
  return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
end

local is_not_buftype = function()
  local prompt = vim.bo.buftype == 'prompt'
  return not prompt
end

local is_not_filetype = function()
  local ft = vim.bo.filetype
  local exclude_ft = {
    'neorepl',
    'neoai-input',
  }
  for _, v in pairs(exclude_ft) do
    if ft == v then
      return false
    end
  end
  return true
end

local is_not_luasnip = function()
  ---@diagnostic disable-next-line: param-type-mismatch
  return not vim.fn.expand('%:p'):find('.*/nvim/lua/snippets/.*%.lua')
end

M.is_enabled = function()
  local disabled = {
    IncRename = true,
  }
  -- Get first word of cmdline
  local cmd = vim.fn.getcmdline():match('%S+')
  -- Return true if cmd isn't disabled else call/return cmp.close(), which returns false
  return is_not_comment() and is_not_buftype() and is_not_filetype() and is_not_luasnip() and not disabled[cmd]
    or cmp.close()
end

-- 	local is_enabled = require("util.cmp").is_enabled
-- 	local cmp_tailwind = require("tailwindcss-colorizer-cmp")
-- 	local cmp_ai = require("cmp_ai.config")
-- If you want insert `(` after select function or method item
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local cfg = {
  autocomplete = {
    cmp.TriggerEvent.InsertEnter,
    cmp.TriggerEvent.TextChanged,
  },
  enabled = function()
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    if buftype == 'prompt' then
      return false
    end
    return true
  end,
  performance = {
    debounce = 100,
    throttle = 30,
    -- debounce = 60,
    -- throttle = 30,
    -- fetching_timeout = 500,
    -- confirm_resolve_timeout = 80,
    -- async_budget = 1,
    -- max_view_entries = 200,
  },
  matching = {
    -- disallow_fuzzy_matching = false,
    -- disallow_fullfuzzy_matching = false,
    -- disallow_partial_fuzzy_matching = true,
    -- disallow_partial_matching = false,
    -- disallow_prefix_unmatching = false,
  },
  completion = {
    -- completeopt = 'menu,preview,menuone,noselect',
    completeopt = 'menu,menuone,noselect',
    -- completeopt = 'menuone,noselect,noinsert',
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sorting = sorting,
  -- experimental = {
  --   ghost_text = {
  --     hl_group = 'CmpGhostText',
  --   },
  -- },
  formatting = formatting,
  window = {
    max_width = MAX_DOCUMENT_WIDTH,
    col_offset = -3,
    side_padding = 0,
    completion = cmp.config.window.bordered({ winhighlight = WIN_HIGHLIGHT, scrollbar = true }),
    documentation = cmp.config.window.bordered({ winhighlight = WIN_HIGHLIGHT, scrollbar = true }),
  },
  mapping = cmp.mapping.preset.insert(mapping.main),
  sources = cmp.config.sources(sources.main[1], sources.main[2]),
  view = {
    entries = {
      -- name = 'custom',
      selection_order = 'near_cursor',
      vertical_positioning = 'above', -- above, below, auto
    },
    docs = {
      auto_open = true,
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  -- confirmation = {
  --   default_behavior = types.cmp.ConfirmBehavior.Insert,
  --      get_commit_characters = function(commit_characters)
  --        return commit_characters
  --      end,
  -- }
}

local setup_cmp = function()
  local debug = require('cmp.utils.debug')
  local log = function(...)
    if debug_flag then
      local data = {}
      for _, v in ipairs({ ... }) do
        if not vim.tbl_contains({ 'string', 'number', 'boolean' }, type(v)) then
          v = vim.inspect(v)
        end
        table.insert(data, v)
      end
      vim.dbglog(table.concat(data, '\t'))
    end
  end
  vim.tbl_deep_extend('force', debug, { log = log })

  cmp.setup(cfg)
  cmp.setup.filetype('gitcommit', { sources = cmp.config.sources(sources.gitcommit) })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
    sources = cmp.config.sources(sources.cmdsearch),
    matching = { disallow_symbol_nonprefix_matching = false },
    -- sorting = { comparators = {} },
  })
  --
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
    sources = cmp.config.sources(sources.cmdline[1], sources.cmdline[2]),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

setup_cmp()

-- only appear if characters before cursor
-- api.nvim_create_autocmd(
--   {"TextChangedI", "TextChangedP"},
--   {
--     callback = function()
--       local line = vim.api.nvim_get_current_line()
--       local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--       local current = string.sub(line, cursor, cursor + 1)
--       if current == "." or current == "," or current == " " then
--         require('cmp').close()
--       end
--
--       local before_line = string.sub(line, 1, cursor + 1)
--       local after_line = string.sub(line, cursor + 1, -1)
--       if not string.match(before_line, '^%s+$') then
--         if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--           require('cmp').complete()
--         end
--       end
--   end,
--   pattern = "*"
-- })
