local cfg = {
  profile = 'default',
  map = true,
  cmap = false, -- disable in command mode
  pair_map = true,
  pair_cmap = true,
  multiline = true,
  cr = {
    enable = true,
    map = '<cr>', --string or table
    autoclose = false,
    --(| > cr > (\n|\n)
    conf = {
      cond = function(fn)
        return not fn.in_lisp()
      end,
    },
    --contains extension config
    multi = false,
    --use multiple configs (|ultimate-autopair-map-multi-config|)
  },
  bs = {
    enable = true,
    map = '<bs>', --string or table
    cmap = '<bs>', --string or table
    overjumps = true,
    --(|foo) > bs > |foo
    space = true, --false, true or 'balance'
    --( |foo ) > bs > (|foo)
    --balance:
    --  Will prioritize balanced spaces
    --  ( |foo  ) > bs > ( |foo )
    indent_ignore = false,
    --(\n\t|\n) > bs > (|)
    single_delete = false,
    -- <!--|--> > bs > <!-|
    conf = {},
    --contains extension config
    multi = false,
    --use multiple configs (|ultimate-autopair-map-multi-config|)
  },
  close = {
    enable = false,
    map = '<M-)>', --string or table
    cmap = '<M-)>', --string or table
  },
  fastwarp = {
    enable = true,
    enable_normal = true,
    enable_reverse = true,
    hopout = false,
    multi = true,
    multiline = true,
    do_nothing_if_fail = true,
    -- no_filter_nodes = { 'string', 'raw_string', 'string_literals', 'character_literal' },
    { faster = false, nocursormove = false, map = '<M-0>', rmap = '<M-9>', cmap = '<M-0>', rcmap = '<M-9>' },
    -- { faster = false, nocursormove = true, map = '<M-)>', rmap = '<M-(>', cmap = '<M-)>', rcmap = '<M-(>' },
    { faster = true, nocursormove = true, map = "<M-'>", rmap = '<M-;>', cmap = "<M-'>", rcmap = '<M-;>' },
    { faster = true, nocursormove = true, map = '<M-.>', rmap = '<M-,>', cmap = '<M-.>', rcmap = '<M-,>' },
    -- which nodes to skip for tsnode filtering
    conf = {},
  },
  tabout = { -- *ultimate-autopair-map-tabout-config*
    enable = true,
    map = '<Tab>', --string or table
    cmap = '<Tab>', --string or table
    hopout = false,
    conf = {
      -- tabkey = '', -- key to trigger tabout, set to an empty string to disable
      -- backwards_tabkey = '', -- key to trigger backwards tabout, set to an empty string to disable
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = false,
      act_as_shift_tab = false,
      ignore_beginning = true,
    },
  },
  space = {
    enable = true,
    map = ' ', --string or table
    cmap = ' ', --string or table
    check_box_ft = { 'markdown', 'vimwiki' },
    --+ [|] > space > + [ ]
    conf = {},
    --contains extension config
    multi = false,
  },
  space2 = { -- *ultimate-autopair-map-space2-config*
    enable = true,
    match = [[\k]],
    --what character activate
    conf = {},
    --contains extension config
    multi = false,
    --use multiple configs (|ultimate-autopair-map-multi-config|)
  },
  default_pairs = {
    ft = {
      TelescopePrompt = { disable = true },
      Noice = { disable = true },
      noice = { disable = true },
    },
  },
  { '[=[', ']=', ft = { 'lua' } },
  {
    '[=[',
    ']=]',
    ft = { 'lua' },
    disable_start = true,
    disable_end = true,
  },
  extensions = {
    -- -- disable in comments
    -- rules = {
    --   rules = {
    --     {
    --       'call',
    --       function(o)
    --         local status, node = pcall(vim.treesitter.get_node, { pos = { o.linenr - 1, o.col - 2 } })
    --         return o.incmd
    --           or o.col == 1
    --           or not status
    --           or not node
    --           or node:type() ~= 'comment' and node:type() ~= 'html_block'
    --       end,
    --     },
    --   },
    -- },
    cmdtype = { skip = { '/', '?', '@', '-' }, p = 100 },
    escape = { filter = true, p = 80 },
    utf8 = { p = 70 },
    -- { 'treenode', { inside = { 'comment' } } },
    tsnode = {
      p = 60,
      separate = {
        -- 'comment',
        'string',
        'char',
        'character',
        'raw_string', --fish/bash/sh
        'char_literal',
        'string_literal', --c/cpp
        'string_value', --css
        'str_lit',
        'char_lit', --clojure/commonlisp
        'interpreted_string_literal',
        'raw_string_literal',
        'rune_literal', --go
        'quoted_attribute_value', --html
        'template_string', --javascript
        'LINESTRING',
        'STRINGLITERALSINGLE',
        'CHAR_LITERAL', --zig
        'string_literals',
        'character_literal',
        'line_comment',
        'block_comment',
        'nesting_block_comment', --d #62
      },
      outside = { 'comment' },
    },
    cond = {
      cond = {
        function(fn)
          return not fn.in_macro() and not fn.in_node('comment')
        end,
      },
      p = 40,
      filter = true,
    },
    alpha = {
      -- p = 30,
      -- filter = false,
      -- alpha = false,
      -- after = true,
      -- no_python = false, -- Weather to disable f-string detection.
      -- all = false, -- Weather to check for all in-characters, not just start pairs.
    },
    suround = {
      p = 20,
      dosuround = true, -- {dosuround} `boolean`: Weather to do surround
      suround = true, --   {suround} `boolean`: Weather to be allowed to be surrounded
    },
    filetype = { p = 90, nft = { 'TelescopePrompt', 'Noice', 'noice' }, tree = true },
    -- Get Fly Mode working on strings: https://github.com/altermo/ultimate-autopair.nvim/issues/17
    -- {'fly',{')','}',']',' ',"'",'"',nofilter=true}},
    fly = {
      other_char = { ' ' },
      nofilter = true, -- get it working on strings
      p = 10,
      undomapconf = {},
      -- undomap = '<BS>',
      -- undocmap = '<BS>',
      -- undomap = '<M-BS>',
      -- undocmap = '<M-BS>',
      only_jump_end_pair = false,
    },
  },
  { '*', '*', multiline = false, ft = { 'markdown' } },
  { '**', '**', multiline = false, ft = { 'markdown' } },
  { '$', '$', multiline = false, ft = { 'markdown' } },
  internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
    { '[', ']', fly = true, dosuround = true, newline = true, space = true },
    {
      '(',
      ')',
      fly = true,
      dosuround = true,
      newline = true,
      space = true,
      nft = { 'TelescopePrompt' },
    },
    { '{', '}', fly = true, dosuround = true, newline = true, space = true },
    {
      '"',
      '"',
      suround = true,
      multiline = false,
      nft = { 'TelescopePrompt' },
    },
    {
      "'",
      "'",
      suround = true,
      cond = function(fn)
        return not fn.in_lisp() or fn.in_string()
      end,
      alpha = true,
      nft = { 'tex', 'TelescopePrompt' },
      multiline = false,
    },
    { '`', '`', nft = { 'tex', 'latex' }, multiline = false },
    { '``', "''", ft = { 'tex' } },
    { '```', '```', newline = true, ft = { 'markdown' } },
    { '<!--', '-->', ft = { 'markdown', 'html' } },
    { '"""', '"""', newline = true, ft = { 'python' } },
    { "'''", "'''", newline = true, ft = { 'python' } },
  },
  config_internal_pairs = {
    -- { '"', '"', fly = true },
    -- { "'", "'", fly = true },
    { '`', '`', newline = true },
    { '(', ')', suround = true },
  },
}

