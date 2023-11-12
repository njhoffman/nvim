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
    'n',
    '<C-d>',
    "<cmd>lua vim.print(require('neoai.chat').get_current_model().name.cancel_stream())<cr>",
    opts
  )

  buf_keymap(
    output_buffer,
    'n',
    '<C-y>',
    '<cmd>lua vim.api.nvim_set_current_win(' .. state.root_win .. ')<cr><esc>',
    opts
  )
  buf_keymap(
    input_buffer,
    'i',
    '<C-y>',
    '<cmd>lua vim.api.nvim_set_current_win(' .. state.root_win .. ')<cr><esc>',
    opts
  )

  buf_keymap(
    input_buffer,
    'i',
    '<C-c>',
    '<cmd>lua vim.api.nvim_set_current_win(' .. state.root_win .. ')<cr><esc>',
    opts
  )

  buf_keymap(
    input_buffer,
    'i',
    '<M-f>',
    '<cmd>lua vim.api.nvim_win_call('
      .. state.output_popup.winid
      .. ', function() vim.cmd(\'exec "norm! <C-f>"\') end)<cr>',
    opts
  )

  buf_keymap(
    input_buffer,
    'i',
    '<M-b>',
    '<cmd>lua vim.api.nvim_win_call('
      .. state.output_popup.winid
      .. ', function() vim.cmd(\'exec "norm! <C-b>"\') end)<cr>',
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
        '<cmd>lua vim.api.nvim_set_current_win(' .. state.output_popup.winid .. ')<cr>',
        opts
      )
      buf_keymap(
        input_buffer,
        'i',
        k,
        '<cmd>lua vim.api.nvim_set_current_win(' .. state.output_popup.winid .. ')<cr><esc>',
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
        '<cmd>lua vim.api.nvim_set_current_win(' .. state.input_popup.winid .. ')<cr><esc>',
        opts
      )
      buf_keymap(
        output_buffer,
        'n',
        k,
        '<cmd>lua vim.api.nvim_set_current_win(' .. state.input_popup.winid .. ')<cr><cmd>startinsert<cr>',
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
