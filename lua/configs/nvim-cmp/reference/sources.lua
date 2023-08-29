local sources = {
  -- nvim_lua, vim-dadbod-completion, cmp_tabnine
  { name = 'nvim_lsp_signature_help', priority = 100 },
  { name = 'nvim_lsp', priority = 100, group_index = 1 },
  { name = 'fuzzy_path', priority = 10, group_index = 1, max_item_count = 5 },
  -- { name = "path", priority = 10, group_index = 1, max_item_count = 5 },
  -- { name = "fuzzy_buffer", priority = 1, group_index = 2, max_item_count = 3 },
  { name = 'calc', priority = 3 },
  { name = 'spell', priority = 3 },
  { name = 'git', priority = 3 },
  { name = 'pandoc_references', priority = 3 },
  { name = 'emoji', priority = 2 },
  { name = 'vimwiki-tags', priority = 1 },
  { name = 'omni', priority = 1 },
  {
    name = 'luasnip',
    priority = 1,
    group_index = 1,
    option = { use_show_condition = true },
    entry_filter = function()
      local context = require('cmp.config.context')
      return not context.in_treesitter_capture('string') and not context.in_syntax_group('String')
    end,
  },
  { name = 'npm', keyword_length = 1 },
  { name = 'copilot', group_index = 2 },
  -- {
  --   name = "tmux",
  --   max_item_count = 5,
  --   keyword_length = 5,
  --   priority = 1,
  --   option = {
  --     all_panes = false,
  --     label = "tmux",
  --     -- trigger_characters = { "." },
  --     -- trigger_characters_ft = {markdown = {}}
  --   },
  -- },
}

return {
  definitions = sources,
  names = source_names,
  symbols = lsp_symbols,
}
