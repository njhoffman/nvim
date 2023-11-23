local function visual_paste_without_yank()
  local register = '+'

  if vim.o.clipboard == 'unnamed' then
    register = '*'
  end
  local content = vim.fn.getreg(register)
  local lines = vim.fn.split(content, '\n')

  vim.fn.setreg('x', vim.fn.getreg(register))
  vim.api.nvim_paste(content, true, -1)
  vim.fn.setreg(register, vim.fn.getreg('x'))
end

-- vim.keymap.set("x", "p", '"_dP', { desc = "don't replace register when pasting" })

-- " This one may be a little better (strip the ending new-line before pasting)
vim.cmd([[:nmap <M-C-P> :call append(line('.'), substitute(@", '\n$', '', ''))<CR>]])

-- TODO: combine paste history selection (gp) with extended visual selection history
-- local map = require("mapper").map
-- map({ "n" }, "[[", "`[v`]", { category = "Visual select", desc = "select next visual selection " })
-- map({ "n" }, "]]", "`[v`]", { category = "Visual select", desc = "select next visual selection " })
-- vim.cmd("nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'")
-- '[* *`[

-- vim.cmd(-[[
--   nnoremap [[ `[v`]
--   nnoremap ]] `[V`]
-- ]])

return { visual_paste_without_yank = visual_paste_without_yank }

-- nnoremap gp `[v`]
-- nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

-- keep track of pasted text in a list
-- nmap p :call Paster()<CR>
-- nmap '; :call LastPasted()<CR>
-- nmap y :call ClearList()<CR>
--
-- let s:linelist=[]
-- let s:lastidx=len(s:linelist)
-- if !exists("*Paster")
--     function! Paster()
--         let x=getpos(".")
--         let s:linelist+=[x]
--         let s:lastidx=len(s:linelist)
--         if s:lastidx>50
--             remove(s:linelist,0)
--             let s:lastidx-=1
--         endif
--         "echo s:linelist
--         exec "normal! \"0gp"
--     endfunction
-- endif
-- if !exists("*LastPasted")
--     function! LastPasted()
--         if s:lastidx>0
--             let s:lastidx=s:lastidx-1
--         else
--             let s:lastidx=len(s:linelist)-1
--         endif
--         let pos=s:linelist[s:lastidx-1]
--         call setpos(".",pos)
--     endfunction
-- endif
-- if !exists("*ClearList")
--     function! ClearList()
--         let s:linelist=[getpos(".")]
--         let s:lastidx=0
--         exec "normal! :y\<CR>"
--     endfunction
-- endif
--

-- :nmap <F4> :call append(line('.'), @")<CR>
--
-- " This one may be a little better (strip the ending new-line before pasting)
-- :nmap <F4> :call append(line('.'), substitute(@", '\n$', '', ''))<CR>

-- -- ===================
-- vim.keymap.set("n", "J", "mzJ`z") -- Retain cursor position on line join w J
--
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank until EOL to system clipboard" })
--
-- -- Delete into oblivion 😈
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete selection, send to NULL register" })
--
-- -- Replace selection, sending it into oblivion 🙈
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Replace selection, send to NULL register" })
--

-- local cursor_pos
-- autocmds.yankpost = {
--   save_cursor_position = {
--     event = { "VimEnter", "CursorMoved" },
--     pattern = "*",
--     callback = function()
--       cursor_pos = vim.fn.getpos(".")
--     end,
--   },
--
--   highlight_yank = {
--     event = "TextYankPost",
--     pattern = "*",
--     callback = function()
--       vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_visual = true })
--     end,
--   },
--
--   yank_restore_cursor = {
--     event = "TextYankPost",
--     pattern = "*",
--     callback = function()
--       local cursor = vim.fn.getpos(".")
--       if vim.v.event.operator == "y" then
--         vim.fn.setpos(".", cursor_pos)
--       end
--     end,
--   },
-- }
--
-- -- If invoked as a preview callback, performs 'inccommand' preview by
-- -- highlighting trailing whitespace in the current buffer.
-- local function trim_space_preview(opts, preview_ns, preview_buf)
--   local line1 = opts.line1
--   local line2 = opts.line2
--   local buf = vim.api.nvim_get_current_buf()
--   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
--   local preview_buf_line = 0
--
--   for i, line in ipairs(lines) do
--     local start_idx, end_idx = string.find(line, '%s+$')
--
--     if start_idx then
--       -- Highlight the match
--       vim.api.nvim_buf_add_highlight(
--         buf,
--         preview_ns,
--         'Substitute',
--         line1 + i - 2,
--         start_idx - 1,
--         end_idx
--       )
--
--       -- Add lines and set highlights in the preview buffer
--       -- if inccommand=split
--       if preview_buf then
--         local prefix = string.format('|%d| ', line1 + i - 1)
--
--         vim.api.nvim_buf_set_lines(
--           preview_buf,
--           preview_buf_line,
--           preview_buf_line,
--           false,
--           { prefix .. line }
--         )
--         vim.api.nvim_buf_add_highlight(
--           preview_buf,
--           preview_ns,
--           'Substitute',
--           preview_buf_line,
--           #prefix + start_idx - 1,
--           #prefix + end_idx
--         )
--         preview_buf_line = preview_buf_line + 1
--       end
--     end
--   end
--
--   -- Return the value of the preview type
--   return 2
-- end
--
-- -- Trims all trailing whitespace in the current buffer.
-- local function trim_space(opts)
--   local line1 = opts.line1
--   local line2 = opts.line2
--   local buf = vim.api.nvim_get_current_buf()
--   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
--
--   local new_lines = {}
--   for i, line in ipairs(lines) do
--     new_lines[i] = string.gsub(line, '%s+$', '')
--   end
--   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, new_lines)
-- end
--
-- -- Create the user command
-- vim.api.nvim_create_user_command(
--   'TrimTrailingWhitespace',
--   trim_space,
--   { nargs = '?', range = '%', addr = 'lines', preview = trim_space_preview }
-- )
-- <
--
