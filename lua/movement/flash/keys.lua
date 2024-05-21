-- stylua: ignore
local prefixes = {
  jump       = '\\j',
  lask       = '\\s',
  lsp        = '\\l',
  misc       = '\\m',
  treesitter = '\\t',
}

-- stylua: ignore
local maps = {
  treesitter = {
    remote_node             = '<cr>',
    tree_search             = 'R',
    tree_search_op          = 'M',

    goto_prev               = ';;',
    goto_prefix             = ';;',
    goto_next               = ';;',
    goto_previous           = ';;',

    select_remote_next      = 'in',
    select_remote_prev      = 'iN',
    select_remote_start     = 'ix',
    select_remote_end       = 'iX',
    select_cword            = 'iw',
    select_word             = 'iW',
    select_continue         = 'ic',
    select_remote_dynamic   = 'ir',

    exchange_node           = 'rix',
    exchange_motion         = 'rx',
    exchange_vline          = 'rxx',
    remote_replace          = ';R',
    replace_remote_motion   = ';ry',
    replace_remote_d_motion = ';rd',
    replace_remote_c_motion = ';rc',
    replace_node            = ';rY',
    replace_d_node          = ';rD',
    replace_c_node          = ';rC',
    treesitter_unit         = 'u',
    treesitter_dynamic      = ';rw',
  },
  lsp = {
    jump_definition         =  'g;',
    jump_hover              =  '<c-;>',
    jump_references         =  '<leader>s',
    jump_diag               =  'd',
    jump_diag_lspsaga       =  'D',
    jump_diag_wtf           =  ';d',
    jump_diag_ai            =  ';D',
    jump_code_action        =  'dD',
  },
  jump = {
    toggle_search           =  '<c-s>',
    jump_from_char          =  'f',
    jump_from_char_backward =  'F',
    jump_to_char            =  't',
    jump_to_char_backward   =  'T',
    op_jump_forward         =  'x',
    op_jump_backward        =  'X',
    op_treesitter           =  "S",
    word_jump_forward       =  's',
    word_jump_backward      =  'S',
    word_fuzzy_search       =  '?',
    word_fuzzy_remote       =  '?',
    word_fuzzy_select       =  '?',
    word_current_jump       =  '<leader>W',
    word_current_screen     =  '<S-cr>',
    word_current_buffer     =  '<c-s>',
    word_jump_any           =  '\\/',
  },
  lask = {
    search_lask_star        =  "*",
    search_lask_word        =  "*",
    search_lask_gword       =  "g*",
    search_lask_ref         =  "#",
    search_lask_pound       =  "#",
    search_lask_gpound      =  "g#"
  }
}

local ts = maps.treesitter or {}
--stylua: ignore
vim.tbl_deep_extend('force', maps.treesitter, {
  goto_prev        = ts.goto_previous,
  select_prev      = ts.select_previous,
  select_node_next = ts.goto_next .. ts.select_remote_dynamic,
  select_node_prev = ts.goto_prev .. ts.select_remote_dynamic,
  jump_node_end    = ts.goto_next .. ts.select_remote_dynamic,
  jump_node_start  = ts.goto_prev .. ts.select_remote_dynamic,
  jump_cword       = ts.goto_prefix .. 'W',
  jump_continue    = ts.goto_prefix .. 'n',
})

local keys = {}
for name, defs in pairs(maps) do
  local pfx = prefixes[name] or ''
  for k, val in pairs(defs) do
    keys[k] = pfx .. val
  end
end

vim.dbglog(keys)

return keys
