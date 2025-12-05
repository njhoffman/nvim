-- if vim.o.ft == 'sql' then
--   table.insert(sources, { name = 'vim-dadbod-completion' })
-- end
--
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

local sources = {
  filetypes = {
    per_filetype = {
      codecompanion = { "codecompanion" },
    },
  },
  main = {
    {
      {
        name = "lazydev",
        -- group_index = 0,
        entry_filter = function()
          if vim.bo.filetype ~= "lua" then
            return false
          end
          return true
        end,
      },
      {
        name = "nvim_lsp",
        -- max_item_count = 10,
        -- trigger_characters = { '-' },
        keyword_length = 0,
        entry_filter = function(entry, ctx)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return false
          end
          return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
        end,
      },
      {
        name = "codeium",
        max_item_count = 3,
      },
      {
        name = "copilot",
        max_item_count = 3,
        -- trigger_characters = {{
        --     ".",
        --     ":",
        --     "(",
        --     "'",
        --     '"',
        --     "[",
        --     ",",
        --     "#",
        --     "*",
        --     "@",
        --     "|",
        --     "=",
        --     "-",
        --     "{",
        --     "/",
        --     "\\",
        --     "+",
        --     "?",
        -- }},
      },
      { name = "nvim_lsp_document_symbol" },
      { name = "nvim_lsp_signature_help" },
      { name = "dap" },
      {
        name = "treesitter",
        max_item_count = 5,
        entry_filter = function(entry, vim_item)
          if entry.kind == 15 then
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local line = vim.api.nvim_get_current_line()
            local next_char = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
            if next_char == '"' or next_char == "'" then
              vim_item.abbr = vim_item.abbr:sub(1, -2)
            end
          end
          return vim_item
        end,
      },
      {
        name = "tags",
        option = {
          -- this is the default options, change them if you want.
          -- Delayed time after user input, in milliseconds.
          complete_defer = 100,
          -- Max items when searching `taglist`.
          max_items = 10,
          -- The number of characters that need to be typed to trigger
          -- auto-completion.
          keyword_length = 3,
          -- Use exact word match when searching `taglist`, for better searching
          -- performance.
          exact_match = false,
          -- Prioritize searching result for current buffer.
          current_buffer_only = false,
        },
      },
    },
    {
      { name = "fuzzy_path", option = { fd_timeout_msec = 1500 } },
      {
        name = "fuzzy_buffer",
        option = {
          -- get_bufnrs = function()
          --   return { vim.api.nvim_get_current_buf() }
          -- end
          get_bufnrs = function()
            local bufs = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
              if buftype ~= "nofile" and buftype ~= "prompt" then
                bufs[#bufs + 1] = buf
              end
            end
            return bufs
          end,
        },
      },
      {
        name = "rg",
        keyword_length = 5,
        max_item_count = 5,
        option = {
          additional_arguments = "--smart-case --hidden",
        },
        group_index = 3,
      },
      {
        -- TODO: make sure duplicates prioritize this over nvim_lsp
        name = "faker.quick_data",
        keyword_pattern = "@.*",
        -- keyword_pattern = [[@\k*.\?\k*.\?\k*.\?\k*]],
      },
      {
        name = "cmp_yanky",
        keyword_length = 3,
        option = {
          onlyCurrentFiletype = true, -- default: false
          minLength = 3,
        },
      },
      -- {
      --   name = "luasnip",
      --   keyword_length = 3,
      --   option = { use_show_condition = true },
      --   entry_filter = function()
      --     local context = require("cmp.config.context")
      --     return not context.in_treesitter_capture("string")
      --       and not context.in_syntax_group("String")
      --   end,
      --   -- source.entry_filter = function()
      --   --           local context = require("cmp.config.context")
      --   --           local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
      --   --           local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
      --   --
      --   --           --   Returning `true` will keep the entry, while returning `false` will remove it.
      --   --           return not string_ctx and not comment_ctx
      --   --         end
      -- },
      {
        name = "diag-codes",
        -- default completion available only in comment context
        keyword_length = 3,
        option = { in_comment = true },
      },
      { name = "nerdfont" },
      { name = "plugins" },
      {
        name = "emoji",
        entry_filter = function()
          if vim.bo.filetype ~= "gitcommit" then
            return false
          end
          return true
        end,
      },
      -- { name = "spell" },
      -- { name = "dictionary" },
      -- {
      --   name = 'crates',
      --   group_index = 2,
      -- },
    },
  },
  gitcommit = {
    { name = "cmp_git" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_document_symbol" },
    { name = "buffer" },
    { name = "dictionary" },
    { name = "spell" },
    { name = "path" },
  },
  cmdsearch = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_document_symbol" },
    { name = "fuzzy_path" },
    {
      name = "fuzzy_buffer",
      option = { max_matches = 5, max_buffer_lines = 4000, min_match_length = 4 },
    },
  },
  cmdline = {
    {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_document_symbol" },
      {
        name = "cmdline",
        option = { ignore_cmds = { "Man", "!" } },
      },
    },
    {
      { name = "fuzzy_path", option = { fd_timeout_msec = 1500 } },
      {
        name = "fuzzy_buffer",
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
              if buftype ~= "nofile" and buftype ~= "prompt" then
                bufs[#bufs + 1] = buf
              end
            end
            return bufs
          end,
        },
      },
      { name = "cmdline_history" },
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
