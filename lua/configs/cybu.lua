require('cybu').setup({
  position = {
    relative_to = 'editor', -- win, editor, cursor
    anchor = 'bottomleft', -- topleft, topcenter, topright,
    -- centerleft, center, centerright,
    -- bottomleft, bottomcenter, bottomright
    vertical_offset = 1, -- vertical offset from anchor in lines
    horizontal_offset = 0, -- vertical offset from anchor in columns
    max_win_height = 10, -- height of cybu window in lines
    max_win_width = 0.3, -- integer for absolute in columns
    -- float for relative to win/editor width
  },
  style = {
    path = 'relative', -- absolute, relative, tail (filename only)
    path_abbreviation = 'none', -- none, shortened
    border = 'rounded', -- single, double, rounded, none
    separator = '  ', -- string used as separator
    prefix = '…', -- string used as prefix for truncated paths
    padding = 2, -- left & right padding in number of spaces
    hide_buffer_id = false, -- hide buffer IDs in window
    devicons = {
      enabled = true, -- enable or disable web dev icons
      colored = true, -- enable color for web dev icons
      truncate = true, -- truncate wide icons to one char width
    },
    highlights = { -- see highlights via :highlight
      current_buffer = 'CybuOperator', -- current / selected buffer
      adjacent_buffers = 'CybuAdjacent', -- buffers not in focus
      background = 'CybuBackground', -- window background
      border = 'CybuBorder', -- border of the window

      -- current_buffer = "CybuFocus", -- current / selected buffer
      -- CybuFocusxxx guifg=#8396b9 guibg=#101840
      -- CybuAdjacentxxx guifg=#4a647b
      -- CybuBackgroundxxx links to Normal
      -- CybuBorderxxx links to FloatBorder
      -- CybuInfobarxxx links to StatusLine
    },
  },
  behavior = { -- set behavior for different modes
    mode = {
      default = {
        switch = 'immediate', -- immediate, on_close
        view = 'rolling', -- paging, rolling
      },
      last_used = {
        switch = 'on_close', -- immediate, on_close
        view = 'paging', -- paging, rolling
      },
      auto = {
        view = 'rolling', -- paging, rolling
      },
    },
    -- show_on_autocmd = 'VimEnter', -- event to trigger cybu (eg. "BufEnter")
    show_on_autocmd = 'BufEnter',
  },
  display_time = 1500, -- time the cybu window is displayed
  exclude = { -- filetypes, cybu will not be active
    'neo-tree',
    'fugitive',
    'qf',
  },
  fallback = function() end, -- arbitrary fallback function
})
