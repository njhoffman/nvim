local cfg = {
  layout = {
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    max_width = { 40, 0.3 },
    width = nil,
    min_width = 30,
    default_direction = 'prefer_right',
    preserve_equality = false,
  },
  highlight_mode = 'full_width',
  -- Highlight the closest symbol if the cursor is not exactly on one.
  highlight_closest = true,
  -- Highlight the symbol in the source buffer when cursor is in the aerial win
  highlight_on_hover = true,
  -- When jumping to a symbol, highlight the line for this many ms.
  -- Set to false to disable
  highlight_on_jump = 500,
  ignore = {
    -- Ignore unlisted buffers. See :help buflisted
    unlisted_buffers = true,
    -- List of filetypes to ignore.
    filetypes = { 'gitcommit', 'alpha' },
    buftypes = 'special',
    wintypes = 'special',
  },
  backends = {
    -- ["_"] = { "lsp", "treesitter", "markdown", "man" },
    ['_'] = { 'lsp', 'treesitter', 'markdown', 'man' },
    man = { 'man' },
    markdown = { 'markdown' },
  },
  -- stylua: ignore
  icons = {
    Array         = " ", --
    Boolean       = " ", --
    Class         = " 󰌗", --   Class = " 󰠱","  "
    Color         = " 󰏘",
    Constant      = " 󰞂", --   Constant = " 󰐀",
    Constructor   = " ⌘", --   Constructor = "⌘ ","" ' ', " ",
    Enum          = " 󰕘", --   Enum = " " " " ,
    EnumMember    = " ",  -- ' '
    Event         = " ",  -- " "
    Field         = " ", --   Field = "󰜢 ", " ", " 󰜢",
    File          = " ", --   File = "󰈙 ", " ", " 󰈔" ,
    Folder        = " 󰉋",
    Function      = " 󰊕",
    Interface     = " ", --   Interface = " ", ' ', " 󰜰",
    Keyword       = " 󰌋", --   Keyword = "󰔌 ",
    Key           = " " ,
    Method        = " 󰆧",
    Number        = " ",
    Null          = " ", -- "", " "
    Module        = " 󰅩", --   Module = "󰏓 ",
    Object        = " ", --
    Operator      = " ", --   Operator = "󰆕 ",  " ", " 󰃬",
    Property      = " ", --   Property = "󰜢", " ", " 󰖷"," "," 󰜢"
    Reference     = " 󰈇", --   Reference = "󰈇 ", " 󰈝",
    Snippet       = " ", --   Snippet = "󰅱 ",
    String        = "  ",
    Struct        = "  ", --   Struct = "󰙅 ", "  ", " 󰟦",
    Text          = " ", --   Text = " ",
    TypeParameter = " ", --   ' ', " 󰊄"
    Unit          = " ", --   Unit = "󰑭 ",
    Value         = " 󰎠",
    Variable      = " ", --   Variable = "󰈜 ", ' ',
  },
  nerd_font = true,
  float = {
    border = 'rounded',
    relative = 'win',
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.1 },
  },

  filter_kind = {
    'Array',
    -- "Boolean",
    'Class',
    'Constructor',
    'Constant',
    'Enum',
    -- 'EnumMember',
    -- 'Event',
    'Field',
    'Function',
    'Interface',
    -- 'Key',
    'Method',
    'Module',
    'Namespace',
    -- 'Null',
    -- 'Number',
    'Object',
    -- 'Operator',
    -- "Package",
    -- 'Property',
    -- 'String',
    'Struct',
    'TypeParameter',
    'Variable',
  },
  {
    open_automatic = function(bufnr)
      local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
      return ft == 'help' or 'man'
      -- Enforce a minimum line count
      -- return vim.api.nvim_buf_line_count(bufnr) > 80
      --   -- Enforce a minimum symbol count
      --   and aerial.num_symbols(bufnr) > 4
      --   -- A useful way to keep aerial closed when closed manually
      --   and not aerial.was_closed()
    end,
  },

  -- Customize the characters used when show_guides = true
  guides = {
    -- When the child item has a sibling below it
    mid_item = '├─',
    -- When the child item is the last in the list
    last_item = '└─',
    -- When there are nested child guides to the right
    nested_top = '│ ',
    -- Raw indentation
    whitespace = '  ',
  },
  -- filter_kind = {
  --   ["_"] = {
  --     "Array",
  --     "Boolean",
  --     "Class",
  --     "Constant",
  --     "Constructor",
  --     "Enum",
  --     "EnumMember",
  --     "Event",
  --     "Field",
  --     "File",
  --     "Function",
  --     "Interface",
  --     "Key",
  --     "Method",
  --     "Module",
  --     "Namespace",
  --     "Null",
  --     "Number",
  --     "Object",
  --     "Operator",
  --     "Package",
  --     "Property",
  --     "String",
  --     "Struct",
  --     "TypeParameter",
  --     "Variable",
  --   },
  --   -- markdown = { "String" },
  -- },
}

local aucmds = require('configs.aerial.autocmds')
local highlights = require('configs.aerial.highlights')
local aerial = require('aerial')
aerial.setup(cfg)
highlights.setup()
aucmds.setup()
