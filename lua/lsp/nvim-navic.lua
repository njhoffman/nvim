local alternate_icons = {
  File = ' ',
  Module = ' ',
  Namespace = ' ',
  Package = ' ',
  Class = ' ',
  Method = ' ',
  Property = ' ',
  Field = ' ',
  Constructor = ' ',
  Enum = ' ',
  Interface = ' ',
  Function = ' ',
  Variable = ' ',
  Constant = ' ',
  String = ' ',
  Number = ' ',
  Boolean = ' ',
  Array = ' ',
  Object = ' ',
  Key = ' ',
  Null = ' ',
  EnumMember = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

-- stylua: ignore
local cfg_defaults = {
  icons = {
    File          = " ",
    Module        = " ",
    Namespace     = " ",
    Package       = " ",
    Class         = " ",
    Method        = " ",
    Property      = " ",
    Field         = " ",
    Constructor   = " ",
    Enum          = "練",
    Interface     = "練",
    Function      = " ",
    Variable      = " ",
    Constant      = " ",
    String        = " ",
    Number        = " ",
    Boolean       = "◩ ",
    Array         = " ",
    Object        = " ",
    Key           = " ",
    Null          = "ﳠ ",
    EnumMember    = " ",
    Struct        = " ",
    Event         = " ",
    Operator      = " ",
    TypeParameter = " ",
  },
  highlight = true,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
  safe_output = true,
}

local navic = require('nvim-navic')
local cfg = cfg_defaults
navic.setup(cfg)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not vim.tbl_contains({
      'copilot',
      'null-ls',
      'ltex',
      'tailwindcss',
      'eslint',
    }, client.name) then
      require('nvim-navic').attach(client, bufnr)
    end
  end,
})
return navic
