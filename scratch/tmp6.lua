local buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_lines(buf, 0, -1, true, { 'test', '', 'popup    text' })
local win = vim.api.nvim_open_win(
  buf,
  false,
  { relative = 'editor', width = 15, height = 3, row = 2, col = 5 }
)

local test1 = function()
  vim.api.nvim_set_option_value('winblend', 50, { win = win.id })
end

local test2 = function()
  vim.api.nvim_set_option_value('winhighlight', 'NormalNC:Visual', { win = win })
end

local test3 = function()
  vim.api.nvim_set_option_value('winhighlight', '', { win = win })
  vim.api.nvim_set_hl(0, 'NormalNC', { link = 'Visual' })
end

local test4 = function()
  vim.cmd('hi clear NormalNC')
  vim.cmd('hi SpecialRegion guifg=Red blend=0')
  vim.api.nvim_buf_add_highlight(buf, -1, 'SpecialRegion', 2, 0, -1)
end

local test5 = function()
  vim.cmd('hi SpecialRegion guifg=Red blend=80')
end

local test6 = function()
  vim.api.nvim_win_set_config(win, { border = 'single' })
  vim.api.nvim_set_option_value('winblend', 100, { win = win.id })
  vim.api.nvim_set_option_value('cursorline', true, { win = 0 })
  vim.cmd('hi clear VertSplit')
end

local test7 = function()
  vim.cmd([[
      set termguicolors

      function FloatWin() abort
        let buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(buf, 0, -1, v:true, ['test', 'text'])
        let opts = {'relative': 'cursor', 'width': 50, 'height': 50, 'col': 0, 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
        let win = nvim_open_win(buf, 0, opts)

        call nvim_win_set_option(win, 'winblend', 50)

        " winblend applied
        call nvim_win_set_option(win, 'winhl', 'Normal:Float')
        " winblend not applied
        " call nvim_win_set_option(win, 'winhl', 'Normal:Float,NormalNC:Float')
      endfunction

      autocmd ColorScheme * highlight Normal guibg=#000000
      autocmd ColorScheme * highlight Float  guibg=#FFFFFF

      colorscheme default
  ]])
  -- vim.cmd('call FloatWin()')
  -- winblend does not work when floatwin has NormalNC set and is not in focus.
  -- winblend is applied when the focus moves to floatwin.
end

-- vim.api.nvim_set_hl(0, "NormalFloat", {bg="#3B4252"})
