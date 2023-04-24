---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
local ls = require('luasnip') -- {{{
local luasnip_utils = require('utils.luasnip')
local cs = luasnip_utils.create_snippet
local s = ls.s -- > snippet
local i = ls.i -- > insert node
local t = ls.t -- > text node
local fmt = require('luasnip.extras.fmt').fmt

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node

local snippets, autosnippets = {}, {}

-------------------------------------------------------------------------

cs({
  trigger = { trig = 'hello', priority = 200, docstring = 'what the fuck' },
  nodes = fmt(
    [=[
hello {}
]=],
    { i(1, 'world') }
  ),
  target_table = snippets,
  pattern = { '*.lua' },
  keymaps = { '<C-j>h' },
})

cs({
  trigger = 'range',
  nodes = fmt(
    [=[
start_row, start_col, end_row, end_col
]=],
    {}
  ),
  target_table = snippets,
})

cs({
  trigger = 'input',
  nodes = fmt(
    [=[
{}.{}.{}({{
    {} = "{}",
}}, function({})
    -- TODO:
end)
]=],
    { i(1, 'vim'), i(2, 'ui'), i(3, 'input'), i(4, 'prompt'), i(5, 'Input Prompt'), i(6, 'input') }
  ),
  target_table = snippets,
})

cs({
  trigger = 'args',
  nodes = fmt(
    [=[
local {} = {{
    {} = {},
    {} = {},
    {} = {}.{}({}, "{}"),
}}
]=],
    {
      i(1, 'args'),
      i(2, 'trigger'),
      i(3, 'trigger'),
      i(4, 'body'),
      i(5, 'body_text'),
      i(6, 'nodes'),
      i(7, 'table'),
      i(8, 'concat'),
      i(9, 'insert_nodes'),
      i(10, '\\n'),
    }
  ),
  target_table = snippets,
})

cs({
  trigger = 'highlight',
  nodes = fmt(
    [=[
{}.{}.{}(
    0,
    {},
    {},
    {{ {} - 1, {} - 1 }},
    {{ {} - 1, {} }},
    {{ {} = 1000 }}
)
]=],
    {
      i(1, 'vim'),
      i(2, 'highlight'),
      i(3, 'range'),
      i(4, 'ns'),
      i(5, 'hl_group'),
      i(6, 'start_row'),
      i(7, 'start_col'),
      i(8, 'end_row'),
      i(9, 'end_col'),
      i(10, 'priority'),
    }
  ),
  target_table = snippets,
})

-- TODO: convert to create snippet
ls.add_snippets('lua', {
  s( -- Ignore stylua {{{
    { trig = 'ignore', name = 'Ignore Stylua' },
    fmt('-- stylua: ignore {}\n{}', { ls.c(1, { ls.t('start'), ls.t('end') }), ls.i(0) })
  ), -- }}}
  s( -- Function {{{
    { trig = 'fn', dsce = 'create a function' },
    fmt(
      [[
      {} {}({})
        {}
      end
    ]],
      { ls.c(1, { ls.t('function'), ls.t('local function') }), ls.i(2), ls.i(3), ls.i(0) }
    )
  ), -- }}}

  s( -- Require Module {{{
    { trig = 'req', name = 'Require', dscr = 'Choices are on the variable name' },
    fmt([[local {} = require("{}")]], { d(2, last_lua_module_section, { 1 }), ls.i(1) })
  ), -- }}}

  -- Start Refactoring --
  s('CMD', { -- [CMD] multiline vim.cmd{{{
    t({ 'vim.cmd[[', '  ' }),
    i(1, ''),
    t({ '', ']]' }),
  }), -- }}}
  s('cmd', fmt('vim.cmd[[{}]]', { i(1, '') })), -- single line vim.cmd
  s({ -- github import for packer{{{
    trig = 'https://github%.com/([%w-%._]+)/([%w-%._]+)!',
    regTrig = true,
    hidden = true,
  }, {
    t([[use "]]),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t('/'),
    f(function(_, snip)
      return snip.captures[2]
    end),
    t({ [["]], '' }),
    i(1, ''),
  }), -- }}}
  s( -- {regexSnippet} LuaSnippet{{{
    'regexSnippet',
    fmt(
      [=[
cs( -- {}
{{ trig = "{}", regTrig = true, hidden = true }}, fmt([[
{}
]], {{
  {}
}}))
      ]=],
      { i(1, 'Description'), i(2, ''), i(3, ''), i(4, '') }
    )
  ), -- }}}
  s( -- [luaSnippet] LuaSnippet{{{
    'luaSnippet',
    fmt(
      [=[
cs("{}", fmt( -- {}
[[
{}
]], {{
  {}
  }}){})
    ]=],
      {
        i(1, ''),
        i(2, 'Description'),
        i(3, ''),
        i(4, ''),
        c(5, {
          t(''),
          fmt([[, "{}"]], { i(1, 'keymap') }),
          fmt([[, {{ pattern = "{}", {} }}]], { i(1, '*/snippets/*.lua'), i(2, 'keymap') }),
        }),
      }
    )
  ), -- }}}

  s( -- choice_node_snippet luaSnip choice node{{{
    'choice_node_snippet',
    fmt(
      [[
c({}, {{ {} }}),
]],
      { i(1, ''), i(2, '') }
    )
  ), -- }}}
  s( -- [function] Lua function snippet{{{
    'function',
    fmt(
      [[
function {}({})
  {}
end
]],
      { i(1, ''), i(2, ''), i(3, '') }
    )
  ), -- }}}
  s( -- [local_function] Lua function snippet{{{
    'local_function',
    fmt(
      [[
local function {}({})
  {}
end
]],
      { i(1, ''), i(2, ''), i(3, '') }
    ),
    'jlf'
  ), -- }}}
  s( -- [local] Lua local variable snippet{{{
    'local',
    fmt(
      [[
local {} = {}
  ]],
      { i(1, ''), i(2, '') }
    ),
    'jj'
  ), -- }}}
})

-- automatic snippet for if enclosure
ls.add_snippets('lua', {
  s(
    {
      trig = 'if',
      condition = function()
        local ignored_nodes = { 'string', 'comment' }

        local pos = vim.api.nvim_win_get_cursor(0)
        -- Use one column to the left of the cursor to avoid a "chunk" node
        -- type. Not sure what it is, but it seems to be at the end of lines in
        -- some cases.
        local row, col = pos[1] - 1, pos[2] - 1

        local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()

        return not vim.tbl_contains(ignored_nodes, node_type)
      end,
    },
    fmt(
      [[
if {} then
  {}
end
  ]],
      { i(1), i(2) }
    )
  ),
}, { type = 'autosnippets' })

-------------------------------------------------------------------------

return snippets, autosnippets