local experimental = {}
-- extensions={
--     {'cmdtype',{'/','?','@'}},
--     'multichar',
--     'string',
--     {'treenode',{inside={'comment'}}},
--     {'escape',{filter=true}},
--     'rules',
--     'filetype',
--     {'alpha',{before={"'"}}},
--     {'suround',{'"',"'"}},
--     {'fly',{')','}',']',' ',"'",'"',nofilter=true}},
-- },

-- {|M}.foo('bar') > {M.foo('bar')|}
local ua = require('ultimate-autopair')
require('ultimate-autopair.core').modes = { 'i', 'c', 'n', 't' }

local configs = {
  ua.extend_default(cfg),
  { profile = require('ultimate-autopair.experimental.terminal').init, { '{', '}' } },
  { profile = require('ultimate-autopair.experimental.matchpair').init },
}

local left = vim.api.nvim_replace_termcodes('<Left>', true, false, true)
table.insert(configs, {
  profile = 'cond',
  rule = function()
    return vim.o.filetype == 'lua'
  end,
  check = function(o)
    return not vim.startswith(o.line, '@')
  end,
  { profile = 'map', { 'i', '(', '()' .. left } },
  { profile = 'map', { 'i', '"', '""' .. left } },
})
ua.init(configs)

-- table.insert(ua.configs, {
--   profile = 'map',
--   { 'i', '(', '()' },
--   {
--     { 'i', 'c' },
--     ')',
--     function(o, m)
--       return o.linenr
--     end,
--     p = 20,
--   },
-- })

