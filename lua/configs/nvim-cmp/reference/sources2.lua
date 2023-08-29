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
    },
    {
      {
        name = 'copilot',
        max_item_count = 3,
        trigger_characters = {
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
    { name = 'path', options = { trailing_slash = false, label_trailing_slash = false } },
    {
      name = 'cmdline',
      option = { ignore_cmds = { 'Man', '!' } },
    },
    { name = 'cmdline_history', max_item_count = 5, keyword_length = 3 },
  },
