local function get_diagnostic_label(props)
  local icons = {
    Error = ' ', --   𥉉﮻  ﱥ           
    Warn = ' ', --   
    Info = ' ', --        ﯧ ﯦ  ﯧ  כֿ
    Hint = ' ', --  𥉉    ﴕ       
  }
  local label = {}
  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
    end
  end
  return label
end

local hl = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
local bg = string.format('#%06x', 1842980)
local fg = string.format('#%06x', hl.fg)

--             █                 █  
local cfg = {
  hide = {
    cursorline = false,
    focused_win = false,
    only_win = false,
  },
  -- debounce_threshold = { falling = 500, rising = 250 },
  render = function(props)
    if props.focused then
      local bufname = vim.api.nvim_buf_get_name(props.buf)
      local filename = vim.fn.fnamemodify(bufname, ':t')
      local diagnostics = get_diagnostic_label(props)
      local buf_modified = vim.api.nvim_buf_get_option(props.buf, 'modified')
      local modified = buf_modified and 'bold,italic' or 'None'
      local filetype_icon, color = require('nvim-web-devicons').get_icon_color(filename)
      local buffer = {
        { filetype_icon, guifg = color },
        { ' ' },
        { filename, gui = modified, guifg = buf_modified and '#aa7873' or 'none' },
      }
      if #diagnostics > 0 then
        table.insert(diagnostics, { '| ', guifg = 'grey' })
      end
      for _, buffer_ in ipairs(buffer) do
        table.insert(diagnostics, buffer_)
      end
      return {
        { '', guifg = bg },
        -- { '', guifg = bg, guibg = 'none' },
        -- { '', guifg = bg },
        {
          diagnostics,
          guibg = bg,
        },
        { '█', guifg = bg },
      }
    end
    return nil
  end,
  window = {
    padding = 0,
    options = {
      signcolumn = 'no',
      focusable = false,
      winblend = 0,
    },
    margin = {
      horizontal = 0,
      vertical = 0,
    },
    zindex = 30,
    -- winhighlight = {
    --   active = {
    --     EndOfBuffer = 'None',
    --     Normal = 'InclineNormal',
    --     Search = 'None',
    --   },
    --   inactive = {
    --     EndOfBuffer = 'None',
    --     Normal = 'InclineNormalNC',
    --     Search = 'None',
    --   },
    -- },
  },
  ignore = {
    filetypes = { 'alpha', 'noice' },
    -- floating_wins = false,
  },
  highlight = {
    -- groups = {
    --   InclineNormal = {
    --     default = true,
    --     group = 'NormalFloat',
    --   },
    --   InclineNormalNC = {
    --     default = true,
    --     group = 'NormalFloat',
    --   },
    -- },
    -- groups = {
    --   InclineNormal = { guibg = 'none', guifg = 'none' },
    --   InclineNormalNC = { guibg = 'none', guifg = 'none' },
    -- },
  },
}

require('incline').setup(cfg)
