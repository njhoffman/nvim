-- navigate with tags
local tagstack_navigate = function(config)
  if not config or not config.direction then
    return
  end
  local direction = config.direction
  local tagstack = vim.fn.gettagstack()
  -- This statement checks for tag items.  Return instead of giving me
  -- an ugly error message
  if tagstack == nil or tagstack.items == nil or #tagstack.items == 0 then
    return
  end
  if direction == 'up' then
    if tagstack.curidx > tagstack.length then
      return
    end
    vim.cmd.tag()
  end
  if direction == 'down' then
    if tagstack.curidx == 1 then
      return
    end
    vim.cmd.pop()
  end
end

local tag_up = function()
  tagstack_navigate({ direction = 'up' })
end
local tag_down = function()
  tagstack_navigate({ direction = 'down' })
end

vim.keymap.set('n', ']t', tag_down, { desc = 'Navigate foward(down) with tagstack' })
vim.keymap.set('n', '[t', tag_up, { desc = 'Navigate backwards(up) with tagstack' })
-- vim.keymap.set('n', '<M-}>', ':pop<cr>', { desc = 'Navigate foward(down) with tagstack' })
-- map <C-[> :pop<CR>

--
-- function! MyGoToDefinition(...) abort
--   " ref: https://github.com/davidhalter/jedi-vim/blob/master/pythonx/jedi_vim.py#L329-L345
--
--   " Get the current position
--   let pos = {
--           \ 'fname': expand('%:p'),
--           \ 'line': line("."),
--           \ 'col': col("."),
--           \ 'word': expand("<cword>")
--           \ }
--
--   call LanguageClient#textDocument_definition({'handle': v:true}, function('MyGoToDefinitionCallback', [pos]))
-- endfunction
--
-- function! MyGoToDefinitionCallback(pos, ...) abort
--   " Get the original position
--   let l:fname = a:pos['fname']
--   let l:line = a:pos['line']
--   let l:col = a:pos['col']
--   let l:word = a:pos['word']
--
--   " Get the position of definition
--   let l:jump_fname = expand('%:p')
--   let l:jump_line = line(".")
--   let l:jump_col = col(".")
--
--   " If the position is the same as previous, ignore the jump action
--   if l:fname == l:jump_fname && l:line == l:jump_line
--     return
--   endif
--
--   " Workaround: Jump to origial file. If the function is in rust, there is a
--   " way to ignore the behaviour
--   if &modified
--     exec 'hide edit'  l:fname
--   else
--     exec 'edit' l:fname
--   endif
--   call cursor(l:line, l:col)
--
--   " Write a temp tags file
--   let l:temp_tags_fname = tempname()
--   let l:temp_tags_content = printf("%s\t%s\t%s", l:word, l:jump_fname,
--       \ printf("call cursor(%d, %d)", l:jump_line, l:jump_col))
--   call writefile([l:temp_tags_content], l:temp_tags_fname)
--
--   " Store the original setting
--   let l:ori_wildignore = &wildignore
--   let l:ori_tags = &tags
--
--   " Set temporary new setting
--   set wildignore=
--   let &tags = l:temp_tags_fname
--
--   " Add to new stack
--   execute ":tjump " . l:word
--
--   " Restore original setting
--   let &tags = l:ori_tags
--   let &wildignore = l:ori_wildignore
--
--   " Remove temporary file
--   if filereadable(l:temp_tags_fname)
--     call delete(l:temp_tags_fname, "rf")
--   endif
-- endfunction

-- edited
-- The jedi-vim uses a trick to insert tags into vim's original stack. The benefit of the method is that the implementation does not need to manipulate a stack to memory user's behaviour.
--
-- But the function is still vim version. In next step, I would lean rust in my free time and try to write rust version.
--
--
-- function! MyGoToDefinition(...) abort
--   " ref: https://github.com/davidhalter/jedi-vim/blob/master/pythonx/jedi_vim.py#L329-L345
--
--   " Get the current position
--   let l:fname = expand('%:p')
--   let l:line = line(".")
--   let l:col = col(".")
--   let l:word = expand("<cword>")
--
--   " Call the original function to jump to the definition
--   let l:result = LanguageClient_runSync(
--                   \ 'LanguageClient#textDocument_definition', {
--                   \ 'handle': v:true,
--                   \ })
--
--   " Get the position of definition
--   let l:jump_fname = expand('%:p')
--   let l:jump_line = line(".")
--   let l:jump_col = col(".")
--
--   " If the position is the same as previous, ignore the jump action
--   if l:fname == l:jump_fname && l:line == l:jump_line
--     return
--   endif
--
--   " Workaround: Jump to origial file. If the function is in rust, there is a
--   " way to ignore the behaviour
--   if &modified
--     exec 'hide edit'  l:fname
--   else
--     exec 'edit' l:fname
--   endif
--   call cursor(l:line, l:col)
--
--   " Store the original setting
--   let l:ori_wildignore = &wildignore
--   let l:ori_tags = &tags
--
--   " Write a temp tags file
--   let l:temp_tags_fname = tempname()
--   let l:temp_tags_content = printf("%s\t%s\t%s", l:word, l:jump_fname,
--       \ printf("call cursor(%d, %d)", l:jump_line, l:jump_col+1))
--   call writefile([l:temp_tags_content], l:temp_tags_fname)
--
--   " Set temporary new setting
--   set wildignore=
--   let &tags = l:temp_tags_fname
--
--   " Add to new stack
--   execute ":tjump " . l:word
--
--   " Restore original setting
--   let &tags = l:ori_tags
--   let &wildignore = l:ori_wildignore
--
--   " Remove temporary file
--   if filereadable(l:temp_tags_fname)
--     call delete(l:temp_tags_fname, "rf")
--   endif
-- endfunction
--
-- nnoremap gd :call MyGoToDefinition()<cr>
-- -- M.tagstack = function(opts)
-- --   opts = opts or {}
-- --   local tagstack = vim.fn.gettagstack()
-- --   if vim.tbl_isempty(tagstack.items) then
-- --     return
-- --   end
-- --
-- --   for i, value in pairs(tagstack.items) do
-- --     value.text = value.tagname
-- --     value.lnum = value.from[2]
-- --     value.filename = vim.fn.bufname(value.from[1])
-- --   end
-- --
-- --   -- reverse the list
-- --   tags = {}
-- --   for i=#tagstack.items, 1, -1 do
-- --     tags[#tags+1] = tagstack.items[i]
-- --   end
-- --
-- --   pickers.new(opts, {
-- --       prompt_title = 'TagStack',
-- --       finder = finders.new_table {
-- --         results = tags,
-- --         entry_maker = make_entry.gen_from_quickfix(opts),
-- --       },
-- --       previewer = previewers.qflist.new(opts),
-- --       sorter = conf.generic_sorter(opts),
-- --     }):find()
-- -- end
--

-- edited
-- The jedi-vim uses a trick to insert tags into vim's original stack. The benefit of the method is that the implementation does not need to manipulate a stack to memory user's behaviour.
--
-- But the function is still vim version. In next step, I would lean rust in my free time and try to write rust version.
--
--
-- function! MyGoToDefinition(...) abort
--   " ref: https://github.com/davidhalter/jedi-vim/blob/master/pythonx/jedi_vim.py#L329-L345
--
--   " Get the current position
--   let l:fname = expand('%:p')
--   let l:line = line(".")
--   let l:col = col(".")
--   let l:word = expand("<cword>")
--
--   " Call the original function to jump to the definition
--   let l:result = LanguageClient_runSync(
--                   \ 'LanguageClient#textDocument_definition', {
--                   \ 'handle': v:true,
--                   \ })
--
--   " Get the position of definition
--   let l:jump_fname = expand('%:p')
--   let l:jump_line = line(".")
--   let l:jump_col = col(".")
--
--   " If the position is the same as previous, ignore the jump action
--   if l:fname == l:jump_fname && l:line == l:jump_line
--     return
--   endif
--
--   " Workaround: Jump to origial file. If the function is in rust, there is a
--   " way to ignore the behaviour
--   if &modified
--     exec 'hide edit'  l:fname
--   else
--     exec 'edit' l:fname
--   endif
--   call cursor(l:line, l:col)
--
--   " Store the original setting
--   let l:ori_wildignore = &wildignore
--   let l:ori_tags = &tags
--
--   " Write a temp tags file
--   let l:temp_tags_fname = tempname()
--   let l:temp_tags_content = printf("%s\t%s\t%s", l:word, l:jump_fname,
--       \ printf("call cursor(%d, %d)", l:jump_line, l:jump_col+1))
--   call writefile([l:temp_tags_content], l:temp_tags_fname)
--
--   " Set temporary new setting
--   set wildignore=
--   let &tags = l:temp_tags_fname
--
--   " Add to new stack
--   execute ":tjump " . l:word
--
--   " Restore original setting
--   let &tags = l:ori_tags
--   let &wildignore = l:ori_wildignore
--
--   " Remove temporary file
--   if filereadable(l:temp_tags_fname)
--     call delete(l:temp_tags_fname, "rf")
--   endif
-- endfunction
--
-- nnoremap gd :call MyGoToDefinition()<cr>
