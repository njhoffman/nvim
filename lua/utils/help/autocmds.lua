local state = require('utils.help.state')

local augroup = vim.api.nvim_create_augroup('helpfile', { clear = true })
local aucmd = vim.api.nvim_create_autocmd

local create_autocmds = function()
  -- aucmd({ 'WinResized' }, {
  --   group = augroup,
  --   callback = function(opts)
  --     if opts.buf == state.help_bufnr then
  --       debounce(resize_window(), 500)
  --     end
  --   end,
  -- })

  aucmd({ 'BufWinEnter' }, {
    group = augroup,
    callback = function(opts)
      if opts.buf == state.help_bufnr then
        vim.cmd('set winwidth=80 winminwidth=50')
        -- debounce(refresh_state(), 500)
      end
    end,
  })

  local load_file = function(opts)
    if opts.buf then
      local ft = vim.api.nvim_get_option_value('filetype', { buf = opts.buf })
      if ft == 'help' then
        local bufname = vim.api.nvim_buf_get_name(opts.buf)
        local entry = get_history_by_bufname(bufname)
        if not entry then
          entry = { name = bufname, tags = {}, dates = {} }
          table.insert(entry.dates, { os.time(), state.src_name })
          table.insert(help_history, entry)
        else
          table.insert(entry.dates, { os.time(), state.src_name })
        end
      end
    end
  end

  aucmd({ 'BufNewFile' }, {
    group = augroup,
    callback = function(opts)
      vim.cmd('set winwidth=80 winminwidth=50')
      -- debounce(load_file(opts), 500)
    end,
  })

  local teardown = function(opts)
    if opts.buf == state.help_bufnr or opts.buf == state.src_bufnr then
      write_history()
    end
  end

  -- aucmd({ 'WinClosed' }, {
  --   group = augroup,
  --   callback = function(opts)
  --     debounce(teardown(opts), 500)
  --   end,
  -- })
end
