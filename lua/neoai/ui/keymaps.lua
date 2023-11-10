local state = require('neoai.ui.state')

local set_create_keymaps = function(config)
  local buf_keymap = vim.api.nvim_buf_set_keymap
  local input_buffer = state.input_popup.bufnr
  local output_buffer = state.output_popup.bufnr
  local opts = { noremap = true, silent = true }

  if string.lower(config.options.ui.submit) == '<enter>' then
    buf_keymap(input_buffer, 'i', '<C-Enter>', '<Enter>', opts)
  end
  buf_keymap(input_buffer, 'i', config.options.ui.submit, "<cmd>lua require('neoai.ui').submit_prompt()<cr>", opts)
  buf_keymap(
    input_buffer,
    'i',
    '<C-y>',
    '<cmd>lua vim.api.nvim_set_current_win(' .. state.root_win .. ')<cr><esc>',
    opts
  )
  buf_keymap(
    output_buffer,
    'i',
    '<C-y>',
    '<cmd>lua vim.api.nvim_set_current_win(' .. state.root_win .. ')<cr><esc>',
    opts
  )

  local key = config.options.mappings['select_up']
  if key ~= nil then
    local keys = {}
    if type(key) == 'table' then
      keys = key
    else
      keys = { key }
    end
    for _, k in ipairs(keys) do
      buf_keymap(
        input_buffer,
        'n',
        k,
        "<cmd>lua vim.api.nvim_set_current_win(require('neoai.ui.state').output_popup.winid)<cr>",
        opts
      )
      buf_keymap(
        input_buffer,
        'i',
        k,
        "<cmd>lua vim.api.nvim_set_current_win(require('neoai.ui.state').output_popup.winid)<cr>",
        opts
      )
    end
  end
  key = config.options.mappings['select_down']
  if key ~= nil then
    local keys = {}
    if type(key) == 'table' then
      keys = key
    else
      keys = { key }
    end
    for _, k in ipairs(keys) do
      buf_keymap(
        output_buffer,
        'i',
        k,
        "<cmd>lua vim.api.nvim_set_current_win(require('neoai.ui.state').input_popup.winid)<cr>",
        opts
      )
      buf_keymap(
        output_buffer,
        'n',
        k,
        "<cmd>lua vim.api.nvim_set_current_win(require('neoai.ui.state').input_popup.winid)<cr>",
        opts
      )
    end
  end
end

-- This function sets a keymap for the input buffer. In normal mode, pressing
-- the '<Esc>' or <Ctrl-c> key triggers the 'neoai.ui' module's 'destroy_ui' function, which
local set_destroy_keymaps = function()
  local mappings = {
    '<Esc>',
    '<C-c>',
  }
  for _, key in ipairs(mappings) do
    vim.api.nvim_buf_set_keymap(
      state.input_popup.bufnr,
      'n',
      key,
      "<cmd>lua require('neoai.ui').destroy_ui()<cr>",
      { noremap = true, silent = true }
    )
  end
end

return {
  set_create_keymaps = set_create_keymaps,
  set_destroy_keymaps = set_destroy_keymaps,
}
