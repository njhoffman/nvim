local state = require('utils.help.state')
local init_winstate = function()
  if vim.api.nvim_buf_is_loaded(state.help_bufnr) then
    vim.tbl_deep_extend('force', state, {
      -- help_width = vim.api.nvim_win_get_width(state.help_winid),
      -- help_height = vim.api.nvim_win_get_height(state.help_winid),
      -- src_width = vim.api.nvim_win_get_width(state.src_winid),
      -- src_height = vim.api.nvim_win_get_height(state.src_winid),
      editor_width = vim.api.nvim_get_option_value('columns', { scope = 'global' }),
      editor_height = vim.api.nvim_get_option_value('lines', { scope = 'global' }),
      is_vert_split = vim.fn.winnr('j') ~= vim.fn.winnr() or vim.fn.winnr('k') ~= vim.fn.winnr(),
    })

    -- state.split_width = math.floor(0.7 * state.editor_width)
    -- state.split_height = math.floor(0.7 * state.editor_height)
    -- let width_ratio = winwidth(0) / str2float(&columns)
    -- let height_ratio = winheight(0) / str2float(&lines)
  end
end

local init_bufstate = function()
  local get_maxcols = function(lines, bufnr)
    local maxcols = 0
    for i = 1, lines do
      local len = vim.fn.strdisplaywidth(vim.fn.getbufline(bufnr, i))
      if len > maxcols then
        maxcols = len
      end
    end
    return maxcols
  end

  -- stylua: ignore
  vim.tbl_deep_extend('force', state, {
    src_winnr      = vim.fn.bufwinnr(state.src_bufnr),
    src_winid      = vim.fn.bufwinid(state.src_bufnr),
    help_winnr     = vim.fn.bufwinnr(state.help_bufnr),
    help_winid     = vim.fn.bufwinid(state.help_bufnrr),
    src_name       = vim.api.nvim_buf_get_name(state.src_bufnr),
    help_name      = vim.api.nvim_buf_get_name(state.help_bufnr),
  })
  vim.tbl_deep_extend('force', state, {
    textwidth = vim.api.nvim_get_option_value('textwidth', { buf = state.help_bufnr }),
    help_lines = vim.fn.line('$', state.help_winid),
    src_lines = vim.fn.line('$', state.src_winid),
  })
  vim.tbl_deep_extend('force', state, {
    help_maxcols = get_maxcols(state.help_lines, state.help_bufnr),
    src_maxcols = get_maxcols(state.src_lines, state.src_bufnr),
  })

  -- init_winstate()
end

local resize_window = function()
  local width = math.max(state.line_width, state.textwidth)

  if state.editor_width < state.width_cutoff then
    if not state.vert_split then
      vim.cmd('wincmd J | norm 0')
    end
    -- vim.api.nvim_set_option_value('winfixwidth', false, { win = state.help_winid })
    vim.api.nvim_win_set_height(state.help_winid, state.max_height)
    vim.api.nvim_set_option_value('wrap', true, { win = state.help_winid })
  else
    if state.vert_split then
      vim.cmd('wincmd L | norm 0')
    end
    if state.max_width < width then
      -- vim.api.nvim_set_option_value('winfixwidth', false, { win = state.help_winid })
      vim.api.nvim_set_option_value('winwidth', state.max_width, { scope = 'global' })
      -- vim.api.nvim_win_set_width(state.help_winid, state.max_width)
      vim.api.nvim_set_option_value('wrap', true, { win = state.help_winid })
    else
      vim.api.nvim_set_option_value('winfixwidth', true, { win = state.help_winid })
      vim.api.nvim_win_set_width(state.help_winid, width)
      -- vim.api.nvim_set_option_value('winwidth', width, { scope = 'global' })
      vim.api.nvim_set_option_value('wrap', false, { win = state.help_winid })
    end
  end
  -- local cursor = vim.api.nvim_win_get_cursor(state.help_winid)
  -- vim.api.nvim_win_set_cursor(state.help_winid, { cursor[1], 1 })
  -- vim.cmd('norm 0')
end

_G.resize = resize_window
