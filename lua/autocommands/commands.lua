local logger = require('logger').init('fasd')

local set_cursor_position = function()
  local last_line = vim.fn.line([['"]])
  local buff_last_line = vim.fn.line('$')
  local window_last_line = vim.fn.line('w$')
  local window_first_line = vim.fn.line('w0')

  -- If the last line is set and the less than the last line in the buffer
  if last_line > 0 and last_line <= buff_last_line then
    -- Check if the last line of the buffer is the same as the window
    if window_last_line == buff_last_line then
      -- Set line to last line edited
      vim.api.nvim_command([[keepjumps normal! g`"]])
      -- Try to center
    elseif buff_last_line - last_line > ((window_last_line - window_first_line) / 2) - 1 then
      vim.api.nvim_command([[keepjumps normal! g`"zz]])
    else
      vim.api.nvim_command([[keepjumps normal! G'"<c-e>]])
    end
  end
  if fn.foldclosed('.') ~= -1 and lastplace.options.lastplace_open_folds == 1 then
    vim.api.nvim_command([[normal! zvzz]])
  end
end

local function goto_last_pos()
  local last_edit_pos = vim.fn.getpos('\'"')
  if vim.v.vim_did_enter == 0 then
    local last_arg = vim.v.argv[#vim.v.argv]
    if last_arg:match('^%+%d+$') then
      -- scroll to line
      vim.api.nvim_command('keepjumps normal ' .. last_arg:gsub('%+', '') .. 'G')
      return
    end
  end
  if last_edit_pos and last_edit_pos[2] > 0 and last_edit_pos[2] <= vim.fn.line('$') then
    -- vim.api.nvim_command('keepjumps normal ' .. last_edit_pos[2] .. 'G')
    -- vim.api.nvim_command('keepjumps normal ' .. last_edit_pos[3] .. 'l')
    vim.api.nvim_win_set_cursor(0, { last_edit_pos[2], last_edit_pos[3] })
  end

  --
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
