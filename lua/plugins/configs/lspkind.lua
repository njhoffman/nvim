require('lspkind').init({
  with_text = true,

  -- symbol_map_defaults = {
  --   Text        = '',
  --   Method      = 'ƒ',
  --   Function    = '',
  --   Constructor = '',
  --   Variable    = '',
  --   Class       = '',
  --   Interface   = 'ﰮ',
  --   Module      = '',
  --   Property    = '',
  --   Unit        = '',
  --   Value       = '',
  --   Enum        = '了',
  --   Keyword     = '',
  --   Snippet     = '﬌',
  --   Color       = '',
  --   File        = '',
  --   Folder      = '',
  --   EnumMember  = '',
  --   Constant    = '',
  --   Struct      = ''
  -- },

  symbol_map = {
    Text          = '',
    Method        = '',
    Function      = '',
    Field         = 'ﴲ ',
    -- Variable = '[]',
    Class         = '',
    Interface     = 'ﰮ',
    Module        = '',
    Property      = '襁',
    Unit          = '',
    Value         = '',
    Enum          = '練',
    Keyword       = '',
    File          = '',
    Reference     = '',
    Folder        = '',
    Constant      = 'ﲀ',
    Struct        = ' ﳤ ',
    Event         = '',
    Operator      = '',
    TypeParameter = ''
  }
})

-- local kind_presets = {
--   default = {
-- -- if you change or add symbol here
-- -- replace corresponding line in readme
--     Text = "",
--     Method = "",
--     Function = "",
--     Constructor = "",
--     Field = "ﰠ",
--     Variable = "",
--     Class = "ﴯ",
--     Interface = "",
--     Module = "",
--     Property = "ﰠ",
--     Unit = "塞",
--     Value = "",
--     Enum = "",
--     Keyword = "",
--     Snippet = "",
--     Color = "",
--     File = "",
--     Reference = "",
--     Folder = "",
--     EnumMember = "",
--     Constant = "",
--     Struct = "פּ",
--     Event = "",
--     Operator = "",
--     TypeParameter = ""
--   },
-- }

-- local kind_order = {
--   'Text', 'Method', 'Function', 'Constructor', 'Field', 'Variable', 'Class', 'Interface', 'Module',
--   'Property', 'Unit', 'Value', 'Enum', 'Keyword', 'Snippet', 'Color', 'File', 'Reference', 'Folder',
--   'EnumMember', 'Constant', 'Struct', 'Event', 'Operator', 'TypeParameter'
-- }
-- local kind_len = 25