-- dev debug
--  `ua._list`
-- dev testing
-- ` _G.UA_DEV=true` for dev testing (and `_G.UA_DEV='ok'`

-- ua.list, ua.toggle,
-- require('ultimate-autopair.core').modes = { 'i', 'c', 'n' }
-- require('ultimate-autopair').setup(cfg)

-- require('ultimate-autopair').init({ cfg, { profile = require('ultimate-autopair.experimental.matchpair').init } })

-- filetype = 'noice'
-- config_internal_pairs = {
--   { '(', ')', nft = { filetype } },
--   { '{', '}', nft = { filetype } },
--   { '[', ']', nft = { filetype } },
-- }
--  Example (`*` is cursor)(n
-- | before     | after
-- |------------+------------
-- | (*){}      | (*{})
-- | (*){foo}   | (*{foo})
-- | (*)foo     | (*foo)
-- | (foo*),bar | (foo,bar*)

-- ext-fly
-- | ({[*] }) | )   | ({[] })* |                          |
-- | *()      | )   | ()*      | only_jump_end_pair=false |
-- close
-- | before | after |
-- |--------+-------|
-- | (*     | (*)   |
-- | ({*    | ({*}) |
-- | (*)    | (*)   |
-- | "*     | "*"   |

-- cr
-- | before | after  | config    |
-- |--------+--------+-----------|
-- | {*}    | {      |           |
-- |        | \t*    |           |
-- |        | }      |           |
-- |--------+--------+-----------|
-- | {*     | {      | autoclose |
-- |        | \t*    |           |
-- |        | }      |           |
-- |--------+--------+-----------|
-- | {foo*} | {foo   |           |
-- |        | \t*    |           |
-- |        | }      |           |
-- |--------+--------+-----------|
-- | {*foo} | {      |           |
-- |        | \t*foo |           |
-- |        | }      |           |

-- {(*)} > fastwarp > {(}*)
-- (*) > fastwarp > (\n*)
-- {(*)} > fastwarp > {(}|)
-- {*}M.foo('bar') > {M.foo('bar')|} (faster=true)

-- ext-surround
-- | before | key | after  |
-- |--------+-----+--------|
-- | *'a'   | (   | (*'a') |
-- local configs = {
--   upair.extend_default({
--     --space2={enable=true},
--     bs = { space = 'balance', indent_ignore = true, single_delete = true, map = { '<C-w>', '<bs>' } },
--     cr = { autoclose = true },
--     fastwarp = {
--       multi = true,
--       {},
--       {
--         faster = true,
--         map = '<C-A-e>',
--         cmap = '<C-A-e>',
--         rmap = '<C-A-S-e>',
--         rcmap = '<C-A-S-e>',
--       },
--     },
--     tabout = { enable = true, hopout = true },
--     extensions = { cond = { cond = {
--       function(fn)
--         return not fn.in_macro()
--       end,
--     } } },
--     { '<<', '>>', newline = true, dosuround = true }, --For testing
--     { '*', '*', multiline = false, ft = { 'markdown' } },
--     { '**', '**', multiline = false, ft = { 'markdown' } },
--     { '$', '$', multiline = false, ft = { 'markdown' } },
--     config_internal_pairs = { {
--       '[',
--       ']',
--       cond = function(_, o)
--         return o.line:sub(o.col - 4, o.col) ~= '\\x1b'
--       end,
--     } },
--   }),
--   { profile = require('ultimate-autopair.experimental.terminal').init, { '{', '}' } },
--   { profile = require('ultimate-autopair.experimental.matchpair').init },
-- }
