local config = require('registers.config')
local state = require('registers.state')

---@private
---Register the highlights.
local _define_highlights = function()
  local options = config.get()

  -- Set the namespace for the highlights on the window, if we're running an older neovim version make it global
  ---@type integer|string
  local namespace = 0
  if vim.fn.has('nvim-0.8.0') == 1 then
    namespace = state._namespace
    vim.api.nvim_win_set_hl_ns(state._window, namespace)
  end

  -- Define the matches and link them
  -- vim.cmd([[syntax match RegistersNumber "\d\+"]])
  vim.cmd([[syntax match RegistersNumber "[-+]\?\d\+\.\?\d*"]])
  vim.api.nvim_set_hl(namespace, 'RegistersNumber', { link = 'Number' })

  vim.cmd([[syntax region RegistersString start=+"+ skip=+\\"+ end=+"+ oneline]])
  vim.cmd([[syntax region RegistersString start=+'+ skip=+\\'+ end=+'+ oneline]])
  vim.api.nvim_set_hl(namespace, 'RegistersString', { link = 'String' })

  -- space between register symbol and contents
  vim.api.nvim_set_hl(namespace, 'RegistersSignColumn', { link = 'SignColumn' })
  -- space between register symbol and contents but for only current line
  vim.api.nvim_set_hl(namespace, 'RegistersStringCursorLineSign', { link = 'CursorLine' })

  -- ⏎
  vim.cmd([[syntax match RegistersWhitespace "\%u23CE"]])
  -- ⎵
  vim.cmd([[syntax match RegistersWhitespace "\%u23B5"]])
  -- ·
  vim.cmd([[syntax match RegistersWhitespace "\%u00B7"]])
  vim.cmd([[syntax match RegistersWhitespace " "]])
  vim.api.nvim_set_hl(namespace, 'RegistersWhitespace', { link = 'Comment' })

  vim.cmd([[syntax match RegistersEscaped "\\\w"]])
  vim.cmd([[syntax keyword RegistersEscaped \.]])
  vim.api.nvim_set_hl(namespace, 'RegistersEscaped', { link = 'Special' })

  -- Empty region
  local function hl_symbol(type, symbols, group)
    local name = 'RegistersSymbol_' .. group
    if type == 'match' then
      vim.cmd(('syntax match %s %q contained'):format(name, symbols))
    else
      vim.cmd(('syntax %s %s %s contained'):format(type, name, symbols))
    end
    vim.api.nvim_set_hl(namespace, name, { link = options.sign_highlights[group] })
  end

  vim.api.nvim_set_hl(namespace, 'SignColumn', { link = options.sign_highlights['signcolumn'] })
  vim.api.nvim_set_hl(namespace, 'CursorLineSign', { link = options.sign_highlights['cursorlinesign'] })

  hl_symbol('match', '[*+]', 'selection')
  hl_symbol('match', '\\"', 'default')
  hl_symbol('match', '\\\\', 'unnamed')
  hl_symbol('match', '[:.%]', 'read_only')
  hl_symbol('match', '_', 'black_hole')
  hl_symbol('match', '=', 'expression')
  hl_symbol('match', '#', 'alternate_buffer')
  hl_symbol('match', '\\/', 'last_search')
  hl_symbol('match', '-', 'delete')
  hl_symbol('keyword', '0', 'yank')
  hl_symbol('keyword', '1 2 3 4 5 6 7 8 9', 'history')
  hl_symbol('keyword', 'a b c d e f g h i j k l m n o p q r s t u v w x y z', 'named')

  vim.cmd([[syntax match RegistersEmptyString "Empty: " contained]])

  vim.cmd([[syntax region RegistersEmpty start="^Empty: " end="$" contains=RegistersSymbol.*,RegistersEmptyString]])
end

---@private
---The highlight group from the options for the sign.
---@param register string Which register to get the highlight group for
---@return string Highlight group
---@nodiscard
local _highlight_for_sign = function(register)
  local options = config.get()

  local hl = options.sign_highlights

  return ({
    ['*'] = hl.selection,
    ['+'] = hl.selection,
    ['"'] = hl.default,
    ['\\'] = hl.unnamed,
    [':'] = hl.read_only,
    ['.'] = hl.read_only,
    ['%'] = hl.read_only,
    ['/'] = hl.last_search,
    ['-'] = hl.delete,
    ['_'] = hl.black_hole,
    ['='] = hl.expression,
    ['#'] = hl.alternate_buffer,
    ['0'] = hl.yank,
    ['1'] = hl.history,
    ['2'] = hl.history,
    ['3'] = hl.history,
    ['4'] = hl.history,
    ['5'] = hl.history,
    ['6'] = hl.history,
    ['7'] = hl.history,
    ['8'] = hl.history,
    ['9'] = hl.history,
    a = hl.named,
    b = hl.named,
    c = hl.named,
    d = hl.named,
    e = hl.named,
    f = hl.named,
    g = hl.named,
    h = hl.named,
    i = hl.named,
    j = hl.named,
    k = hl.named,
    l = hl.named,
    m = hl.named,
    n = hl.named,
    o = hl.named,
    p = hl.named,
    q = hl.named,
    r = hl.named,
    s = hl.named,
    t = hl.named,
    u = hl.named,
    v = hl.named,
    w = hl.named,
    x = hl.named,
    y = hl.named,
    z = hl.named,
  })[register]
end

return {
  _define_highlights = _define_highlights,
  _highlight_for_sign = _highlight_for_sign,
}
