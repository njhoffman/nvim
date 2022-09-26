local defaultSettings = {
  enabled = function()
    local disabled = false
    disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
    disabled = disabled or (vim.fn.reg_recording() ~= "")
    disabled = disabled or (vim.fn.reg_executing() ~= "")
    return not disabled
  end,

  preselect = types.cmp.PreselectMode.Item,

  mapping = {},

  snippet = {
    expand = function()
      error("snippet engine is not configured.")
    end,
  },

  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
    completeopt = "menu,menuone,noselect",
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },

  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(_, vim_item)
      return vim_item
    end,
  },

  matching = {
    disallow_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },

  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },

  sources = {},

  confirmation = {
    default_behavior = types.cmp.ConfirmBehavior.Insert,
    get_commit_characters = function(commit_characters)
      return commit_characters
    end,
  },

  event = {},

  experimental = {
    ghost_text = false,
  },

  view = {
    entries = { name = "custom", selection_order = "top_down" },
  },

  window = {
    completion = {
      border = { "", "", "", "", "", "", "", "" },
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
      border = { "", "", "", " ", "", "", "", " " },
      winhighlight = "FloatBorder:NormalFloat",
    },
  },
}

-- cmp.setup.filetype({ 'markdown', 'help' }, {
--   sources = {
--     { name = 'path' },
--     { name = 'buffer' },
--   }
-- })

-- mapping = {
--   ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--   ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--   ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
--   ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
--   ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--   ['<C-f>'] = cmp.mapping.scroll_docs(4),
--   ['<C-Space>'] = cmp.mapping.complete(),
--   ['<C-e>'] = cmp.mapping.close(),
--   ['<CR>'] = cmp.mapping.confirm({
--     behavior = cmp.ConfirmBehavior.Replace,
--     select = true,
--   })
-- },

--     cmp.setup.cmdline("/", {
--       mapping = cmp.mapping.preset.cmdline(),
--       sources = {
--         { name = "buffer" },
--       },
--     })

-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })

mapping.preset.insert = function(override)
  return merge_keymaps(override or {}, {
    ["<Down>"] = {
      i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
    },
    ["<Up>"] = {
      i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
    },
    ["<C-n>"] = {
      i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ["<C-p>"] = {
      i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ["<C-y>"] = {
      i = mapping.confirm({ select = false }),
    },
    ["<C-e>"] = {
      i = mapping.abort(),
    },
  })
end

---Mapping preset cmdline-mode configuration.
mapping.preset.cmdline = function(override)
  return merge_keymaps(override or {}, {
    ["<Tab>"] = {
      c = function()
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_next_item()
        else
          feedkeys.call(keymap.t("<C-z>"), "n")
        end
      end,
    },
    ["<S-Tab>"] = {
      c = function()
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_prev_item()
        else
          feedkeys.call(keymap.t("<C-z>"), "n")
        end
      end,
    },
    ["<C-n>"] = {
      c = function(fallback)
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
    ["<C-p>"] = {
      c = function(fallback)
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    ["<C-e>"] = {
      c = mapping.close(),
    },
  })
end

-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {{{name = "buffer"}}})
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})})

-- vim.cmd([[autocmd FileType sql,mysql,pgsql,psql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }, { name = "nvim_lsp" "}} })]])
-- vim.cmd([[let g:completion_chain_complete_list = { 'sql': [  {'complete_items': ['vim-dadbod-completion']}, ], }]])
-- " Source is automatically added, you just need to include it in the chain complete list
-- let g:completion_chain_complete_list = {  'sql': [{'complete_items': ['vim-dadbod-completion']} ] }
-- " Make sure `substring` is part of this list. Other items are optional for this completion source
-- let g:completion_matching_strategy_list = ['exact', 'substring']
-- " Useful if there's a lot of camel case items
-- let g:completion_matching_ignore_case = 1

-- custom behavior: only show if something behind cursor and nothing inf ront
-- autocmd TextChangedI,TextChangedP * call s:on_complete_check()

-- function! s:on_complete_check() abort
-- lua <<EOF
--  local line = vim.api.nvim_get_current_line()
--  local cursor = vim.api.nvim_win_get_cursor(0)[2]

--  local current = string.sub(line, cursor, cursor + 1)
--  if current == "." or current == "," or current == " " then
--     require('cmp').close()
--  end

--  local before_line = string.sub(line, 1, cursor + 1)
--  local after_line = string.sub(line, cursor + 1, -1)
--  if not string.match(before_line, '^%s+$') then
--     if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--         require('cmp').complete()
--     end
--  end
-- EOF
-- endfunction
