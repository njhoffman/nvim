local ok, cmp = pcall(require, "cmp")

if not ok then
  return
end

local compare = require("cmp.config.compare")
local WIDE_HEIGHT = 25 -- 40

--  local after_line = string.sub(line, cursor + 1, -1)
local lsp_symbols = {
  Text = "", --   Text = "",
  Method = "",
  Function = "",
  Constructor = "", --   Constructor = "⌘",
  Field = "ﴲ", --   Field = "ﰠ",
  Variable = "", --   Variable = "",
  Class = "", --   Class = "ﴯ",
  Interface = "ﰮ ", --   Interface = "",
  Module = " ", --   Module = "",
  Property = "襁", --   Property = "ﰠ",
  Unit = "", --   Unit = "塞",
  Value = "", --   Value = "",
  Enum = "練", --   Enum = "",
  Keyword = "", --   Keyword = "廓",
  Snippet = "", --   Snippet = "",
  Color = "", --   Color = "",
  File = "", --   File = "",
  Reference = "", --   Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "ﲀ", --   Constant = "",
  Struct = "ﳤ", --   Struct = "פּ",
  Event = "",
  Operator = "", --   Operator = "",
  TypeParameter = ""
}

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }

vim.opt.dictionary:append("/usr/share/dict/words")

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

cmp.setup(
  {
    confirmation = {
      get_commit_characters = function()
        return {}
      end
    },
    experimental = {
      native_menu = false,
      ghost_text = true
    },
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = "menuone,noinsert,noselect",
      keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
      keyword_length = 1
      --     autocomplete = {
      --       types.cmp.TriggerEvent.TextChanged,
      --     },
      --     completeopt = 'menu,menuone,noselect',
    },
    mapping = {
      ["<C-x><C-o>"] = cmp.mapping.complete(),
      ["<C-x><C-s>"] = cmp.mapping.complete({config = {sources = {{name = "vsnip"}}}}),
      ["<C-n>"] = {
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            -- fallback()
            cmp.mapping.complete()
          end
        end
        -- c = cmp.config.disable
      },
      ["<C-p>"] = {
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            -- fallback()
            cmp.mapping.complete()
          end
        end
        -- c = cmp.config.disable
      },
      ["<PageUp>"] = {
        i = cmp.mapping.scroll_docs(-4)
      },
      ["<PageDown>"] = {
        i = cmp.mapping.scroll_docs(4)
      },
      ["<c-b>"] = {
        i = function(fallback)
          for i = 1, 10 do
            cmp.mapping.select_prev_item()(nil)
          end
        end
      },
      ["<c-f>"] = {
        i = function(fallback)
          for i = 1, 10 do
            cmp.mapping.select_next_item()(nil)
          end
        end
      },
      -- ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = {
        i = cmp.mapping.abort()
      },
      ["<Tab>"] = {
        i = function(fallback)
          if vim.fn.pumvisible() == 1 then
            return t("<C-n>")
          elseif vim.fn.call("vsnip#available", {1}) == 1 then
            return t("<Plug>(vsnip-expand-or-jump)")
          elseif check_back_space() then
            return t("<Tab>")
          else
            return cmp.mapping.complete()
          end
        end
        -- c = cmp.config.disable
      },
      ["<S-Tab>"] = {
        i = function(fallback)
          if vim.fn.pumvisible() == 1 then
            return t("<C-p>")
          elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            return t("<Plug>(vsnip-jump-prev)")
          else
            -- If <S-Tab> is not working in your terminal, change it to <C-h>
            return t("<S-Tab>")
          end
        end
        -- c = cmp.config.disable
      }
    },
    view = {
      entries = {
        name = "custom", -- can be "custom", "wildmenu" or "native"
        selection_order = "top_down" -- near_cursor, top_down
      }
    },
    window = {
      completion = {
        border = {"", "", "", "", "", "", "", ""},
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
      },
      documentation = {
        max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
        max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
        border = {"", "", "", " ", "", "", "", " "},
        winhighlight = "FloatBorder:NormalFloat"
      }
    },
    formatting = {
      fields = {"kind", "abbr", "menu"},
      -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
      -- format = lspkind.cmp_format,
      -- format = lspkind.cmp_format({ mode = "symbol_text", format = function(entry, vim_item) })
      -- vim_item.menu = vim_item.kind
      format = function(entry, vim_item)
        vim_item.menu =
          ({
          buffer = "buffer",
          calc = "calc",
          cmp_rg = "rg",
          cmp_git = "git",
          cmp_tabnine = "tab9",
          dictionary = "dict",
          emoji = "emoji",
          look = "look",
          npm = "npm",
          nvim_lsp = "lsp",
          nvim_lua = "lua",
          nvim_lsp_signature_help = "lspsig",
          nvim_lsp_document_symbol = "lspdoc",
          path = "path",
          spell = "spell",
          treesitter = "tree",
          tmux = "tmux",
          ["vimwiki-tags"] = "vimwiki",
          vsnip = "vsnip",
          ["vim-dadbod-completion"] = "sql",
          zsh = "zsh"
        })[entry.source.name]
        vim_item.kind = lsp_symbols[vim_item.kind]
        return vim_item
      end
    },
    -- sorting = {
    --   priority_weight = 2,
    --   comparators = {
    --     compare.offset,
    --     compare.exact,
    --     compare.score,
    --     compare.kind,
    --     compare.sort_text,
    --     compare.length,
    --     compare.order
    --   }
    -- },
    sorting = {
      priority_weight = 2
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end
    },
    sources = cmp.config.sources(
      {
        {name = "nvim_lsp", priority = 8},
        -- {name = "nvim_lua", priority = 7},
        -- {name = "nvim_lsp_signature_help", priority = 7},
        -- {name = "nvim_lsp_document_symbol", priority = 7},
        {name = "vim-dadbod-completion", priority = 5},
        {name = "path", priority = 5},
        {name = "vsnip", priority = 4},
        -- {name = "cmp_tabnine", priority = 3},
        {
          name = "buffer",
          keyword_length = 2,
          max_item_count = 10,
          priority = 3
          -- get_bufnrs = function()
          --   return vim.api.nvim_get_current_buffer()
          --   -- return vim.api.nvim_list_bufs() -- use all buffers
          -- end
        },
        {name = "calc", priority = 3},
        {name = "spell", priority = 3},
        {name = "cmp_git", priority = 3},
        {name = "zsh", priority = 2, keyword_length = 3, max_item_count = 10},
        {name = "pandoc_references", priority = 3},
        {name = "emoji", priority = 2},
        {name = "treesitter", priority = 1},
        {name = "vimwiki-tags", priority = 1},
        {name = "npm", keyword_length = 1},
        {
          name = "tmux",
          max_item_count = 10,
          keyword_length = 3,
          priority = 1,
          option = {
            all_panes = false,
            label = "tmux",
            trigger_characters = {"."},
            trigger_characters_ft = {}
            -- trigger_characters_ft = {markdown = {}}
          }
        }
        -- { name = "rg" },
        -- { name = "dictionary", keyword_length = 2, },
        -- { name = "neorg" },
        -- # unknown source names
        -- - vim-dadbod-completion
        -- - cmp_git
        -- - npm
      }
    )
  }
)

