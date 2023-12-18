local devbox = function()
  vim.api.nvim_create_user_command('Devbox', function()
    require('devbox.main').setup()
  end, { desc = 'Start devbox inspection window' })
end

local devbox_stop = function(state)
  vim.api.nvim_create_user_command('DevboxStop', function()
    vim.api.nvim_win_close(state.popup.winnr, true)
  end, { desc = 'Stop devbox inspection' })
end

local devbox_timing = function(state)
  vim.api.nvim_create_user_command('DevboxTimes', function()
    vim.notify(vim.inspect(state.timing))
  end, { desc = 'Show devbox timing information' })
end

-- local devbox_timing = function(state)
--   vim.api.nvim_create_user_command('DevboxReset', function()
--     state.timing = vim.fn.deepcopy(default_state.timing)
--     state.current = vim.fn.deepcopy(default_state.current)
--     vim.defer_fn(display.update_popup, 200)
--   end, { desc = 'Reset devbox timing and counts' })
-- end

return {
  devbox = devbox,
  devbox_stop,
  devbox_timing,
}
