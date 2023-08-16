local function quick_menu()
  local cmd = require('hydra.keymap-util').cmd
  return {
    name = 'Quick Menu',
    mode = { 'n' },
    hint = [[
        Quick Menu
^
_f_: Show Terminal (float)
_v_: Open Terminal (vertical)Commands
_h_: Open Terminal (horizontal)

_x_: Open Quickfix
_l_: Open Location List

_s_: Buffer Fuzzy Search
_o_: Open Symbols Outline

_t_: Show Help Tags
_k_: Show Keymaps
_c_: Show Vim Commands
_m_: Show Man Pages
^
^ ^  _q_/_<Esc>_: Exit Hydra
    ]],
    config = {
      color = 'teal',
      invoke_on_body = true,
      hint = {
        type = 'window',
        position = 'bottom',
        border = 'rounded',
        show_name = true,
      },
    },
    body = '<A-q>',
    heads = {
      { 't', cmd('Telescope help_tags'), { desc = 'Open Help Tags', silent = true } },
      { 'k', ":lua require('telescope.builtin').keymaps()<CR>", { desc = 'Open Neovim Keymaps', silent = true } },
      { 'c', cmd('Telescope commands'), { desc = 'Open Available Telescope Commands', silent = true } },
      { 'm', cmd('Telescope man_pages'), { desc = 'Opens Man Pages', silent = true } },

      {
        's',
        cmd('Telescope current_buffer_fuzzy_find skip_empty_lines=true'),
        { desc = 'Fuzzy find in current buffer', silent = true },
      },
      { 'o', cmd('Telescope aerial'), { desc = 'Opens Symbols Outline', exit = true, silent = true } },

      { 'x', cmd('TroubleToggle quickfix'), { desc = 'Opens Quickfix', silent = true } },
      { 'l', cmd('TroubleToggle loclist'), { desc = 'Opens Location List', silent = true } },

      { 'f', cmd('ToggleTerm direction=float'), { desc = 'Floating Terminal', silent = true } },
      { 'v', cmd('ToggleTerm direction=vertical'), { desc = 'Vertical Terminal', silent = true } },
      { 'h', cmd('ToggleTerm direction=horizontal'), { desc = 'Horizontal Terminal', silent = true } },

      { 'q', nil, { desc = 'quit', exit = true, nowait = true } },
      { '<Esc>', nil, { desc = 'quit', exit = true, nowait = true } },
    },
  }
end

return { hydra = quick_menu }
