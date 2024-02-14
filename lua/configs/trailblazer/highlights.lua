local colors = {
  sky = '#498ceb',
  green = '#469391',
  crust = '#232634',
  overlay2 = '#9399b2',
  overlay1 = '#7f849c',
  overlay0 = '#6c7086',
  mauve = '#ab86c7',
  yellow = '#afae2d',
}

local hl_groups = {
  TrailBlazerTrailMark = {
    guifg = colors.overlay0,
    guibg = 'none',
    gui = 'bold',
  },
  TrailBlazerTrailMarkNext = {
    guifg = colors.overlay1,
    guibg = 'none',
  },
  TrailBlazerTrailMarkPrevious = {
    guifg = colors.overlay1,
    guibg = 'none',
  },
  TrailBlazerTrailMarkCursor = {
    guifg = colors.crust,
    guibg = colors.green,
  },
  TrailBlazerTrailMarkNewest = {
    guifg = colors.crust,
    guibg = colors.sky,
  },
  TrailBlazerTrailMarkCustomOrd = {
    guifg = colors.crust,
    guibg = colors.yellow,
    gui = 'bold',
  },
  TrailBlazerTrailMarkGlobalBufLineSorted = {
    guifg = 'Black',
    guibg = 'LightRed',
    gui = 'bold',
  },
  TrailBlazerTrailMarkGlobalChronBufLineSorted = {
    guifg = 'Black',
    guibg = 'Olive',
    gui = 'bold',
  },
  TrailBlazerTrailMarkGlobalChronBufSwitchGroupChron = {
    guifg = 'Black',
    guibg = 'VioletRed',
    gui = 'bold',
  },
  TrailBlazerTrailMarkGlobalChronBufSwitchGroupLineSorted = {
    guifg = 'Black',
    guibg = 'MediumSpringGreen',
    gui = 'bold',
  },
  TrailBlazerTrailMarkBufferLocalChron = {
    guifg = 'Black',
    guibg = 'Green',
    gui = 'bold',
  },
  TrailBlazerTrailMarkBufferLocalLineSorted = {
    guifg = 'Black',
    guibg = 'LightGreen',
    gui = 'bold',
  },
}

return hl_groups