vim.cmd(
  [[
  augroup NvimCmp
  au!
  au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
  augroup END
]]
)

-- defaults --
-- return {
--   enabled = function()
--     local disabled = false
--     disabled = disabled or (vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt')
--     disabled = disabled or (vim.fn.reg_recording() ~= '')
--     disabled = disabled or (vim.fn.reg_executing() ~= '')
--     return not disabled
--   end,

--   preselect = types.cmp.PreselectMode.Item,

--   mapping = {},

--   snippet = {
--     expand = function()
--       error('snippet engine is not configured.')
--     end,
--   },

--   completion = {
--     autocomplete = {
--       types.cmp.TriggerEvent.TextChanged,
--     },
--     completeopt = 'menu,menuone,noselect',
--     keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
--     keyword_length = 1,
--   },

--   formatting = {
--     fields = { 'abbr', 'kind', 'menu' },
--     format = function(_, vim_item)
--       return vim_item
--     end,
--   },

--   matching = {
--     disallow_fuzzy_matching = false,
--     disallow_partial_matching = false,
--     disallow_prefix_unmatching = false,
--   },

--   sorting = {
--     priority_weight = 2,
--     comparators = {
--       compare.offset,
--       compare.exact,
--       -- compare.scopes,
--       compare.score,
--       compare.recently_used,
--       compare.locality,
--       compare.kind,
--       compare.sort_text,
--       compare.length,
--       compare.order,
--     },
--   },

--   sources = {},

--   confirmation = {
--     default_behavior = types.cmp.ConfirmBehavior.Insert,
--     get_commit_characters = function(commit_characters)
--       return commit_characters
--     end,
--   },

--   event = {},

--   experimental = {
--     ghost_text = false,
--   },

--   view = {
--     entries = { name = 'custom', selection_order = 'top_down' },
--   },

--   window = {
--     completion = {
--       border = { '', '', '', '', '', '', '', '' },
--       winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
--     },
--     documentation = {
--       max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
--       max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
--       border = { '', '', '', ' ', '', '', '', ' ' },
--       winhighlight = 'FloatBorder:NormalFloat',
--     },
--   },
-- }

-- cmp.setup.filetype({ 'markdown', 'help' }, {
--   sources = {
--     { name = 'path' },
--     { name = 'buffer' },
--   }
-- })

--   mapping = {
--     ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--     ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--     ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
--     ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     })
--   },

-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" },
--   },
-- })

-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--       { name = "cmdline" },
--     }),
-- })

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
