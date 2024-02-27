local function move_split_size()
  local Hydra = require('hydra')
  local resize_win = function(op)
    return function()
      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local win_config = vim.api.nvim_win_get_config(winid)

      vim.api.nvim_set_option_value('winfixwidth', false, { win = winid })
      vim.api.nvim_set_option_value('equalalways', false, {})

      win_config.relative = 'editor'
      win_config.bufpos = { 0, 0 }

      local size = {
        width = vim.api.nvim_win_get_width(winid),
        height = vim.api.nvim_win_get_height(winid),
      }

      -- vim.api.nvim_set_option_value('winfixwidth', false, { win = winid })
      -- vim.api.nvim_set_option_value('winfixheight', false, { win = winid })
      -- vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
      -- vim.api.nvim_set_option_value('equalalways', false)

      if op == '+' then
        -- vim.fn.feedkeys('<C-w>+', 'n')
        size.height = size.height + 2
      elseif op == '-' then
        -- vim.fn.feedkeys('<C-w>-', 'n')
        size.height = size.height - 2
      elseif op == '<' then
        -- vim.fn.feedkeys('2<C-w><', 'n')
        -- local curwidth = vim.fn.winwidth(0)
        -- local newwidth = curwidth - 5
        -- vim.api.nvim_win_set_width(0, newwidth)
        size.width = size.width - 3
      else
        -- vim.fn.feedkeys('2<C-w>>', 'n')
        -- local curwidth = vim.fn.winwidth(0)
        -- local newwidth = curwidth + 5
        -- vim.api.nvim_win_set_width(0, newwidth)
        size.width = size.width + 3
      end

      vim.api.nvim_win_set_width(winid, size.width)
      vim.api.nvim_win_set_height(winid, size.height)
    end
  end

  Hydra({
    name = 'Window',
    hint = [[
       ^^^^^^     Move     ^^^^^^   ^^     Split         ^^^^    Size
       ^^^^^^--------------^^^^^^   ^^---------------    ^^^^-------------
       ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^    _s_: horizontally    _+_ _-_: height
       _h_ ^ ^ _l_   _H_ ^ ^ _L_    _v_: vertically      _>_ _<_: width
       ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^    _q_: close           ^ _=_ ^: equalize
       focus^^^^^^   window^^^^^^
       ^ ^ ^ ^ ^ ^   ^ ^ ^ ^ ^ ^    ^ ^ ^    _<Esc>_
    ]],
    config = {
      -- timeout = 4000,
      invoke_on_body = true,
      hint = {
        float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          border = 'rounded',
          style = 'minimal',
          focusable = false,
          noautocmd = true,
        },
        -- position = 'bottom',
      },
    },
    mode = 'n',
    body = '<C-W>',
    heads = {
      -- TODO: enable popup windows if they are not notify
      -- Move focus
      { 'h', '<C-w>h' },
      { 'j', '<C-w>j' },
      { 'k', '<C-w>k' },
      { 'l', '<C-w>l' },
      -- Move window
      -- https://github.com/sindrets/winshift.nvim
      { 'H', '<Cmd>WinShift left<CR>' },
      { 'J', '<Cmd>WinShift down<CR>' },
      { 'K', '<Cmd>WinShift up<CR>' },
      { 'L', '<Cmd>WinShift right<CR>' },
      -- Split
      { 's', '<C-w>s' },
      { 'v', '<C-w>v' },
      { 'q', '<Cmd>try | close | catch | endtry<CR>', { desc = 'close window' } },
      -- Size
      { '+', resize_win('+'), { desc = 'increase height' } },
      { '-', resize_win('-'), { desc = 'decrease height' } },
      { '>', resize_win('>'), { desc = 'increase width' } },
      { '<', resize_win('<'), { desc = 'decrease width' } },
      { '=', '<C-w>=', { desc = 'equalize' } },
      -- maximize, minimize
      --
      { '<Esc>', nil, { exit = true } },
    },
  })
end

return { hydra = move_split_size }
