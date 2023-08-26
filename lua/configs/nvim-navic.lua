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
    File          = "󰈙 ",
    Module        = " ",
    Namespace     = "󰌗 ",
    Package       = " ",
    Class         = "󰌗 ",
    Method        = "󰆧 ",
    Property      = " ",
    Field         = " ",
    Constructor   = " ",
    Enum          = "󰕘",
    Interface     = "󰕘",
    Function      = "󰊕 ",
    Variable      = "󰆧 ",
    Constant      = "󰏿 ",
    String        = " ",
    Number        = "󰎠 ",
    Boolean       = "◩ ",
    Array         = "󰅪 ",
    Object        = "󰅩 ",
    Key           = "󰌋 ",
    Null          = "󰟢 ",
    EnumMember    = " ",
    Struct        = "󰌗 ",
    Event         = " ",
    Operator      = "󰆕 ",
    TypeParameter = "󰊄 ",
  },
  highlight = true,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
  safe_output = true,
  lsp = {
    auto_attach = false,
    preference = nil,
  },
}

-- silence lsp already attached warning

vim.api.nvim_set_var('navic_silence', true)
local navic = require('nvim-navic')
local cfg = { lsp = { auto_attach = false, preference = { 'pylsp', 'pyright' } } }
navic.setup(cfg)

-- local ignore_clients = { 'copilot', 'ltex', 'tailwindcss', 'eslint' }
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     vim.dbglog('trying', client.name, bufnr)
--     if
--       not vim.tbl_contains(ignore_clients, client.name)
--       and client.server_capabilities.documentSymbolProvider
--       and navic.is_available(bufnr)
--     then
--       vim.dbglog('attaching', client.name, bufnr)
--       require('nvim-navic').attach(client, bufnr)
--     end
--   end,
-- })
