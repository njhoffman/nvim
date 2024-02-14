local ns_id = vim.api.nvim_create_namespace('YankHighlight')
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
function M.pulse_fader(blend, cnt)
  if cnt < (100 - blend) / 2 then
    return cnt
  elseif cnt < 100 - blend then
    return 100 - cnt
  else
    return nil
  end
end
-- guifg=#eceff4 guibg=#5d61ec
-- local start_color = { fg = '#5d61ec', bg = '#eceff4' }
local start_color = { fg = '#000000', bg = '#000000' }
local end_color = { fg = '#eceff4', bg = '#5d61ec' }
while true do
  local blend = 0
  for cnt = 0, 100 do
    vim.api.nvim_buf_set_extmark(0, ns_id, 5, 6, {
      hl_mode = 'blend',
      hl_group = 'CurSearch',
    })
    vim.api.nvim_command('sleep 20m')
    blend = M.pulse_fader(blend, cnt)
    if not blend then
      break
    end
  end
end
