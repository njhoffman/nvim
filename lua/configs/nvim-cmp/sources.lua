local sources = {
  main = {
    {
      {
        name = 'nvim_lsp',
        -- max_item_count = 5,
        entry_filter = function(entry, ctx)
          local kind = require('cmp.types.lsp').CompletionItemKind[entry:get_kind()]
          if kind == 'Snippet' and ctx.prev_context.filetype == 'java' then
            return false
          end
          return true
        end,
      },
      { name = 'codeium', max_item_count = 3 },
      { name = 'nvim_lsp_document_symbol' },
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
      {
        name = 'cmp_yanky',
        option = {
          onlyCurrentFiletype = true, -- default: false
          minLength = 3,
        },
      }, -- {
      --    name = "omni",
      --    option = {
      --      disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
      --    },
      --  },
      {
        name = 'luasnip',
        group_index = 1,
        option = { use_show_condition = true },
        entry_filter = function()
          local context = require('cmp.config.context')
          return not context.in_treesitter_capture('string') and not context.in_syntax_group('String')
        end,
        -- source.entry_filter = function()
        --           local context = require("cmp.config.context")
        --           local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
        --           local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
        --
        --           --   Returning `true` will keep the entry, while returning `false` will remove it.
        --           return not string_ctx and not comment_ctx
        --         end
      },
      {
        name = 'diag-codes',
        -- default completion available only in comment context
        option = { in_comment = true },
      },
      { name = 'plugins' },
    },
    {
      {
        name = 'copilot',
        max_item_count = 5,
        -- vim.opt.scrollbuf = 999
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
      -- {
      --   name = 'nvim_lua',
      --   group_index = 2,
      -- },
      -- {
      --   name = 'crates',
      --   group_index = 2,
      -- },
      -- {
      --   name = 'treesitter',
      --   keyword_length = 3,
      --   group_index = 3,
      -- },
      -- {
      --   name = 'path',
      --   keyword_length = 3,
      --   group_index = 3,
      -- },
      -- {
      --   name = 'buffer',
      --   keyword_length = 3,
      --   group_index = 4,
      --   option = {
      --     get_bufnrs = function()
      --       local bufs = {}
      --       for _, win in ipairs(vim.api.nvim_list_wins()) do
      --         bufs[vim.api.nvim_win_get_buf(win)] = true
      --       end
      --       return vim.tbl_keys(bufs)
      --     end,
      --   },
      -- },
      -- {
      --   name = 'emoji',
      --   keyword_length = 2,
      --   group_index = 5,
      -- },
      -- {
      --   name = 'nerdfont',
      --   keyword_length = 2,
      --   group_index = 5,
      -- },
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
    -- { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'nvim_lsp_document_symbol' },
    -- { name = 'dictionary' },
    {
      name = 'fuzzy_buffer',
      option = { max_matches = 5, max_buffer_lines = 4000, min_match_length = 4 },
    },
  },
  cmdline = {
    {
      {
        name = 'cmdline',
        option = { ignore_cmds = { 'Man', '!' } },
      },
    },
    {
      { name = 'async_path' },
      { name = 'cmdline_history', max_item_count = 5 },
      -- { name = 'path', options = { trailing_slash = false, label_trailing_slash = false } },
      -- { name = "dictionary" },
      -- { name = "buffer" },
    },
  },
}
return sources
-- if vim.o.ft == 'sql' then
--   table.insert(sources, { name = 'vim-dadbod-completion' })
-- end
-- if vim.o.ft == 'norg' then
--   table.insert(sources, { name = 'neorg' })
--   table.insert(sources, { name = 'spell' })
--   table.insert(sources, { name = 'look' })
-- end
--
-- if vim.o.ft == 'org' then
--   table.insert(sources, { name = 'org' })
--   table.insert(sources, { name = 'spell' })
--   table.insert(sources, { name = 'look' })
-- end
-- if
--   vim.o.ft == 'markdown'
--   or vim.o.ft == 'txt'
--   or vim.o.ft == 'html'
--   or vim.o.ft == 'gitcommit'
-- then
--   table.insert(sources, { name = 'spell' })
--   table.insert(sources, { name = 'look' })
-- end
-- if vim.o.ft == 'lua' then
--   table.insert(sources, { name = 'nvim_lua' })
-- end
--
-- if vim.o.ft == 'zsh' or vim.o.ft == 'sh' or vim.o.ft == 'fish' or vim.o.ft == 'proto' then
--   table.insert(sources, { name = 'buffer', keyword_length = 3 })
--   table.insert(sources, { name = 'calc' })
-- end
