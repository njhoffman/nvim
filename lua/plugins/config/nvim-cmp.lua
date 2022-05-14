local ok, cmp = pcall(require, "cmp")
if not ok then return end

local mapping = require('plugin.config.nvim-cmp.mapping')
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
local lsp_sources = {
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
}

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }
vim.opt.dictionary:append("/usr/share/dict/words")

local setupConfig = {
  -- disable inside comments and telescope window
  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
    if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require("cmp.config.context")
    return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
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
    completeopt = "menuone,noinsert,noselect",
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1
    --     autocomplete = {
    --       types.cmp.TriggerEvent.TextChanged,
    --     },
    --     completeopt = 'menu,menuone,noselect',
  },
  mapping = mapping,
  view = {
    entries = {
      name = "custom", -- can be "custom", "wildmenu" or "native"
      selection_order = "top_down" -- near_cursor, top_down
    }
  },
  window = {
    completion = {
      border = { "", "", "", "", "", "", "", "" },
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
    },
    documentation = {
      max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
      border = { "", "", "", " ", "", "", "", " " },
      winhighlight = "FloatBorder:NormalFloat"
    }
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    -- format = lspkind.cmp_format,
    -- format = lspkind.cmp_format({ mode = "symbol_text", format = function(entry, vim_item) })
    -- vim_item.menu = vim_item.kind
    format = function(entry, vim_item)
      vim_item.menu = lsp_sources[entry.source.name]
      vim_item.kind = lsp_symbols[vim_item.kind]
      return vim_item
    end
  },
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
    { name = "nvim_lsp", priority = 8 },
    -- {name = "nvim_lua", priority = 7},
    -- {name = "nvim_lsp_signature_help", priority = 7},
    -- {name = "nvim_lsp_document_symbol", priority = 7},
    { name = "vim-dadbod-completion", priority = 5 },
    { name = "path", priority = 5 },
    { name = "vsnip", priority = 4 },
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
    { name = "calc", priority = 3 },
    { name = "spell", priority = 3 },
    { name = "cmp_git", priority = 3 },
    { name = "zsh", priority = 2, keyword_length = 3, max_item_count = 10 },
    { name = "pandoc_references", priority = 3 },
    { name = "emoji", priority = 2 },
    { name = "treesitter", priority = 1 },
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
    -- # unknown source names
    -- - vim-dadbod-completion
    -- - cmp_git
    -- - npm
  }
  )
}

cmp.setup(setupConfig)
