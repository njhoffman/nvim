-- merge: https://github.com/hrsh7th/cmp-cmdline/pull/25
-- https://github.com/hrsh7th/cmp-cmdline/pull/99
-- https://github.com/hrsh7th/cmp-cmdline/pull/76
-- https://github.com/hrsh7th/cmp-cmdline/pull/83

local cmp = require('cmp')
local MAX_DOCUMENT_WIDTH = 40
-- local WIN_HIGHLIGHT = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"
local WIN_HIGHLIGHT = 'Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None'

local sources = require('configs.nvim-cmp.sources')
local mapping = require('configs.nvim-cmp.keymaps')
local formatting = require('configs.nvim-cmp.formatting')
local sorting = require('configs.nvim-cmp.sorting')

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
  return is_not_comment() and is_not_buftype() and is_not_filetype() and is_not_luasnip()
end

-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- 	local is_enabled = require("util.cmp").is_enabled
-- 	local cmp_tailwind = require("tailwindcss-colorizer-cmp")
-- 	local cmp_ai = require("cmp_ai.config")

cmp.setup({
  -- enabled = function ()
  --     buftype = vim.api.nvim_buf_get_option(0, "buftype")
  --     if buftype == "prompt" then return false end
  --     return true
  -- end,
  completion = {
    completeopt = 'menu,menuone,noselect',
    -- completeopt = 'menuone,noselect,noinsert',
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sorting = sorting,
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
    --   native_menu = true,
  },
  formatting = formatting,
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
  -- confirm_opts = {
  --   behavior = cmp.ConfirmBehavior.Replace,
  --   select = false,
  -- },
})

cmp.setup.filetype('gitcommit', { sources = cmp.config.sources(sources.gitcommit) })

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
  sources = cmp.config.sources(sources.cmdsearch),
  -- sorting = { comparators = {} },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(mapping.cmdline),
  sources = cmp.config.sources(sources.cmdline[1], sources.cmdline[2]),
})
