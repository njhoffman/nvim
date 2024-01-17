local map = require('mapper').map
local a = require('hover.actions')

-- stylua: ignore
local default_mapping = {
  inactive = {
    n = {
      ['M']         = { a.hover_once,   { desc = ' ' }},
      ['gM']        = { a.hover_sticky, { desc = ' ' }},
      ['<leader>m'] = { a.hover_cursor, { desc = ' ' }},
      ['<leader>M'] = { a.hover_select, { desc = ' ' }},
    },
  },
  global = {
    i = {
      -- ['<Up>'] = actions.scroll_up,
      -- ['<Down>'] = actions.scroll_down,
      -- ['<S-Right>'] = actions.change_tab_right,
      -- ['<S-Left>'] = actions.change_tab_left,
      -- ['<M-}>'] = actions.change_tab_right,
      -- ['<M-.>'] = actions.change_tab_right,
      -- ['<M-,>'] = actions.change_tab_left,

      -- [""] = actions.change_tab_left,
    },
    n = {
      -- ['<esc>']      = { a.close,            { desc = ' ', category = 'Hover' } },
      -- ['q']          = { a.close,            { desc = ' ' }},
      ['<Up>']       = { a.scroll_up,           { desc = ' ' }},
      ['<Down>']     = { a.scroll_down,         { desc = ' ' }},
      ['<C-S-Up>']   = { a.scroll_up,           { desc = ' ' }},
      ['<C-S-Down>'] = { a.scroll_down,         { desc = ' ' }},
      ['<M-b>']      = { a.scroll_page_up,      { desc = ' ' }},
      ['<M-f>']      = { a.scroll_page_down,    { desc = ' ' }},
      ['<M-(>']      = { a.change_tab_left,     { desc = ' ' }},
      ['<M-)>']      = { a.change_tab_right,    { desc = ' ' }},
      ['<M-+>']      = { a.toggle_full_size,    { desc = ' ' }},
      ['<M-w>']      = { a.toggle_wrap,         { desc = ' ' }},
      -- [""] = actions.change_tab_left,
    },
  },
  buffer = {},
  old = {},
}

local function get_key_cmd(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local val = nil
  for _, key in ipairs(keys) do
    if key.lhs == lhs then
      val = key.callback or key.rhs
    end
  end
  return val
end

local clear = function()
  local config = require('hover.config').get()
  for mode, keys in pairs(config.mapping.global) do
    for lhs, _ in pairs(keys) do
      local ok, _ = pcall(vim.keymap.del, mode, lhs)
      if vim.tbl_contains(config.mapping.old, lhs) then
        map(mode, lhs, config.mapping.old[lhs])
      end
    end
  end
end

local assign_open_keymaps = function(_opts)
  local config = require('hover.config').get()
  local opts = vim.tbl_deep_extend('keep', _opts or {}, config)
  for mode, keys in pairs(opts.mapping.global) do
    opts.mapping.old[mode] = opts.mapping.old[mode] or {}
    for lhs, key_item in pairs(keys) do
      local action, key_opts = key_item[1], key_item[2]
      opts.mapping.old[lhs] = get_key_cmd(mode, lhs)
      map(mode, lhs, action, key_opts)
    end
  end

  -- for mode, keys in pairs(config.mapping.buffer) do
  --   for lhs, action in pairs(keys) do
  --     map(mode, lhs, action, { category = "Hover" })
  --   end
  -- end
end

local init = function()
  local config = require('hover.config').get()
  config.mapping.old = config.mapping.old or {}
  for mode, keys in pairs(config.mapping.inactive) do
    config.mapping.old[mode] = config.mapping.old[mode] or {}
    for lhs, key_item in pairs(keys) do
      local action, key_opts = key_item[1], key_item[2]
      map(mode, lhs, action, key_opts)
    end
  end
end

return {
  init = init,
  clear = clear,
  assign_open_keymaps = assign_open_keymaps,
  default_mapping = default_mapping,
}
