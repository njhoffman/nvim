local cmp = require('cmp')

local cmp_mappings = require("plugins.config.nvim-cmp-mapping")
local compare = require("cmp.config.compare")
local types = require("cmp.types")

local sort_under = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end


--  local after_line = string.sub(line, cursor + 1, -1)
local lsp_symbols = {
  Text          = " ", --   Text = " ",
  Method        = " ",
  Function      = " ",
  Constructor   = " ", --   Constructor = "⌘ ",
  Field         = "ﴲ ", --   Field = "ﰠ ",
  Variable      = " ", --   Variable = " ",
  Class         = " ", --   Class = "ﴯ ",
  Interface     = "ﰮ ", --   Interface = " ",
  Module        = " ", --   Module = " ",
  Property      = "襁 ", --   Property = "ﰠ ",
  Unit          = " ", --   Unit = "塞 ",
  Value         = " ",
  Enum          = "練 ", --   Enum = " ",
  Keyword       = " ", --   Keyword = "廓 ",
  Snippet       = " ", --   Snippet = " ",
  Color         = " ",
  File          = " ", --   File = " ",
  Reference     = " ", --   Reference = " ",
  Folder        = " ",
  EnumMember    = " ",
  Constant      = "ﲀ ", --   Constant = " ",
  Struct        = "ﳤ ", --   Struct = "פּ ",
  Event         = " ",
  Operator      = " ", --   Operator = " ",
  TypeParameter = " "
}

local lsp_sources = {
  ["vim-dadbod-completion"] = "sql",
  ["vimwiki-tags"] = "vimwiki",
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
  omni = "omni",
  spell = "spell",
  tmux = "tmux",
  treesitter = "tree",
  zsh = "zsh"
}

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }
vim.opt.dictionary:append("/usr/share/dict/words")

local cmp_helper = {
  -- Deprioritize items starting with underscores (private or protected)
  deprioritize_underscore = function(lhs, rhs)
    local l = (lhs.completion_item.label:find "^_+") and 1 or 0
    local r = (rhs.completion_item.label:find "^_+") and 1 or 0
    if l ~= r then return l < r end
  end,
  -- Prioritize items that ends with "= ..." (usually for argument completion).
  prioritize_argument = function(lhs, rhs)
    local l = (lhs.completion_item.label:find "=$") and 1 or 0
    local r = (rhs.completion_item.label:find "=$") and 1 or 0
    if l ~= r then return l > r end
  end,
}


local setupConfig = {
  enabled = function()
    -- disable inside comments and telescope window
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then
      return false
    end
    local context = require("cmp.config.context")
    return not (context.in_treesitter_capture("comment") == true or
      context.in_syntax_group("Comment"))
  end,
  experimental = {
    native_menu = false,
    ghost_text = true
  },
  preselect = cmp.PreselectMode.Item, -- cmp.PreselectMode.None,
  completion = {
    -- completeopt = "menuone,longest,noselect", --noinsert,noselect
    completeopt = "menu,menuone,noselect", --noinsert,noselect
    keyword_length = 1,
    -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    -- autocomplete = {
    --   types.cmp.TriggerEvent.TextChanged
    -- }
  },
  mapping = cmp.mapping.preset.insert(cmp_mappings()),
  view = {
    entries = {
      name = "custom", -- can be "custom", "wildmenu" or "native"
      selection_order = "top_down" -- near_cursor, top_down
    }
  },
  window = {
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None"
      --   max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      --   max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }),
    completion = cmp.config.window.bordered({
      --   border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
      --   winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None"
      -- max_width = 80,
    })

  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      local max_len = 50
      if string.len(vim_item.abbr) > max_len then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_len - 2) .. "··"
      end
      vim_item.dup = ({
        nvim_lua = 0,
      })[entry.source.name] or 1
      vim_item.menu = lsp_sources[entry.source.name]
      vim_item.kind = lsp_symbols[vim_item.kind]
      return vim_item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      require("cmp_fuzzy_path.compare"),
      require("cmp_fuzzy_buffer.compare"),
      sort_under,
      function(...) return cmp_helper.prioritize_argument(...) end,
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
  sources = cmp.config.sources({
    -- nvim_lua, nvim_lsp_signature_help, vim-dadbod-completion, cmp_tabnine
    { name = "nvim_lsp", priority = 100 },
    { name = "luasnip", priority = 30 },
    { name = "fuzzy_path", priority = 10 },
    { name = "omni", priority = 5 },
    -- {
    --   name           = "treesitter",
    --   priority       = 3,
    --   keyword_length = 3,
    --   max_item_count = 10,
    --   -- keyword_pattern = [[\k\+]],
    --   -- keyword_pattern = [[\!\@<!\w*]]
    --   -- keyword_pattern = [=[[^[:blank:]].*]=],
    --   get_bufnrs     = function()
    --     return { vim.api.nvim_get_current_buf() }
    --   end
    -- },
    { name = "calc", priority = 3 },
    { name = "spell", priority = 3 },
    { name = "git", priority = 3 },
    { name = "zsh", priority = 2, keyword_length = 3, max_item_count = 10 },
    { name = "pandoc_references", priority = 3 },
    { name = "emoji", priority = 2 },
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
        -- trigger_characters = { "." },
        trigger_characters_ft = {}
        -- trigger_characters_ft = {markdown = {}}
      }
    }
  }, {
    { name = "fuzzy_buffer", keyword_pattern = [[\k\+]], keyword_length = 3 }
  }
  )
}

cmp.setup(setupConfig)

-- Set configuration for specific filetype.
cmp.setup.filetype(
  "gitcommit", {
  sources = cmp.config.sources({
    { name = "git" } -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "fuzzy_buffer" }
  })
}
)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings()),
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } }
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings()),
  sources = cmp.config.sources({
    { name = "fuzzy_path" }
  }, {
    { name = "cmdline" }
  })
})

cmp.setup.filetype({ 'markdown', 'help' }, {
  window = {
    documentation = cmp.config.disable
  }
})

-- vim.cmd([[
--   augroup NvimCmp
--   au!
--   au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
--   augroup END
-- ]])

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

-- In order to show completions defined in your zshrc you can setup cmp zsh like this. Note: This feature is experimental. If you enable it and don't get any results try disabling it.
-- require'cmp_zsh'.setup {
--   zshrc = true -- Source the zshrc (adding all custom completions)
-- }
-- Alternatively you can use this trick (if sourcing your zshrc is very slow): Add the directory of the complete function to $FPATH in ~/.zshenv.
-- # completions
-- if [ -d $HOME/.zsh/comp ]; then
--     export FPATH="$HOME/.zsh/comp:$FPATH"
-- fi
