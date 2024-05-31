local set_option = vim.api.nvim_set_option_value

-- turn off relative or all line numbering depending on conditions

-- autocmds.NumberToggle = {
--   {
--     { 'BufEnter', 'FocusGained', 'InsertLeave' },
--     '*',
--     "if &readonly != 1 && &buftype != 'prompt' && &filetype != 'nofile' && &buftype != 'nofile' && &buftype != 'quickfix' | set relativenumber | endif",
--   },
--   { { 'BufLeave', 'FocusLost', 'InsertEnter' }, '*', 'set norelativenumber' },
-- }

-- -- Don't want relative no on inactive Windows
-- local relativeNo = vim.api.nvim_create_augroup('RelativeNo', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter', 'FocusGained', 'InsertLeave' }, {
--   pattern = '*',
--   group = relativeNo,
--   callback = function()
--     if
--       not vim.g.zen_mode_active
--       and not vim.bo.readonly
--       and vim.bo.buftype ~= 'prompt'
--       and vim.bo.buftype ~= 'nofile'
--       and vim.bo.buftype ~= 'quickfix'
--       and vim.bo.filetype ~= 'nofile'
--     then
--       vim.cmd([[set relativenumber number]])
--     else
--       vim.cmd([[set norelativenumber nonumber]])
--     end
--   end,
-- })

local line_numbers = function(ev)
  local num_off = {
    filetypes = { 'nofile' },
    buftypes = { 'nofile', 'quickfix', 'prompt' },
  }

  -- local winid = vim.fn.bufwinid(ev.buf)
  -- if winid > -1 then
  if
    not vim.g.zen_mode_active
    and not vim.bo.readonly
    and not vim.tbl_contains(num_off.buftypes, vim.bo.buftype)
    and not vim.tbl_contains(num_off.filetypes, vim.bo.filetype)
  then
    vim.cmd([[set relativenumber number]])
  else
    vim.cmd([[set norelativenumber nonumber]])
  end
end

local enable_list = function()
  vim.w.list_enabled = vim.wo.list
  vim.wo.list = false
end

local disable_list = function()
  if vim.w.list_enabled ~= nil then
    vim.wo.list = vim.w.list_enabled
  end
end

local handle_special = function()
  vim.defer_fn(function()
    -- no list chars in special buffers
    if vim.bo.buftype ~= '' and vim.bo.ft ~= 'query' then
      disable_list()
    end
  end, 1)
end

local highlight_yank = function()
  if vim.v.event.operator == 'y' then
    -- Highlight the yanked area
    vim.highlight.on_yank({
      hlgroup = 'Visual', -- IncRename
      on_visual = true,
      on_macro = true,
      timeout = 150,
    })
  end
end

local goto_last_pos = function(bufnr)
  local logger = require('logger').init('buffers')
  local options = {
    open_folds = 1,
    ignore = {
      buftypes = { 'quickfix', 'nofile', 'help' },
      filetypes = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
    },
  }

  -- scroll to line if included in startup args
  if vim.v.vim_did_enter == 0 then
    local last_arg = vim.v.argv[#vim.v.argv]
    if last_arg:match('^%+%d+$') then
      return vim.api.nvim_command('keepjumps normal ' .. last_arg:gsub('%+', '') .. 'G')
    end
  end

  local winid = vim.fn.bufwinid(bufnr)
  local pos = {
    exit_line = vim.fn.line([['"]], winid),
    exit_col = vim.fn.col([['"]], winid),
    buf_last = vim.fn.line('$', winid),
    win_first = vim.fn.line('w0', winid),
    win_last = vim.fn.line('w$', winid),
  }

  local buf = {
    name = vim.api.nvim_buf_get_name(bufnr),
    type = vim.api.nvim_get_option_value('buftype', { buf = bufnr }),
    ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr }),
  }

  if
    vim.tbl_contains(options.ignore.buftypes, buf.type)
    or vim.tbl_contains(options.ignore.filetypes, buf.ft)
  then
    return logger:debug(
      'restore skip (' .. bufnr .. ') - ' .. buf.name .. ' ' .. buf.type .. ' ' .. buf.ft
    )
  end

  -- if the last line is set and the less than the last line in the buffer
  if pos.exit_line > 0 and pos.exit_line <= pos.buf_last then
    logger:debug('restore (' .. bufnr .. ') ' .. pos.exit_line .. ':' .. pos.exit_col)
    if pos.win_last == pos.buf_last then
      vim.api.nvim_command([[keepjumps normal! g`"]])
    elseif pos.buf_last - pos.exit_line > ((pos.win_last - pos.win_first) / 2) - 1 then
      vim.api.nvim_command([[keepjumps normal! g`"zz]])
    else
      vim.api.nvim_command([[keepjumps normal! G'"<c-e>]])
    end
  end

  if vim.fn.foldclosed(vim.fn.line('.')) ~= -1 and options.open_folds == 1 then
    vim.api.nvim_command([[normal! zvzz]])
  end
  --  -- vim.api.nvim_command('keepjumps normal ' .. pos[2] .. 'G')
  --  -- vim.api.nvim_command('keepjumps normal ' .. pos[3] .. 'l')
  --     vim.api.nvim_win_set_cursor(pos[1], { pos[2], 0 })
  --  -- vim.fn.cursor({ pos[2], pos[3] })
end

local restore_cursor = function(opts)
  -- last selected position  '< and '>  last position before jump  '' ``
  -- last exited position    '" `"      last change position       '. `.
  -- last insert position    '^ `^      last affected text area    '[ and ']
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = 'RestoreCursor',
    buffer = opts.buf,
    callback = function()
      goto_last_pos(opts.buf)
    end,
  })
end

return {
  enable_list = enable_list,
  disable_list = disable_list,
  highlight_yank = highlight_yank,
  restore_cursor = restore_cursor,
  handle_special = handle_special,
  line_numbers = line_numbers,
}
