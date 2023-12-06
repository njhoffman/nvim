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
