local exclude = {
  buftype = {
    "prompt",
    "nofile",
    "quickfix",
    "nofile",
  },
  ft = {
    "TelescopePrompt",
    "alpha",
    "dap.*",
    "dashboard",
    "DressingInput",
    "help",
    "mason",
    "neo-tree",
    "noice",
    "NoiceCommandline",
    "notify",
    "oil",
    "packer",
    "qf",
    "spectre_panel",
    "startify",
    "tablegen",
    "tsplayground",
  },
}

local cfg = {
  profile = "default",
  map = true,
  cmap = false, -- disable in command mode
  pair_map = true,
  pair_cmap = false,
  multiline = true,
  cr = {
    enable = true,
    map = "<cr>", --string or table
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
    map = "<bs>", --string or table
    cmap = "<bs>", --string or table
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
    map = "<C-]>", --string or table
    cmap = "<C-]>", --string or table
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
    {
      faster = true,
      nocursormove = true,
      map = "<C-0>",
      rmap = "<C-9>",
      cmap = "<C-0>",
      rcmap = "<C-9>",
    },
    {
      faster = false,
      nocursormove = true,
      map = "<M-)>",
      rmap = "<M-(>",
      cmap = "<M-)>",
      rcmap = "<M-(>",
    },
    {
      faster = false,
      nocursormove = false,
      map = "<M-0>",
      rmap = "<M-9>",
      cmap = "<M-0>",
      rcmap = "<M-9>",
    },
    -- {
    --   faster = true,
    --   nocursormove = true,
    --   map = "<M-'>",
    --   rmap = '<M-;>',
    --   cmap = "<M-'>",
    --   rcmap = '<M-;>',
    -- },
    -- {
    --   faster = true,
    --   nocursormove = true,
    --   map = '<M-.>',
    --   rmap = '<M-,>',
    --   cmap = '<M-.>',
    --   rcmap = '<M-,>',
    -- },
    -- which nodes to skip for tsnode filtering
    conf = {},
  },
  tabout = { -- *ultimate-autopair-map-tabout-config*
    enable = true,
    map = "<Tab>", --string or table
    cmap = "<Tab>", --string or table
    hopout = false,
    conf = {
      -- tabkey = '', -- key to trigger tabout, set to an empty string to disable
      -- backwards_tabkey = '', -- key to trigger backwards tabout, set to an empty string to disable
      tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = false,
      act_as_shift_tab = false,
      ignore_beginning = true,
    },
  },
  space = {
    enable = true,
    map = " ", --string or table
    cmap = " ", --string or table
    check_box_ft = { "markdown", "vimwiki" },
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
  { "[=[", "]=", ft = { "lua" } },
  {
    "[=[",
    "]=]",
    ft = { "lua" },
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
    --         local status, node =
    --           pcall(vim.treesitter.get_node, { pos = { o.linenr - 1, o.col - 2 } })
    --         return o.incmd
    --           or o.col == 1
    --           or not status
    --           or not node
    --           or node:type() ~= 'comment' and node:type() ~= 'html_block'
    --       end,
    --     },
    --   },
    -- },
    cmdtype = { skip = { "/", "?", "@", "-", ":" }, p = 100 },
    escape = { filter = true, p = 80 },
    utf8 = { p = 70 },
    -- { 'treenode', { inside = { 'comment' } } },
    tsnode = {
      p = 60,
      separate = {
        -- 'comment',
        "string",
        "char",
        "character",
        "raw_string", --fish/bash/sh
        "char_literal",
        "string_literal", --c/cpp
        "string_value", --css
        "str_lit",
        "char_lit", --clojure/commonlisp
        "interpreted_string_literal",
        "raw_string_literal",
        "rune_literal", --go
        "quoted_attribute_value", --html
        "template_string", --javascript
        "LINESTRING",
        "STRINGLITERALSINGLE",
        "CHAR_LITERAL", --zig
        "string_literals",
        "character_literal",
        "line_comment",
        "block_comment",
        "nesting_block_comment", --d #62
      },
      outside = { "comment" },
    },
    cond = {
      cond = {
        function(fn)
          return not fn.in_macro()
            and not fn.in_node("comment")
            and not vim.tbl_contains(exclude.buftype, vim.bo.buftype)
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
    filetype = { p = 90, nft = exclude.ft, tree = true },
    -- Get Fly Mode working on strings: https://github.com/altermo/ultimate-autopair.nvim/issues/17
    -- {'fly',{')','}',']',' ',"'",'"',nofilter=true}},
    fly = {
      other_char = { " " },
      nofilter = true, -- get it working on strings
      p = 10,
      -- only_jump_end_pair = false,
      undomapconf = {},
      -- undomap = '<BS>',
      -- undocmap = '<BS>',
      -- undomap = '<M-BS>',
      -- undocmap = '<M-BS>',
    },
  },
  { "*", "*", multiline = false, ft = { "markdown" } },
  { "**", "**", multiline = false, ft = { "markdown" } },
  { "$", "$", multiline = false, ft = { "markdown" } },
  internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
    { "[", "]", fly = true, dosuround = true, newline = true, space = true },
    {
      "(",
      ")",
      fly = true,
      dosuround = true,
      newline = true,
      space = true,
    },
    { "{", "}", fly = true, dosuround = true, newline = true, space = true },
    {
      '"',
      '"',
      suround = true,
      multiline = false,
    },
    {
      "'",
      "'",
      suround = true,
      cond = function(fn)
        return not fn.in_lisp() or fn.in_string()
      end,
      alpha = true,
      multiline = false,
    },
    -- **|** --> press backspace --> |**
    { "*", "*", ft = { "markdown" }, disable_start = true, disable_end = true },
    { "`", "`", nft = { "tex", "latex" }, multiline = false },
    { "``", "''", ft = { "tex" } },
    { "```", "```", ft = { "markdown" }, newline = true },
    { "<!--", "-->", ft = { "markdown", "html" } },
    { '"""', '"""', newline = true, ft = { "python" } },
    { "'''", "'''", newline = true, ft = { "python" } },
  },
  config_internal_pairs = {
    -- { '"', '"', fly = true },
    -- { "'", "'", fly = true },
    { "`", "`", newline = true },
    { "(", ")", suround = true },
  },
}

