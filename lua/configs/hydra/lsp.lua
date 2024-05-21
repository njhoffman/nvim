local Hydra = require('hydra')
-- local popup = require("configs.hydra.popup")
local levels = require('configs.hydra.lsp_levels')
local utils = require('configs.hydra.lsp_utils')
local hints = [[
                     LSP OPTIONS
    ────────────────────────────────────────────    ^
  _d_ %{buffer} diag buffer       _D_ %{global} diag global
  _f_ %{format} format on write   _i_ %{insert} diag on insert
  _s_ %{s_toggle} signs             _S_ %{s_level} signs level
  _u_ %{ul_toggle} underline         _U_ %{ul_level} underline level
  _v_ %{vt_toggle} virtual text      _V_ %{vt_level} virtual text level
  _z_ %{vl_toggle} virtual lines     _Z_ %{vl_level} virtual lines level
  _l_ %{vl_current} vlines current
  ^                                     _<Esc>_
]]

local hydra_level = function(type)
  return function()
    local ret = levels.hydra(type)
    vim.schedule(function()
      ret:activate()
    end)
  end
end

local heads = {
  { 'd', utils.toggle_diagnostic('buffer'), { desc = 'enabled buffer' } },
  { 'D', utils.toggle_diagnostic('global'), { desc = 'enabled global' } },
  { 'i', utils.toggle_diagnostic('update_in_insert'), { desc = 'update in insert' } },
  { 'f', utils.toggle_diagnostic('format'), { desc = 'format on write' } },
  { 's', utils.toggle_diagnostic('signs'), { desc = 'signs toggle' } },
  { 'S', hydra_level('signs'), { desc = 'signs level', exit = true } },
  { 'v', utils.toggle_diagnostic('virtual_text'), { desc = 'virtual text toggle' } },
  { 'V', hydra_level('virtual_text'), { desc = 'virtual text level', exit = true } },
  { 'u', utils.toggle_diagnostic('underline'), { desc = 'underline toggle' } },
  { 'U', hydra_level('underline'), { desc = 'underline level', exit = true } },
  { 'l', utils.toggle_diagnostic('vl_current'), { desc = 'virtual lines only current' } },
  { 'z', utils.toggle_diagnostic('virtual_lines'), { desc = 'virtual lines toggle' } },
  { 'Z', hydra_level('virtual_lines'), { desc = 'virtual lines level', exit = true } },
  { '<Esc>', nil, { exit = true } },
}

local toggles = {
  --    󰄬  󰄭       󰅚 󰙧 
  --            
  yes = '  ',
  no = '  ',
  num = function(num)
    return ' ' .. num .. ' '
  end,
  lvl = function(num)
    return ' ' .. num .. ' '
    -- return '[' .. string.lower(tostring(vim.lsp.log_levels[num])) .. ']'
    -- return string.format("%8s", "[" .. string.lower(tostring(vim.lsp.log_levels[num])) .. "]")
  end,
}

local funcs = {
  buffer = function()
    return vim.diagnostic.is_disabled(0) and toggles.no or toggles.yes
  end,
  global = function()
    return vim.diagnostic.is_disabled() and toggles.no or toggles.yes
  end,
  insert = function()
    return vim.diagnostic.config().update_in_insert and toggles.yes or toggles.no
  end,
  format = function()
    return vim.b.format_on_write == 0 and toggles.no or toggles.yes
  end,
  s_toggle = function()
    local severity = utils.get_severity('signs')
    return severity > 0 and toggles.yes or toggles.no
  end,
  s_level = function()
    local severity = utils.get_severity('signs')
    return toggles.lvl(severity)
  end,
  vt_toggle = function()
    local severity = utils.get_severity('virtual_text')
    return severity > 0 and toggles.yes or toggles.no
  end,
  vt_level = function()
    local severity = utils.get_severity('virtual_text')
    return toggles.lvl(severity)
  end,
  vl_current = function()
    local only_current = vim.tbl_get(vim.diagnostic.config(), 'virtual_lines', 'only_current_line')
    return only_current == true and toggles.yes or toggles.no
  end,
  vl_toggle = function()
    local severity = utils.get_severity('virtual_lines')
    return severity > 0 and toggles.yes or toggles.no
  end,
  vl_level = function()
    local severity = utils.get_severity('virtual_lines')
    return toggles.lvl(severity)
  end,
  ul_toggle = function()
    local severity = utils.get_severity('underline')
    return severity > 0 and toggles.yes or toggles.no
  end,
  ul_level = function()
    local severity = utils.get_severity('underline')
    return toggles.lvl(severity)
  end,
}

local hydra = function()
  return Hydra({
    name = 'LSP',
    hint = hints,
    heads = heads,
    config = {
      color = 'amaranth', -- amaranth, teal, pink, red, blue
      invoke_on_body = true,
      hint = {
        funcs = funcs,
        type = 'window',
        float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          border = 'rounded',
          style = 'minimal',
          focusable = false,
          noautocmd = true,
        },
        position = 'middle',
      },
      on_enter = function()
        vim.schedule_wrap(vim.cmd('VimadeBufDisable'))
        -- local curr_buf = vim.fn.bufnr('%')
        -- vim.api.nvim_buf_set_var(curr_buf, 'vimade_disabled', value)
      end,
      on_exit = function()
        vim.schedule_wrap(vim.cmd('VimadeBufEnable'))
      end,
    },
    mode = { 'n', 'x' },
    body = '<leader>!l',
  })
end

return { hydra = hydra }
