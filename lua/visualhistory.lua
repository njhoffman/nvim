local visual_history = {}
visual_history.loaded_visual_history = 1
visual_history.vis_mark_record = {}
visual_history.vis_mark_record_pointer = 0
visual_history.old_number_of_lines = vim.fn.line('$')
visual_history.record_length = vim.g.visual_history_length or 100
visual_history.reselecting = 0
visual_history.selection_check_count = 3

function visual_history.update_pointer(direction)
  direction = direction
  if direction == 'first' then
    visual_history.vis_mark_record_pointer = 1
  elseif direction == 'last' then
    visual_history.vis_mark_record_pointer = #visual_history.vis_mark_record - 1
  else
    direction = direction * vim.v.count1
    if visual_history.vis_mark_record_pointer + direction <= 1 then
      visual_history.vis_mark_record_pointer = 1
    elseif visual_history.vis_mark_record_pointer + direction >= #visual_history.vis_mark_record then
      visual_history.vis_mark_record_pointer = #visual_history.vis_mark_record - 1
    else
      visual_history.vis_mark_record_pointer = visual_history.vis_mark_record_pointer + direction
    end
  end
end

function visual_history.initialise_variables(reset)
  if reset == 1 or #visual_history.vis_mark_record == 0 then
    visual_history.vis_mark_record = {}
    visual_history.vis_mark_record_pointer = 0
    visual_history.old_number_of_lines = vim.fn.line('$')
    visual_history.record_length = vim.g.visual_history_length or 100
  end
  visual_history.reselecting = 0
  visual_history.selection_check_count = 3
end

-- Rest of your functions here, translated similarly
-- ...
local function get_visual_position()
    local mode = vim.api.nvim_get_mode().mode
    local l1, l2, c1, c2

    if mode == 'v' or mode == 'V' or mode == "\\<C-V>" then
        _, l1, c1 = unpack(vim.fn.getpos("v"))
        _, l2, c2 = unpack(vim.fn.getpos("."))
    else
        _, l1, c1 = unpack(vim.fn.getpos("'<"))
        _, l2, c2 = unpack(vim.fn.getpos("'>"))
        mode = vim.api.nvim_get_option('visualmode')
    end

    c1 = (c1 == 0) and 1 or c1
    c1 = (c1 > 1000) and vim.fn.strlen(vim.api.nvim_buf_get_lines(0, l1, l1, false)[1]) or c1
    c2 = (c2 == 0) and 1 or c2
    c2 = (c2 > 1000) and vim.fn.strlen(vim.api.nvim_buf_get_lines(0, l2, l2, false)[1]) or c2

    return {{l1, c1}, {l2, c2}, mode}
end

local function add_record_entry(vis_pos)
    buf = vim.api.nvim_get_current_buf()
    local vis_mark_record = vim.api.nvim_buf_get_var(buf, 'vis_mark_record')

    if #vis_mark_record == 0 or vis_mark_record[#vis_mark_record] ~= vis_pos then
        table.insert(vis_mark_record, vis_pos)
        vim.api.nvim_buf_set_var(buf, 'vis_mark_record', vis_mark_record)
        update_pointer(1)
    end
end

local function remove_record_entry(entry_number)
    buf = vim.api.nvim_get_current_buf()
    local vis_mark_record = vim.api.nvim_buf_get_var(buf, 'vis_mark_record')
    table.remove(vis_mark_record, entry_number)
    vim.api.nvim_buf_set_var(buf, 'vis_mark_record', vis_mark_record)

    local vis_mark_record_pointer = vim.api.nvim_buf_get_var(buf, 'vis_mark_record_pointer')
    if vis_mark_record_pointer >= entry_number then
        vim.api.nvim_buf_set_var(buf, 'vis_mark_record_pointer', vis_mark_record_pointer - 1)
    end
end

local function extract_record_entry()
    local l1 = vim.g.vis_mark_record[vim.g.vis_mark_record_pointer][1][1]
    local c1 = vim.g.vis_mark_record[vim.g.vis_mark_record_pointer][1][2]
    local l2 = vim.g.vis_mark_record[vim.g.vis_mark_record_pointer][2][1]
    local c2 = vim.g.vis_mark_record[vim.g.vis_mark_record_pointer][2][2]
    local vis_mode = vim.g.vis_mark_record[vim.g.vis_mark_record_pointer][3]
    return {l1, c1, l2, c2, vis_mode}
end

local function selection_checks(_switch)
    if vim.v.event["ModeChanged"] ~= nil then
       if type(_switch) == "number" then
          vim.g.selection_check_count = _switch
       end
       vim.g.selection_check_count = vim.g.selection_check_count - 1
    end
    return vim.g.selection_check_count
end

local function update_record()
    if vim.g.reselecting == 1 then
       vim.g.reselecting = 0
       return
    end
    local vis_pos = vim.fn.get_visual_position()
    if vis_pos[-1] == 'v' or vis_pos[-1] == 'V' or vis_pos[-1] == "\\<C-V>" then
        -- do nothing
    else
        vis_pos[-1] = 'v'
    end
    vim.fn.add_record_entry(vis_pos)
end


function lines_added_or_removed()
    local current_number_of_lines = vim.fn.line("$")
    local difference = current_number_of_lines - vim.b.old_number_of_lines
    vim.b.old_number_of_lines = current_number_of_lines
    return difference
