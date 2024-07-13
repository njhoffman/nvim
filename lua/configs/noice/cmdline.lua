
-- stylua: ignore
local cmdlines = {
  { 'cmdline',    '',   'vimcmd',     "vim",   "^:%s*"             },
  { 'filter',     '',   'shell',      "bash",  "^:%s*!%s*"         },
  { 'lua',        '',   'lua',        "lua",   "^:%s*lua%s+"       },
  { 'eval_lua',   ' ',  'eval-lua',   "lua",   "^:%s*=%s*"         },
  { 'help',       '',   'help',       "vim",  "^:%s*he?l?p?%s+"   },
  { 'numb',       '礪',  'range',      'vim',   '^:%s*%d+$'         },
  { 'inc_rename', ' ',  'rename',     'vim',   '^:%s*IncRename%s+' },
  { 'subs',       '',   'replace' ,   'regex',   '^:%s*s/'           },
  { 'subs_all',   ' ',  'replace %',  'regex',   '^:%s*%%s/'         },
  { 'global',     ' ',  'global',     'regex',   '^:%s*g/'           },
  { 'global_all', ' ',  'global %',   'regex',   '^:%s*%%g/'         },
  { 'input',      ' ',  'input',      'vim',   '^:/'               },
  { 'search_down',' ', 'search down','regex', '^/'                },
  { 'search_up',  ' ', 'search up',  'regex', '^%?'               },
  -- eval_live: lua, shell, json, html, sql, git, chrome-remote, awk/grep/sed
  -- stackable data sources, help and examples
}
local extra = {
  numb = { conceal = false },
  inc_rename = {
    opts = {
      relative = 'cursor',
      size = {
        min_width = 20,
      },
      position = {
        row = -3,
        col = 0,
      },
      buf_options = { filetype = 'text' },
    },
  },
  search_up = { kind = 'search' },
  search_down = { kind = 'search' },
}

local formatters = {}
for _, v in ipairs(cmdlines) do
  formatters[v[1]] = vim.tbl_deep_extend('force', {
    icon = v[2],
    title = v[3],
    lang = v[4],
    pattern = v[5],
    conceal = true,
  }, extra[v[1]] or {})
end

local config = {
  view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
  format = formatters,
  opts = {
    position = { row = '10%', col = '50%' },
    border = { style = 'rounded' },
    animate = {
      start = {
        position = { row = '90%', col = '50%' },
        winoptions = { winblend = 80 },
      },
      ending = {
        position = { row = '20%', col = '50%' },
        winoptions = { winblend = 0 },
      },
    },
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
