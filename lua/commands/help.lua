local custom_tips = {
  -- http://eriklievaart.com/cheat/applications/vim/vimquickfix.html
  quickfix = {
    'Populate the quickfix list with the results of a command, use `:cexpr`',
    'Search current file and populate quickfix: \n  ➜ `:vimgrep /re/ %:p`',
    'Execute macro @a on every quickfix item: \n  ➜ `:cdo! norm @a`',
    'To perform search and replace on quickfix items: \n  ➜ `:cdo! s/re/repl/`',
    'Search recursively with grep for quickfix list: \n  ➜ `:gr zsh . -R`',
    'Use the quickfix command `cope` to navigate multiple quickfix lists',
    'Search the files in the argument list with ##\n  ➜ `:vimgrep // ##`',
    'Other vimgrep examples\n  ➜ `:vimgrep /git/ install.sh`\n  `:vimgrep /apt/ **/*.sh`\n  `:vimgrep /"[^"]i\\+"/ ~/.*`',
  },
  format = {
    'Quick surround word near cursor with quote\n  ➜ `s-SPC-"` / `s-s-"`',
    'Live commands\n  ➜ `Norm <keys>`, `5Reg a`, `G/^$/d`, `%S/pattern/replace`',
    'Subvert `(:Subvert/pat/repl)` command substitutes with case pattern matches',
  },
  movement = {
    'Quick block navigation\n  ➜ `<C-S-]> / <C-S-[>`',
    'Normal jump to node\n  ➜ `<C-M-J> / <C-M-K> / <C-M-H> / <C-M-L>`',
    'Visual move selection\n  ➜ (v)`<S-L> / <S-H> / <S-J> / <S-K>`',
    'Normal move (swap) line up/down\n  ➜ `<M-S-J> / <M-S-K>`',
    'Normal move (swap) node\n  ➜ `<C-M-S-J> / <C-M-S-K> / <C-M-S-H> / <C-M-S-L>`',
    'Exchange (swap) content inside argument and parenthesis with cx \n ➜ `cxia` ➜ `cxi(`',
    'Visual exchange (swap) inside function and block with X \n  ➜ `vifX` ➜ `vibX`',
    'Text objects\n  ➜ `c = class, C = conditional, f = function, ? = prompt, i = object`'
      .. '\n  ➜ `b = balanced, B = block, h = git-hunk, o = block/cond/loop, L = loop`'
      .. '\n  ➜ `t = tag, w = word, W = WORD, x = comment, l = last textobj, n = next textobj`'
      .. '\n  ➜ `% = matching, a = argument, A = attribute, s = sentence, p = paragraph, q = quote`',
  },
  global = {
    'To delete all lines that have only whitespace \n  ➜ `:g/^s*$/d`',
    'To delete all non-matching lines \n  ➜ `:vg/pattern/d`',
    'Display 5 lines of context for matches \n  ➜ `g/pattern/z#.5|echo "=========="`',
    'Copy all matches to end of file \n  ➜ `:g/pattern/t$`',
    'Move all matches to end of file \n  ➜ `:g/pattern/m$`',
    'Yank all matches to register A \n  ➜ `qaq:g/pattern/y A`',
    'Put all matches from register A into buffer \n  ➜ `:g/pattern/pu A`',
    'Increment each number at start of line by one \n  ➜ `:.,$g/^d/exe "normal! <C-A>"`',
    'Reverse lookup of first field separated by space \n  ➜ `:g/pattern/?^w?p`',
    'Reverse lookup of spaced fields with whole record \n  ➜ `:g/pattern/?^w?|+,/^[^ ]/-1p`',
    'Add text to end of line that begins with pattern \n  ➜ `:g/^pattern/s/$/mytext`',
    'Run macro in register q on matching lines \n   ➜ `:g/pattern/normal @q`',
    'Delete duplicates lines \n  ➜ `:g/^(.*)(\\r?\\n\\1)+$/d`',
    'Substitute all "bads" into "nice" only for lines that contain "good" \n  ➜ `:g/good/s/bad/nice/g`',
    'Comment out all lines with "console" \n  ➜ `:g/console/normal I//`',
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
        vim.api.nvim_set_option_value('conceallevel', 3, { win = win })
        vim.api.nvim_set_option_value('filetype', 'pandoc.markdown', { buf = buf })
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

local helputils = require('utils.helptags')
local function get_help_cursor()
  local match, word = helputils.search_cursor_word()
  if match then
    vim.cmd('help ' .. word)
  else
    require('telescope.run')('builtin', 'help_tags')
  end
end

return { get_help_cursor = get_help_cursor, get_tip = get_tip }
