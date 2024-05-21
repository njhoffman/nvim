-- last selected position  '< and '>  last position before jump  '' ``
-- last exited position    '" `"      last change position       '. `.
-- last insert position    '^ `^      last affected text area    '[ and ']
local function goto_last_pos(bufnr)
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

local group_name = 'restore_cursor'
vim.api.nvim_create_augroup(group_name, { clear = true })
vim.api.nvim_create_autocmd('BufRead', {
  group = group_name,
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = group_name,
      buffer = opts.buf,
      callback = function()
        goto_last_pos(opts.buf)
      end,
    })
  end,
})

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local last_file = nil
local function fasd_update()
  local logger = require('logger').init('fasd')
  local ignored_ft = { 'dirvish' }
  local fname = vim.api.nvim_buf_get_name(0)
  if
    vim.bo.buftype == ''
    and not vim.tbl_contains(ignored_ft, vim.bo.filetype)
    and fname ~= ''
    and fname ~= last_file
    and file_exists(fname)
  then
    vim.fn.jobstart({ 'fasd', '-A', fname })
    logger:trace(
      'add ' .. vim.fn.fnamemodify(fname, ':t')
      -- 'add ' .. fname
    )
    last_file = fname
  end
end

-- auto-nohl (replace vim-cool) -> https://www.reddit.com/r/neovim/comments/zc720y/comment/iyvcdf0/?context=3
-- vim.on_key(function(char)
--   local key = vim.fn.keytrans(char)
--   local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
--   local searchMvKeys = { "n", "N", "*", "#" } -- works for RHS, therefore no need to consider remaps
--   local isNormalMode = vim.api.nvim_get_mode().mode == "n"
--
--   local searchStarted = (key == "/" or key == "?") and isNormalMode
--   local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
--   local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
--   if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then return end
--   local searchMovement = vim.tbl_contains(searchMvKeys, key)
--   local hlSearchOn = vim.o.hlsearch
--
--   if (searchMovement or searchConfirmed or searchStarted) and not hlSearchOn then
--     vim.opt.hlsearch = true
--   elseif (searchCancelled or not searchMovement) and hlSearchOn and not searchConfirmed then
--     vim.opt.hlsearch = false
--   end
--
--   -- nvim-hlslens plugin
--   if searchConfirmed or searchMovement then
--     local installed, hlslens = pcall(require, "hlslens")
--     if installed then hlslens.start() end
--   end
-- end, vim.api.nvim_create_namespace("auto_nohl"))

return {
  fasd_update = fasd_update,
  goto_last_pos = goto_last_pos,
}
