local logger = require('logger').init('fasd')
local function goto_last_pos()
  -- " Return to last edit position when opening files (You want this!)
  -- au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  local last_pos = vim.fn.line('\'"')
  if last_pos > 0 and last_pos <= vim.fn.line('$') then
    vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
  end
end

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

return {
  fasd_update = fasd_update,
  goto_last_pos = goto_last_pos,
}
