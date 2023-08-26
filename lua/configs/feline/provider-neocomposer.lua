local colors = require('configs.feline.colors')

local config = {
  bg = '#282c34',
  fg = '#ff9e64',
  red = '#ec5f67',
  blue = '#5fb3b3',
  green = '#49f794',
}

local neocomposer = function(_, opts)
  local state = require('NeoComposer.state')
  local function set_highlight(group, fg)
    vim.cmd(string.format('highlight %s guifg=%s guibg=%s gui=bold', group, fg, '#000000'))
  end

  set_highlight('StatusLabel', colors.main.fg)
  set_highlight('DelaySymbol', config.blue)
  set_highlight('PlayingSymbol', config.green)
  set_highlight('RecordingSymbol', config.red)

  local status = ''
  local queued = state.get_queued_macro()

  if state.get_recording() ~= false then
    status = '%#RecordingSymbol#  %#StatusLabel#REC '
  elseif state.get_playing() ~= false then
    status = '%#PlayingSymbol#  %#StatusLabel#PLAY '
  end
  if queued ~= nil then
    status = '󰯁' .. ' ' .. status
  end
  -- status = '󰯁' .. #state.get_macros() .. ' ' .. status
  -- local delay_enabled = state.get_delay()
  -- if delay_enabled then
  --   status = (status == '' and '' or (status .. ' ')) .. '%#DelaySymbol# 󱎫%#StatusLabel#DELAY '
  -- end

  return status
end

return {
  name = 'neocomposer',
  provider = neocomposer,
}
