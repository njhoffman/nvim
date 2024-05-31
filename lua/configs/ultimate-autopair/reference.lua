---Record previous cmdline completion types,
---`cmdcompltype[1]` is the current completion type,
---`cmdcompltype[2]` is the previous completion type
---@type string[]
local compltype = {}

vim.api.nvim_create_autocmd('CmdlineChanged', {
  desc = 'Record cmd compltype to determine whether to autopair.',
  group = vim.api.nvim_create_augroup('AutopairRecordCmdCompltype', {}),
  callback = function()
    local type = vim.fn.getcmdcompltype()
    if compltype[1] == type then
      return
    end
    compltype[2] = compltype[1]
    compltype[1] = type
  end,
})

---Get next two characters after cursor, whether in cmdline or normal buffer
---@return string: next two characters
local function get_next_two_chars()
  local col, line
  if vim.fn.mode():match('^c') then
    col = vim.fn.getcmdpos()
    line = vim.fn.getcmdline()
  else
    col = vim.fn.col('.')
    line = vim.api.nvim_get_current_line()
  end
  return line:sub(col, col + 1)
end

-- Matches strings that start with:
-- keywords: \k
-- opening pairs: (, [, {, \(, \[, \{
local IGNORE_REGEX = vim.regex([=[^\%(\k\|\\\?[([{]\)]=])

require('ultimate-autopair').setup({
  extensions = {
    -- Improve performance when typing fast, see
    -- https://github.com/altermo/ultimate-autopair.nvim/issues/74
    tsnode = false,
    utf8 = false,
    filetype = { tree = false },
    cond = {
      cond = function(f)
        return not f.in_macro()
          -- Disable autopairs if followed by a keyword or an opening pair
          and not IGNORE_REGEX:match_str(get_next_two_chars())
          -- Disable autopairs when inserting a regex,
          -- e.g. `:s/{pattern}/{string}/[flags]` or
          -- `:g/{pattern}/[cmd]`, etc.
          and (not f.in_cmdline() or compltype[1] ~= '' or compltype[2] ~= 'command')
      end,
    },
  },
  { '\\(', '\\)' },
  { '\\[', '\\]' },
  { '\\{', '\\}' },
  { '[=[', ']=]', ft = { 'lua' } },
  { '<<<', '>>>', ft = { 'cuda' } },
  {
    '/*',
    '*/',
    ft = { 'c', 'cpp', 'cuda' },
    newline = true,
    space = true,
  },
  {
    '<',
    '>',
    disable_start = true,
    disable_end = true,
  },
  -- Paring '$' and '*' are handled by snippets,
  -- only use autopair to delete matched pairs here
  {
    '$',
    '$',
    ft = { 'markdown', 'tex' },
    disable_start = true,
    disable_end = true,
  },
  {
    '*',
    '*',
    ft = { 'markdown' },
    disable_start = true,
    disable_end = true,
  },
  {
    '\\left(',
    '\\right)',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left[',
    '\\right]',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left{',
    '\\right}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left<',
    '\\right>',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lfloor',
    '\\right\\rfloor',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lceil',
    '\\right\\rceil',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\vert',
    '\\right\\vert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lVert',
    '\\right\\rVert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lVert',
    '\\right\\rVert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\begin{bmatrix}',
    '\\end{bmatrix}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\begin{pmatrix}',
    '\\end{pmatrix}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
})

-- manual mapping
local core = require('ultimate-autopair.core')
vim.keymap.set('i', '\r', function()
  local key =
    core.run_run(vim.api.nvim_replace_termcodes('<plug>ultimate-autopair-CR', true, true, true))
  if key == vim.api.nvim_replace_termcodes('<plug>ultimate-autopair-CR', true, true, true) then
    vim.api.nvim_feedkeys('\r', 'n', false)
  else
    vim.api.nvim_feedkeys(key, 'n', false)
  end
end)

-- disable for one pair
require('ultimate-autopair').setup({
  {
    '<',
    '>',
    dosuround = function()
      return vim.o.filetype ~= 'rust'
    end,
  },
  --Note: use `config_internal_pairs={...}` if your configuring an builtin pair
})
local upair = require('ultimate-autopair')
local config = upair.extend_default({
  extensions = {
    filetype = { nft = { 'rust' } },
  },
  --your config
})
local other_config = vim.deepcopy(config)
other_config.extensions.filetype.nft = nil
other_config.extensions.filetype.ft = { 'rust' }
other_config.extensions.surround = false
upair.init({ config, other_config })

-- *|*  -> **|**
require('ultimate-autopair').setup({
  { '*', '*', ft = { 'markdown' }, multiline = false },
  { '**', '**', ft = { 'markdown' }, multiline = false },
  { '$', '$', ft = { 'markdown' }, multiline = false },
})

-- adding comma:
-- I could use fastwarp and type {,<A-e> which would move the } to the left of the comma,
-- but it would be nice if I could just type {, and it would result in {}, with the cursor inside the braces.
-- {
--    {*} -- <-- After typing { I would like to be able to add a comma after the automatically added }
--    { "altermo/ultimate-autopair.nvim", opts = {} },
-- },
local function create_map()
  local m = {}
  m.doc = 'ultimate-autopair , map'
  m.p = 10
  m.check = function(o)
    if
      o.mode == 'i'
      and o.key == ','
      and utils.getsmartft(o) == 'lua'
      and o.line:sub(o.col - 1, o.col - 1) == '{'
    then
      local pair, col, row = default.get_pair_and_end_pair_pos_from_start(o, o.col, true)
      if not pair then
        return
      end
      local node = utils.gettsnode(utils._get_o_pos(o, o.col - 1))
      if node and node:type() ~= 'table_constructor' then
        return
      end
      return utils.create_act({
        { 'j', row - o.row },
        { 'home' },
        { 'l', col },
        ',',
        { 'k', row - o.row },
        { 'home' },
        { 'l', o.col - 1 },
      })
    end
  end
  m.get_map = function(mode)
    if mode == 'i' then
      return { ',' }
    end
  end
  return m
end

require('ultimate-autopair').init({
  require('ultimate-autopair').extend_default(your_own_config),
  {
    profile = 'raw',
    create_map(),
  },
})

-- filetype disable specific pairs
-- internal_pairs
require('ultimate-autopair').init({
  '`',
  '`',
  multiline = false,
  cond = function(_fn)
    return not (vim.o.lisp or vim.o.ft ~= 'tex')
  end,
})

require('ultimate-autopair').setup({
  config_internal_pairs = {
    { '`', '`', newline = true },
  },
  extensions = {
    tsnode = false,
  },
})

local pairs = {
  { '[', ']', fly = true, dosuround = true, newline = true, space = true },
  { '(', ')', fly = true, dosuround = true, newline = true, space = true },
  { '{', '}', fly = true, dosuround = true, newline = true, space = true },
  { '<', '>', fly = true, dosuround = true, newline = true, space = true },
  { '"', '"', suround = true, multiline = false, alpha = { 'txt' } },
  {
    "'",
    "'",
    suround = true,
    cond = function(fn)
      return not fn.in_lisp() or fn.in_string()
    end,
    alpha = true,
    nft = { 'tex', 'latex' },
    multiline = false,
  },
  { '`', '`', nft = { 'tex', 'latex' }, multiline = false },
  { '``', "''", ft = { 'tex', 'latex' } },
  { '```', '```', newline = true, ft = { 'markdown' } },
  { '<!--', '-->', ft = { 'markdown', 'html' } },
  { '"""', '"""', newline = true, ft = { 'python' } },
  { "'''", "'''", newline = true, ft = { 'python' } },
}
p.setup({
  {
    '<',
    '>',
    fly = true,
    dosuround = true,
    newline = true,
    space = true,
    cond = function(fn)
      return not fn.in_node({
        'arrow_function',
        'binary_expression',
        'augmented_assignment_expression',
      })
    end,
  },
})

-- cmp integration
local append_parenthesis = function()
  local cmp = require('cmp')
  local kind = cmp.lsp.CompletionItemKind

  local function ls_name_from_event(event)
    return event.entry.source.source.client.config.name
  end

  -- Add parenthesis on completion confirmation
  cmp.event:on('confirm_done', function(event)
    local ok, ls_name = pcall(ls_name_from_event, event)
    local server_blacklist = { 'rust-analyzer', 'lua_ls', 'typst_lsp' }
    if ok and vim.tbl_contains(server_blacklist, ls_name) then
      return
    end

    local completion_kind = event.entry:get_completion_item().kind
    if vim.tbl_contains({ kind.Function, kind.Method }, completion_kind) then
      local left = vim.api.nvim_replace_termcodes('<Left>', true, true, true)
      vim.api.nvim_feedkeys('()' .. left, 'n', false)
    end
  end)
end
