
-- stylua: ignore
local cmdlines = {
  { 'cmdline',     '',   'Vimcmd',         "vim",   "^:"             }, -- "^:%s*"
  { 'visual',      '礪',  'Visual',         "vim",   "^:'<,'>"        },
  { 'filter',      '',   'Shell',          "bash",  "^:!"            }, -- "^:%s*!"    
  { 'lua',         '',   'Lua',            "lua",   "^:lua%s+"       },
  { 'eval_lua',    ' ',  'Inspect Lua',    "lua",   {"^:=%s*", "^:lua%s=%s*"} }, --
  { 'help',        '',   'Help',           "vim",   "^:he?l?p?%s+"   },
  { 'inc_rename',  ' ',  'Rename',         'vim',   '^:RenameInc%s+' },
  { 'preview',     '󰻏 ',  'Preview Command','vim',   '^:Preview%s+'   },
  { 'subs',        '',   'Replace',        'regex', '^:s/'           },
  -- { 'visual',      '礪',  'visual',         "vim",   "^:'<,'>"        },
  { 'subs_all',    ' ',  'Replace Buffer', 'regex', '^:%%s/'         },
  { 'global',      ' ',  'Global',         'regex', '^:g/'           },
  -- { 'visual',      '礪',  'visual',         "vim",   "^:'<,'>"        },
  { 'global_inv',  ' ',  'Global Inverse', 'regex', '^:g!/'           },
  { 'global_all',  ' ',  'Global Buffer',  'regex', '^:%%g/'         },
  { 'input',       ' ',  'Input',          'vim',   '^:/'            },
  { 'search_up',   ' ', 'Search Up',      'regex', '^%?'            },
  { 'search_down', ' ', 'Search Down',    'regex', '^/'             },
  -- { 'line',       '礪',  'range',      'vim',   '^:%d+$'    },
  -- { 'range',      '礪',  'range',      'vim',   '^:%d+,%d+$'    },
  -- TODO: eval_live: lua, shell, json, html, sql, git, chrome-remote, awk/grep/sed
  -- TODO: stackable data sources, help and examples
}

local extra = {
  line = { conceal = false },
  range = { conceal = false },
  inc_rename = {
    opts = {
      relative = "cursor",
      size = { min_width = 20 },
      position = { row = -3, col = 0 },
      buf_options = { filetype = "text" },
    },
  },
  search_up = {
    kind = "search",
    -- show in classic bottom cmdline view
    -- view = 'cmdline',
  },
  search_down = { kind = "search" },
}

local formatters = {}

for _, v in ipairs(cmdlines) do
  formatters[v[1]] = vim.tbl_deep_extend("force", {
    icon = v[2],
    title = v[3],
    lang = v[4],
    pattern = v[5],
    conceal = true,
    -- icon_hl_group = "NoiceCmdlineIcon", "NoiceCmdlineIconHelp"
  }, extra[v[1]] or {})
end

local config = {
  view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
  format = formatters,
  opts = {
    position = { row = "10%", col = "50%" },
    border = { style = "rounded" },
    -- animate = {
    --   start = { position = { row = "90%", col = "50%" }, winoptions = { winblend = 80 } },
    --   ending = { position = { row = "20%", col = "50%" }, winoptions = { winblend = 0 } },
    -- },
  },
  win_options = {
    winblend = 0,
    -- winhighlight = {
    --   Normal = 'NoiceCmdlinePopup',
    --   FloatBorder = 'NoiceCmdlinePopupBorder',
    --   FloatTitle = 'NoiceCmdlinePopupTitle',
    --   CursorLine = 'NoicePopupmenuSelected', -- used for highlighting the selected item
    --   PmenuMatch = 'NoicePopupmenuMatch', -- used to highlight the part of the item that matches the input
    -- },
    -- Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None
  },
}
-- vim.api.nvim_set_hl(0, 'NoicePopupmenuBorder', { blend = 20 })
-- vim.cmd('hi NoicePopupmenuBorder blend=70')
return config
