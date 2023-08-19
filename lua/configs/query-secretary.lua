require('query-secretary').setup({
  open_win_opts = {
    row = 0,
    col = 9999,
    width = 50,
    height = 15,
  },

  -- other options you can customize
  buf_set_opts = {
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
  },

  capture_group_names = { 'cap', 'second', 'third' }, -- when press "c"
  predicates = { 'eq', 'any-of', 'contains', 'match', 'lua-match' }, -- when press "p"
  visual_hl_group = 'Visual', -- when moving cursor around

  -- here are the default keymaps
  keymaps = {
    close = { 'q', 'Esc' },
    next_predicate = { 'p' },
    previous_predicate = { 'P' },
    remove_predicate = { 'd' },
    toggle_field_name = { 'f' },
    yank_query = { 'y' },
    next_capture_group = { 'c' },
    previous_capture_group = { 'C' },
  },
})

vim.keymap.set('n', '<leader><BS>', function()
  require('query-secretary').query_window_initiate()
end, {})
