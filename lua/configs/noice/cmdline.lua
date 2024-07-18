
-- stylua: ignore
local cmdlines = {
  { 'cmdline',    '',   'vimcmd',     "vim",   "^:"             }, -- "^:%s*"
  { 'filter',     '',   'shell',      "bash",  "^:!"            }, -- "^:%s*!"
  { 'lua',        '',   'lua',        "lua",   "^:lua%s+"       },
  { 'eval_lua',   ' ',  'eval-lua',   "lua",   {"^:=%s*", "^:lua%s=%s*"} },
  { 'help',       '',   'help',       "vim",   "^:he?l?p?%s+"   },
  { 'inc_rename', ' ',  'rename',     'vim',   '^:RenameInc%s+' },
  { 'subs',       '',   'replace' ,   'regex', '^:s/'           },
  { 'subs_all',   ' ',  'replace %',  'regex', '^:%%s/'         },
  { 'global',     ' ',  'global',     'regex', '^:g/'           },
  { 'global_all', ' ',  'global %',   'regex', '^:%%g/'         },
  { 'input',      ' ',  'input',      'vim',   '^:/'            },
  { 'search_up',  ' ', 'search up',  'regex', '^%?'            },
  { 'search_down',' ', 'search down','regex', '^/'             },
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
    --   start = { position = { row = "90%", col = "50%" }, winoptions = { winblend = 80 }, },
    --   ending = { position = { row = "20%", col = "50%" }, winoptions = { winblend = 0 }, },
    -- },
  },
  win_options = {
    -- winblend = 50,
    -- winhighlight = {
    --   Normal = 'NoiceCmdlinePopup',
    --   FloatBorder = 'NoiceCmdlinePopupBorder',
    --   FloatTitle = 'NoiceCmdlinePopupTitle',
    --   CursorLine = 'NoicePopupmenuSelected', -- used for highlighting the selected item
    --   PmenuMatch = 'NoicePopupmenuMatch', -- used to highlight the part of the item that matches the input
    -- },
    -- Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None
    -- winblend = 100,
  },
}
-- vim.api.nvim_set_hl(0, 'NoicePopupmenuBorder', { blend = 20 })
-- vim.cmd('hi NoicePopupmenuBorder blend=70')
return config
