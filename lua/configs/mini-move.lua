--
local default_cfg = {
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",
    -- Move current line in Normal mode
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },
  options = {
    reindent_linewise = true,
  },
}
-- stylua: ignore
require('mini.move').setup({
  mappings = {
  -- visual
    left       = 'H',
    right      = 'L',
    down       = 'J',
    up         = 'K',

    line_left  = '<leader>H',
    line_right = '<leader>L',
    line_down  = '<leader>J',
    line_up    = '<leader>K',
  },
})
vim.cmd([[
  function! s:Map(...) abort
    let [mode, head, rhs; rest] = a:000
    let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
    let tail = ''
    let keys = get(g:, mode.'remap', {})
    if type(keys) == type({}) && !empty(keys)
      while !empty(head) && len(keys)
        if has_key(keys, head)
          let head = keys[head]
          if empty(head)
            let head = '<skip>'
          endif
          break
        endif
        let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
        let head = substitute(head, '<[^<>]*>$\|.$', '', '')
      endwhile
    endif
    if head !=# '<skip>' && empty(maparg(head.tail, mode))
      return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
    endif
    return ''
  endfunction
  function! s:BlankUp() abort
    let cmd = 'put!=repeat(nr2char(10), v:count1)|silent '']+'
    if &modifiable
    let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-up)", v:count1)'
    endif
    return cmd
  endfunction

  function! s:BlankDown() abort
    let cmd = 'put =repeat(nr2char(10), v:count1)|silent ''[-'
    if &modifiable
    let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-down)", v:count1)'
    endif
    return cmd
  endfunction

  nnoremap <silent> <Plug>(unimpaired-blank-up)   :<C-U>exe <SID>BlankUp()<CR>
  nnoremap <silent> <Plug>(unimpaired-blank-down) :<C-U>exe <SID>BlankDown()<CR>

  function! s:ExecMove(cmd) abort
    let old_fdm = &foldmethod
    if old_fdm !=# 'manual'
      let &foldmethod = 'manual'
    endif
    normal! m`
    silent! exe a:cmd
    norm! ``
    if old_fdm !=# 'manual'
      let &foldmethod = old_fdm
    endif
  endfunction

  function! s:Move(cmd, count, map) abort
    call s:ExecMove('move'.a:cmd.a:count)
    silent! call repeat#set("\<Plug>(unimpaired-move-".a:map.")", a:count)
  endfunction

  function! s:MoveSelectionUp(count) abort
    call s:ExecMove("'<,'>move'<--".a:count)
    silent! call repeat#set("\<Plug>(unimpaired-move-selection-up)", a:count)
  endfunction

  function! s:MoveSelectionDown(count) abort
    call s:ExecMove("'<,'>move'>+".a:count)
    silent! call repeat#set("\<Plug>(unimpaired-move-selection-down)", a:count)
  endfunction

  nnoremap <silent> <Plug>(unimpaired-move-up)            :<C-U>call <SID>Move('--',v:count1,'up')<CR>
  nnoremap <silent> <Plug>(unimpaired-move-down)          :<C-U>call <SID>Move('+',v:count1,'down')<CR>
  noremap  <silent> <Plug>(unimpaired-move-selection-up)   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>
  noremap  <silent> <Plug>(unimpaired-move-selection-down) :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>

  exe s:Map('n', '[o', '<Plug>(unimpaired-blank-up)')
  exe s:Map('n', ']o', '<Plug>(unimpaired-blank-down)')
  exe s:Map('n', '[<Space>', '<Plug>(unimpaired-blank-up)')
  exe s:Map('n', ']<Space>', '<Plug>(unimpaired-blank-down)')
  exe s:Map('n', '[k', '<Plug>(unimpaired-move-up)')
  exe s:Map('n', '[j', '<Plug>(unimpaired-move-down)')
  exe s:Map('x', '[k', '<Plug>(unimpaired-move-selection-up)')
  exe s:Map('x', ']j', '<Plug>(unimpaired-move-selection-down)')
]])

-- local M = {}

-- M.previous = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'previous')
-- end

-- M.next = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'next')
-- end

-- M.first = function()
--   vim.cmd('first')
-- end

-- M.last = function()
--   vim.cmd('last')
-- end

-- M.bprevious = function()
--   vim.cmd(vim.v.count1 .. 'bprevious')
-- end

-- M.bnext = function()
--   vim.cmd(vim.v.count1 .. 'bnext')
-- end

-- M.bfirst = function()
--   vim.cmd('bfirst')
-- end

-- M.blast = function()
--   vim.cmd('blast')
-- end

-- M.lprevious = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'lprevious')
--   vim.cmd.normal('zv')
-- end

-- M.lnext = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'lnext')
--   vim.cmd.normal('zv')
-- end

-- M.lfirst = function()
--   vim.cmd('lfirst')
-- end

-- M.llast = function()
--   vim.cmd('llast')
-- end

-- M.lpfile = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'lpfile')
-- end

-- M.lnfile = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'lnfile')
-- end

-- M.cprevious = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'cprevious')
--   vim.cmd.normal('zv')
-- end

-- M.cnext = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'cnext')
--   vim.cmd.normal('zv')
-- end

-- M.cfirst = function()
--   vim.cmd('cfirst')
-- end

-- M.clast = function()
--   vim.cmd('clast')
-- end

-- M.cpfile = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'cpfile')
-- end

-- M.cnfile = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'cnfile')
-- end

-- M.tprevious = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'tprevious')
-- end

-- M.tnext = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'tnext')
-- end

-- M.tfirst = function()
--   vim.cmd('tfirst')
-- end

-- M.tlast = function()
--   vim.cmd('tlast')
-- end

-- M.ptprevious = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'ptprevious')
-- end

-- M.ptnext = function()
--   vim.cmd('silent! ' .. vim.v.count1 .. 'ptnext')
-- end

-- local get_current_wininfo = function()
--   return vim.fn.getwininfo(vim.fn.win_getid())[1]
-- end

-- M.enable_background = function()
--   vim.o.background = 'light'
-- end

-- M.disable_background = function()
--   vim.o.background = 'dark'
-- end

-- M.enable_diff = function()
--   vim.cmd('diffthis')
-- end

-- M.disable_diff = function()
--   vim.cmd('diffoff')
-- end

-- M.enable_hlsearch = function()
--   vim.o.hlsearch = true
-- end

-- M.disable_hlsearch = function()
--   vim.o.hlsearch = false
-- end

-- M.toggle_hlsearch = function()
--   vim.o.hlsearch = not vim.o.hlsearch
-- end

-- M.enable_ignorecase = function()
--   vim.o.ignorecase = true
-- end

-- M.disable_ignorecase = function()
--   vim.o.ignorecase = false
-- end

-- M.toggle_ignorecase = function()
--   vim.o.ignorecase = not vim.o.ignorecase
-- end

-- M.enable_list = function()
--   vim.o.list = true
-- end

-- M.disable_list = function()
--   vim.o.list = false
-- end

-- M.toggle_list = function()
--   vim.o.list = not vim.o.list
-- end

-- M.enable_number = function()
--   vim.o.number = true
-- end

-- M.disable_number = function()
--   vim.o.number = false
-- end

-- M.toggle_number = function()
--   vim.o.number = not vim.o.number
-- end

-- M.enable_relativenumber = function()
--   vim.o.relativenumber = true
-- end

-- M.disable_relativenumber = function()
--   vim.o.relativenumber = false
-- end

-- M.toggle_relativenumber = function()
--   vim.o.relativenumber = not vim.o.relativenumber
-- end

-- M.enable_spell = function()
--   vim.o.spell = true
-- end

-- M.disable_spell = function()
--   vim.o.spell = false
-- end

-- M.toggle_spell = function()
--   vim.o.spell = not vim.o.spell
-- end

-- M.enable_colorcolumn = function()
--   vim.o.colorcolumn = '+1'
-- end

-- M.disable_colorcolumn = function()
--   vim.o.colorcolumn = ''
-- end

-- M.enable_virtualedit = function()
--   vim.o.virtualedit = 'all'
-- end

-- M.disable_virtualedit = function()
--   vim.o.virtualedit = ''
-- end

-- M.enable_wrap = function()
--   vim.o.wrap = true
-- end

-- M.disable_wrap = function()
--   vim.o.wrap = false
-- end

-- M.toggle_wrap = function()
--   vim.o.wrap = not vim.o.wrap
-- end

-- local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup

-- local state = {
--   paste = nil,
--   mouse = nil,
-- }

-- M.paste_above = function()
--   setup_paste()
--   return 'O'
-- end

-- M.paste_below = function()
--   setup_paste()
--   return 'o'
-- end