end

function sync_record()
    local difference = lines_added_or_removed()
    _G.difference = difference
    if difference == 0 then
        return
    else
        local first_changed_line = vim.fn.getpos("'<")[2]
        local last_changed_line = vim.fn.getpos("'>")[2]
        local record_count = 0
        for record_index, record in ipairs(vim.b.vis_mark_record) do
            local overlap1 = record[1][1] - first_changed_line + 1
            local overlap2 = record[2][1] - first_changed_line + 1
            if (overlap1 > 0 and overlap1 <= -difference) and (overlap2 > 0 and overlap2 <= -difference) then
                table.remove(vim.b.vis_mark_record, record_index)
                record_count = record_count - 1
            elseif overlap1 > 0 and overlap1 <= -difference then
                vim.b.vis_mark_record[record_count][1][1] = last_changed_line
                vim.b.vis_mark_record[record_count][2][1] = vim.b.vis_mark_record[record_count][2][1] + difference
            elseif record[1][1] >= first_changed_line then
                vim.b.vis_mark_record[record_count][1][1] = vim.b.vis_mark_record[record_count][1][1] + difference
                vim.b.vis_mark_record[record_count][2][1] = vim.b.vis_mark_record[record_count][2][1] + difference
            elseif record[2][1] >= first_changed_line then
                vim.b.vis_mark_record[record_count][2][1] = vim.b.vis_mark_record[record_count][2][1] + difference
            end
            record_count = record_count + 1
        end
    end
end


function reselect_visual_from_record(direction)
    if #vim.b.vis_mark_record == 1 and vim.b.vis_mark_record[1][3] == '' then
        vim.cmd("normal! gv")
        return
    end
    update_pointer(direction)
    vim.b.reselecting = 1
    local l1, c1, l2, c2, vis_mode = extract_record_entry()
    vim.cmd("normal! \\<ESC>")
    vim.api.nvim_win_set_cursor(0, {l1, c1 - 1})
    vim.cmd("normal! "..vis_mode)
    vim.api.nvim_win_set_cursor(0, {l2, c2 - 1})
end

-- Create mappings command
-- If using the latest version of Neovim (0.5+), use:
vim.api.nvim_set_keymap('v', '[v', ':lua visual_history.SelectPrevious()<CR>', {noremap=true, silent=true})

-- Else you can register it using `nvim_exec` but that's not recommended:
-- vim.api.nvim_exec("vmap <silent> [v :lua visual_history.SelectPrevious()<CR>", false)

-- Register auto commands
vim.api.nvim_exec([[
  augroup VisualHistory
    autocmd!
    autocmd BufEnter * lua visual_history.initialise_variables(0)
  augroup END
]], false)

-- "{{{- set up autocmds ---------------------------------------------------------
-- autocmd BufEnter                  * call <SID>initialise_variables(0)
-- autocmd TextChanged,InsertLeave   * call <SID>sync_record()
-- autocmd CursorMoved               * call <SID>update_record()
--
-- " if exists("##ModeChanged")
-- "     autocmd ModeChanged *:[vV]    call <SID>selection_checks(0)
-- "     autocmd ModeChanged [vV]:*    call <SID>selection_checks(3)
-- " endif
-- "}}}---------------------------------------------------------------------------
--
-- "{{{- define plug function calls ----------------------------------------------
-- vnoremap <silent> <Plug>(SelectPrevious) :<C-U>call <SID>reselect_visual_from_record(-1)<CR>
-- vnoremap <silent> <Plug>(SelectNext)     :<C-U>call <SID>reselect_visual_from_record(1)<CR>
-- vnoremap <silent> <Plug>(SelectFirst)    :<C-U>call <SID>reselect_visual_from_record('first')<CR>
-- vnoremap <silent> <Plug>(SelectLast)     :<C-U>call <SID>reselect_visual_from_record('last')<CR>
--
-- nnoremap <silent> <Plug>(SelectPrevious) :<C-U>call <SID>reselect_visual_from_record(-1)<CR>
-- nnoremap <silent> <Plug>(SelectNext)     :<C-U>call <SID>reselect_visual_from_record(1)<CR>
-- nnoremap <silent> <Plug>(SelectFirst)    :<C-U>call <SID>reselect_visual_from_record('first')<CR>
-- nnoremap <silent> <Plug>(SelectLast)     :<C-U>call <SID>reselect_visual_from_record('last')<CR>
-- "}}}---------------------------------------------------------------------------
--
-- "{{{- create maps and text objects --------------------------------------------
-- if !exists("g:visual_history_create_mappings") || g:visual_history_create_mappings != 0
--
--     " visual mode commands
--     vmap <silent> [v <Plug>(SelectPrevious)
--     vmap <silent> ]v <Plug>(SelectNext)
--     vmap <silent> [V <Plug>(SelectFirst)
--     vmap <silent> ]V <Plug>(SelectLast)
--
--     " normal mode commands
--     nmap <silent> [v <Plug>(SelectPrevious)
--     nmap <silent> ]v <Plug>(SelectNext)
--     nmap <silent> [V <Plug>(SelectFirst)
--     nmap <silent> ]V <Plug>(SelectLast)
--
--     if !exists(":ClearVisualHistory")
--         command ClearVisualHistory :call s:initialise_variables(1)
--     endif
-- endif