local create_undo_map = function(key)
  return {
    "i",
    key,
    function()
      return vim.api.nvim_replace_termcodes(key .. "<C-g>u", true, true, true)
    end,
  }
end

require("ultimate-autopair").init({
  require("ultimate-autopair").extend_default(cfg),
  {
    profile = "map",
    p = -1,
    create_undo_map(" "),
    create_undo_map("-"),
    create_undo_map("_"),
    create_undo_map(":"),
    create_undo_map("."),
    create_undo_map("/"),
  },
  {
    -- profile = require("ultimate-autopair.experimental.cmpair").init,
  },
})

-- local cmp = require('cmp')
-- local ind = cmp.lsp.CompletionItemKind
--
-- local function ls_name_from_event(event)
--   return event.entry.source.source.client.config.name
-- end
--
-- -- Add parenthesis on completion confirmation
-- cmp.event:on('confirm_done', function(event)
--   local ok, ls_name = pcall(ls_name_from_event, event)
--   if ok and vim.tbl_contains({ 'rust_analyzer', 'lua_ls' }, ls_name) then
--     return
--   end
--
--   local completion_kind = event.entry:get_completion_item().kind
--   if vim.tbl_contains({ ind.Function, ind.Method }, completion_kind) then
--     local left = vim.api.nvim_replace_termcodes('<Left>', true, true, true)
--     vim.api.nvim_feedkeys('()' .. left, 'n', false)
--   end
-- end)

-- require('configs.ultimate-autopair.esc-disable')

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
--     {'fly',{')','}',']',' ',"'",'"',nofilter=t
