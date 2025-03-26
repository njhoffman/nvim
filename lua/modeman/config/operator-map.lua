local opfuncs = {
  ["v:lua.MiniAlign.align_user"] = { { "ga" }, "align content " },

  ['v:lua.require"treesj".__repeat'] = { { "gs", "gJ" }, "split/join content " },
  ['v:lua.require"ts-node-action.repeat".repeat_action'] = { { "+" }, "do node action  " },

  ["v:lua.MiniSurround.add"] = { { "s" }, "surround add 󰅪" },
  ["v:lua.MiniSurround.find"] = { { "sf", "sF" }, "surround find 󰅪" },
  ["v:lua.MiniSurround.replace"] = { { "cs" }, "surround replace 󰅪" },
  ["v:lua.MiniSurround.delete"] = { { "ds" }, "surround delete 󰅪" },

  -- [''] = {
  --   { 'cr' },
  --   'change remote object',
  -- },
  -- [''] = {
  --   { 'dr' },
  --   'delete remote object',
  -- },
  ['v:lua.require"textcase".operator_callback'] = {
    { "gtoc", "gtod", "gtoD", "gtof", "gton", "gtop", "gtoP", "gtos", "gtot", "gtou", "gtoU" },
    "change text case  ",
  },

  ['v:lua.require"substitute".operator_callback'] = { { "S" }, "substitute  " },
  ['v:lua.require"substitute.exchange".operator_callback'] = { { "X", "cx" }, "exchange  " },

  ['v:lua.require"Comment.api".locked"toggle.blockwise"'] = { { "gb" }, "comments (block)  " },

  -- ['v:lua.MiniComment.operator'] = {
  ['v:lua.require"Comment.api".locked"toggle.linewise"'] = { { "gc" }, "comments (line)  " },
  -- v:lua.require"Comment.api".locked"toggle.linewise.count_repeat"
  ['v:lua.require"Comment.api".locked"toggle.linewise.current"'] = {
    { "gcc" },
    "comments (line)  ",
  },
  -- v:lua.require"Comment.api".locked"toggle.blockwise.count_repeat"
  ['v:lua.require"Comment.api".locked"toggle.blockwise.current"'] = {
    { "gcb" },
    "comments (block)  ",
  },

  ['v:lua.require"debugprint".debugprint_motion_callback'] = { { "goo" }, "debugprint out t" },
  -- v:lua.require'" .. constants.namespace .. "'.operator_callback" (textcase.nvim)
  -- v:lua.MiniBasics.put_empty_line
  -- v:lua.MiniSurround.replace
  -- v:lua.MiniSplitjoin.operator
  -- v:lua.MiniComment.operator
  -- v:lua.__remote_op_opfunc
  -- v:lua.require'flash.repeat'._repeat
  -- v:lua.require'gitsigns.repeat'.repeat_action
  -- v:lua.require'refactoring'.debug.printf_operatorfunc
  -- v:lua.require'stay-in-place'.operator_callback
  -- v:lua.require'stringcase.range'.selection_operator_callback
  -- v:lua.require'substitute.range'.operator_callback
  -- v:lua.require'ts-node-action.repeat'.repeat_action
  -- v:lua.require'utils.escape.operatorfunc'.operatorfunc
  -- cr (subvert): <SNR>228_coerce  <SNR>230_coerce
  --   c:  camelCase         p:  PascalCase    m:  MixedCase (PascalCase)
  --   _:  snake_case        s:  snake_case    u:  SNAKE_UPPERCASE       .:  dot.case
  --   U:  SNAKE_UPPERCASE   k:  kebab-case    -:  dash-case (kebab-case)
  --
}

return opfuncs
