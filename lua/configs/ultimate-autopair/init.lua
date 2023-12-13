local cfg = {
  profile = 'default',
  map = true,
  cmap = true,
  pair_map = true,
  pair_cmap = true,
  multiline = true,
  cr = { -- *ultimate-autopair-map-newline-config*
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
  bs = { -- *ultimate-autopair-map-backspace-config*
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
    enable = true,
    map = '<M-)>', --string or table
    cmap = '<M-)>', --string or table
  },
  fastwarp = {
    enable = true,
    enable_normal = true,
    enable_reverse = true,
    hopout = false,
    map = '<M-0>', --string or table
    rmap = '<M-9>', --string or table
    cmap = '<M-0>', --string or table
    rcmap = '<M-9>', --string or table
    multiline = true,
    nocursormove = false,
    do_nothing_if_fail = true,
    -- no_filter_nodes = { 'string', 'raw_string', 'string_literals', 'character_literal' },
    multi = false,
    faster = false,
    conf = {},
  },
  tabout = { -- *ultimate-autopair-map-tabout-config*
    enable = true,
    map = '<Tab>', --string or table
    cmap = '<Tab>', --string or table
    hopout = true,
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
  internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
    { '[', ']', fly = true, dosuround = true, newline = true, space = true },
    { '(', ')', fly = true, dosuround = true, newline = true, space = true },
    { '{', '}', fly = true, dosuround = true, newline = true, space = true },
    { '"', '"', suround = true, multiline = false },
    {
      "'",
      "'",
      suround = true,
      cond = function(fn)
        return not fn.in_lisp() or fn.in_string()
      end,
      alpha = true,
      nft = { 'tex' },
      multiline = false,
    },
    -- { '`', '`', nft = { 'tex', 'latex' }, multiline = false },
    { '``', "''", ft = { 'tex' } },
    { '```', '```', newline = true, ft = { 'markdown' } },
    { '<!--', '-->', ft = { 'markdown', 'html' } },
    { '"""', '"""', newline = true, ft = { 'python' } },
    { "'''", "'''", newline = true, ft = { 'python' } },
  },
  extensions = {
    cmdtype = { skip = { '/', '?', '@', '-' }, p = 100 },
    escape = { filter = true, p = 80 },
    utf8 = { p = 70 },
    tsnode = {
      p = 60,
      separate = {
        'comment',
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
    },
    cond = { p = 40, filter = true },
    alpha = { p = 30, filter = false, all = false },
    suround = { p = 20 },
    filetype = { p = 90, nft = { 'TelescopePrompt', 'Noice', 'noice' }, tree = true },
    fly = {
      other_char = { ' ' },
      nofilter = false,
      p = 10,
      undomapconf = {},
      undomap = nil,
      undocmap = nil,
      only_jump_end_pair = false,
    },
  },
}
-- {|M}.foo('bar') > {M.foo('bar')|}

require('ultimate-autopair.core').modes = { 'i', 'c', 'n' }
require('ultimate-autopair').setup(cfg)
-- require('ultimate-autopair').init({ cfg, { profile = require('ultimate-autopair.experimental.matchpair').init } })

-- filetype = 'noice'
-- config_internal_pairs = {
--   { '(', ')', nft = { filetype } },
--   { '{', '}', nft = { filetype } },
--   { '[', ']', nft = { filetype } },
-- }
-- | before     | after
-- |------------+------------
-- | (*){}      | ({}*)
-- | (*){foo}   | ({foo}*)
-- | (*)foo     | (foo*)
-- | (foo*),bar | (foo,bar*)
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

-- {(|)} > fastwarp > {(}|)
-- (|) > fastwarp > (\n|)
-- (|) > fastwarp > (\n|)
-- {(|)} > fastwarp > {(}|)
-- {|M}.foo('bar') > {M.foo('bar')|}

-- ext-surround
-- | before | key | after  |
-- |--------+-----+--------|
-- | *'a'   | (   | (*'a') |
