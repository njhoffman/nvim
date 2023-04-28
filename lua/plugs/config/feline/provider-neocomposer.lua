local state = require('NeoComposer.state')
local colors = require('plugs.config.feline.colors')

local config = {
  bg = '#282c34',
  fg = '#ff9e64',
  red = '#ec5f67',
  blue = '#5fb3b3',
  green = '#49f794',
}

local neocomposer = function(_, opts)
  local function set_highlight(group, fg)
    vim.cmd(string.format('highlight %s guifg=%s guibg=%s gui=bold', group, fg, '#000000'))
  end

  set_highlight('StatusLabel', colors.main.fg)
  set_highlight('DelaySymbol', config.blue)
  set_highlight('PlayingSymbol', config.green)
  set_highlight('RecordingSymbol', config.red)

  local status = ''
  local delay_enabled = state.get_delay()

  if state.get_recording() then
    status = '%#RecordingSymbol#  %#StatusLabel#REC '
  elseif state.get_playing() then
    status = '%#PlayingSymbol#  %#StatusLabel#PLAY '
  end
  if state.get_queued_macro() ~= '' then
    status = '亮' .. #state.get_queued_macro() .. ' ' .. status
  end
  -- status = '亮' .. #state.get_macros() .. ' ' .. status

  -- if delay_enabled then
  --   status = (status == '' and '' or (status .. ' ')) .. '%#DelaySymbol# 祥%#StatusLabel#DELAY '
  -- end

  return status
end

return {
  name = 'neocomposer',
  provider = neocomposer,
}
