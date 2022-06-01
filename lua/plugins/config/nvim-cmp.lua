local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local mapping = require("plugins.config.nvim-cmp-mapping")
local compare = require("cmp.config.compare")
local types = require("cmp.types")

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
local lsp_sources = {
  ["vim-dadbod-completion"] = "sql",
  ["vimwiki-tags"] = "vimwiki",
  -- buffer = "buffer",
  calc = "calc",
  cmp_git = "git",
  cmp_rg = "rg",
  cmp_tabnine = "tab9",
  dictionary = "dict",
  emoji = "emoji",
  fuzzy_buffer = "buf",
  fuzzy_path = "path",
  look = "look",
  luasnip = "snip",
  npm = "npm",
  nvim_lsp = "lsp",
  nvim_lsp_document_symbol = "doc",
  nvim_lsp_signature_help = "sig",
  nvim_lua = "lua",
  -- path = "path",
  spell = "spell",
  tmux = "tmux",
  treesitter = "tree",
  zsh = "zsh"
}

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }
vim.opt.dictionary:append("/usr/share/dict/words")

local setupConfig = {
  -- disable inside comments and telescope window
  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require("cmp.config.context")
    return not (context.in_treesitter_capture("comment") == true or
      context.in_syntax_group("Comment"))
  end,
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
    completeopt = "menuone,longest",
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged
    }
  },
  mapping = cmp.mapping.preset.insert(mapping.insert_override),
  view = {
    entries = {
      name = "custom", -- can be "custom", "wildmenu" or "native"
      selection_order = "top_down" -- near_cursor, top_down
    }
  },
  window = {
    -- completion = {
    --   border = { "", "", "", "", "", "", "", "" },
    --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
    -- },
    -- documentation = {
    --   max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
    --   max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    --   border = { "", "", "", " ", "", "", "", " " },
    --   winhighlight = "FloatBorder:NormalFloat"
    -- }
    documentation = cmp.config.window.bordered(
      {
        winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None"
      }
    ),
    completion = cmp.config.window.bordered(
      {
        -- winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None"
      }
    )
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      vim_item.menu = lsp_sources[entry.source.name]
      vim_item.kind = lsp_symbols[vim_item.kind]
      return vim_item
    end
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require("cmp_fuzzy_path.compare"),
      require("cmp_fuzzy_buffer.compare"),
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order
    }
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end
  },
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp", priority = 8 },
      -- { name = "nvim_lua", priority = 7 },
      { name = "nvim_lsp_signature_help", priority = 7 },
      { name = "nvim_lsp_document_symbol", priority = 7 },
      -- { name = "vim-dadbod-completion", priority = 5 },
      { name = "fuzzy_path", priority = 5 },
      -- { name = "path", priority = 5 },
      { name = "luasnip", priority = 4 },
      -- {name = "cmp_tabnine", priority = 3},
      { name = "calc", priority = 3 },
      { name = "spell", priority = 3 },
      { name = "git", priority = 3 },
      { name = "zsh", priority = 2, keyword_length = 3, max_item_count = 10 },
      { name = "pandoc_references", priority = 3 },
      { name = "emoji", priority = 2 },
      -- { name = "treesitter", priority = 0 },
      { name = "vimwiki-tags", priority = 1 },
      { name = "npm", keyword_length = 1 },
      {
        name = "tmux",
        max_item_count = 10,
        keyword_length = 3,
        priority = 1,
        option = {
          all_panes = false,
          label = "tmux",
          trigger_characters = { "." },
          trigger_characters_ft = {}
          -- trigger_characters_ft = {markdown = {}}
        }
      }
      -- { name = "rg" },
      -- { name = "dictionary", keyword_length = 2, },
      -- { name = "neorg" },
    },
    {
      { name = "fuzzy_buffer", priority = 3 }
      -- { name = 'buffer' },
      -- { name = 'cmdline' }
    }
  )
}

cmp.setup(setupConfig)

-- Set configuration for specific filetype.
cmp.setup.filetype(
  "gitcommit",
  {
    sources = cmp.config.sources(
      {
        { name = "git" } -- You can specify the `cmp_git` source if you were installed it.
      },
      {
        { name = "fuzzy_buffer" }
      }
    )
  }
)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/",
  {
    mapping = cmp.mapping.preset.cmdline(mapping.cmdline_override),
    sources = {
      { name = "fuzzy_buffer" }
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  {
    mapping = cmp.mapping.preset.cmdline(mapping.cmdline_override),
    sources = cmp.config.sources(
      {
        { name = "fuzzy_path" }
      },
      {
        { name = "cmdline" }
      }
    )
  }
)

return cmp

-- -- cmp-vimwiki-tags
-- -- I use this shell script to launch Vimwiki. It opens the Vimwiki directory and then immediately opens either the file with the name of the first argument (which will create that file if it does not exist), or the index file in case of no arguments. If you pass more than one argument it will add them as tags to the top of the file.
-- -- function note_fn() {
-- --   if [[ "$1" == "" ]]; then
-- --     cd "$vimwiki_path" && nvim -c "e index.md" .
-- --   elif [[ "$2" == "" ]]; then
-- --     cd "$vimwiki_path" && nvim -c "e $1.md" .
-- --   else
-- --     tags=":"
-- --     for tag in "${@:2}"; do
-- --       tags="$tags$tag:"
-- --     done
-- --     cd "$vimwiki_path" && nvim -c "e $1.md | execute 'normal ggO$tags'" .
-- --   fi
-- -- }
-- -- alias note=note_fn

-- -- vim.cmd([[ autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }, { name = 'nvim_lsp' } } }) ]])

-- -- vim.cmd(
-- --     [[autocmd FileType sql,mysql,pgsql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }, { name = "nvim_lsp" "}} })]])
-- -- vim.cmd([[let g:completion_chain_complete_list = { 'sql': [  {'complete_items': ['vim-dadbod-completion']}, ], }]])
-- -- " Source is automatically added, you just need to include it in the chain complete list
-- vim.cmd(
--   [[
--   augroup NvimCmp
--   au!
--   au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
--   augroup END
-- ]]
-- )
