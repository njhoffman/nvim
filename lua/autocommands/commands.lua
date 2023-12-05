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

local custom_tips = {
  -- http://eriklievaart.com/cheat/applications/vim/vimquickfix.html
  quickfix = {
    'To populate the quickfix list with the results of a command, use `:cexpr`',
    'To search current file and populate quickfix: \n  `:vimgrep /re/ %:p`',
    'To execute macro @a on every quickfix item: \n  `:cdo! norm @a`',
    'To perform search and replace on quickfix items: \n `:cdo! s/re/repl/`',
    'To search recursively with grep for quickfix list: \n `:gr zsh . -R`',
    'Use the quickfix command `cope` to navigate multiple quickfix lists',
    'Search the files in the argument list with ##\n `:vimgrep // ##`',
    'Other vimgrep examples:\n  `:vimgrep /git/ install.sh`\n  `:vimgrep /apt/ **/*.sh`\n  `:vimgrep /"[^"]i\\+"/ ~/.*`',
  },
  global = {
    'To delete all lines that have only whitespace \n ➜ `:g/^s*$/d`',
    'To delete all non-matching lines \n ➜ `:vg/pattern/d`',
    'Display 5 lines of context for matches \n ➜ `g/pattern/z#.5|echo "=========="`',
    'Copy all matches to end of file \n ➜ `:g/pattern/t$`',
    'Move all matches to end of file \n ➜ `:g/pattern/m$`',
    'Yank all matches to register A \n ➜ `qaq:g/pattern/y A`',
    'Put all matches from register A into buffer \n ➜ `:g/pattern/pu A`',
    'Increment each number at start of line by one \n ➜ `:.,$g/^d/exe "normal! <C-A>"`',
    'Reverse lookup of first field separated by space \n ➜ `:g/pattern/?^w?p`',
    'Reverse lookup of spaced fields with whole record \n ➜ `:g/pattern/?^w?|+,/^[^ ]/-1p`',
    'Add text to end of line that begins with pattern \n ➜ `:g/^pattern/s/$/mytext`',
    'Run macro in register q on matching lines \n ➜ `:g/pattern/normal @q`',
    'Delete duplicates lines \n ➜ `:g/^(.*)(\\r?\\n\\1)+$/d`',
    'Substitute all "bads" into "nice" only for lines that contain "good" \n ➜ `:g/good/s/bad/nice/g`',
    'Comment out all lines with "console" \n ➜ `:g/console/normal I//`',
  },
}

local get_tip = function()
  local url = 'https://vtip.43z.one'
  local job = require('plenary.job')
  --2/3 times show custom tips
  if math.random(1, 3) >= 2 then
    local custom_keys = vim.tbl_keys(custom_tips)
    local rand_cat = custom_keys[math.random(1, #custom_keys)]
    local rand_tip = custom_tips[rand_cat][math.random(1, #custom_tips[rand_cat])]
    vim.notify(rand_tip, 2, {
      title = rand_cat,
      render = 'simple-notitle',
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      end,
      timeout = 8000,
    })
  else
    job
      :new({
        command = 'curl',
        args = { url },
        on_exit = function(j, exit_code)
          local res = table.concat(j:result())
          if exit_code ~= 0 then
            res = 'Error fetching tip: ' .. res
          end
          vim.notify(res, 1, { render = 'simple-notitle' })
        end,
      })
      :start()
  end
end

vim.api.nvim_create_user_command('Tip', get_tip, {
  desc = 'Get a random neovim tip',
})

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
