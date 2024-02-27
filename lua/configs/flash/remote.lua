local swap_with = function(opts, ma, mb)
  local function helper(start, finish, op)
    vim.api.nvim_win_set_cursor(0, start)
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, finish)
    vim.api.nvim_feedkeys(op or 'p', 'ni', false)
  end

  local reg = vim.fn.getreg('"')
  vim.api.nvim_feedkeys('`' .. ma .. 'v`' .. mb .. 'y', 'n', false)
  local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)

  _G.__remote_op_opfunc = function()
    helper(vim.api.nvim_buf_get_mark(0, '['), vim.api.nvim_buf_get_mark(0, ']'))
  end
  vim.go.operatorfunc = 'v:lua.__remote_op_opfunc'
  vim.api.nvim_feedkeys('g@', 'n', false)
  require('flash').remote(vim.tbl_deep_extend('force', {
    remote = {
      on_restore = vim.schedule_wrap(function()
        helper(start, finish)
        vim.fn.setreg('"', reg)
      end),
    },
  }, opts))
end
M.swap_with = function(opts)
  local v = vim.api.nvim_get_mode().mode:lower() == 'v'
  if v then
    swap_with(opts, '<', '>')
  else
    _G.__remote_op_opfunc = function()
      swap_with(opts, v and '<' or '[', v and '>' or ']')
    end
    vim.go.operatorfunc = 'v:lua.__remote_op_opfunc'
    vim.api.nvim_feedkeys('g@', 'n', false)
  end
end

-- -- Add keymapping
--   {
--     "rx",
--     mode = { "x", "n" },
--     desc = "Remote Exchange",
--     function()
--       M.swap_with {
--         -- Customize the flash remote options for selecting the second range
--       }
--     end,
--   },
