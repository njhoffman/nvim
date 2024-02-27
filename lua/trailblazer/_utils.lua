local get_buffers = function()
  local bufnrs = filter(function(b)
    return 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  -- local bufnames = map(function(bufnr)
  -- return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:t'))
  -- end, bufnrs)

  -- local dirs = map(function(bufnr)
  -- local dir_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h') .. '/'
  -- return dir_name:gsub(os.getenv('HOME'), '~')
  -- end, bufnrs)
  return bufnrs
end

local get_changes = function()
  --
  -- refresh changes list
  --:%delete _
  --:undo

  local lines = {}
  local changes = vim.api.nvim_command_output('changes')
  for change in changes:gmatch('[^\r\n]+') do
    table.insert(lines, change)
  end
  return lines
end

local get_undos = function()
  local ut = vim.fn.undotree()
  -- TODO: maybe use this opportunity to limit the number of root nodes we process overall, to ensure good performance
  -- local undolist = _traverse_undotree(opts, ut.entries, 0)
  local undolist = {}
  -- create diffs for each entry in our undotree
  for i = #entries, 1, -1 do
    if opts.save ~= nil and opts.save and entries[i].save == nil then
    end
  end

  -- au BufReadPost * call ReadUndo()
  -- au BufWritePost * call WriteUndo()
  -- func ReadUndo()
  -- if filereadable(expand('%:h') .. '/UNDO/' .. expand('%:t'))
  -- rundo %:h/UNDO/%:t
  -- endif
  -- endfunc
  -- func WriteUndo()
  -- let dirname = expand('%:h') .. '/UNDO'
  -- if !isdirectory(dirname)
  -- call mkdir(dirname)
  -- endif
  -- wundo %:h/UNDO/%:t
  -- endfunc

  -- :let old_undolevels = &l:undolevels
  -- :setlocal undolevels=-1
  -- :exe "normal a \<BS>\<Esc>"
  -- :let &l:undolevels = old_undolevels
  -- :unlet old_undolevels
  --[[ :undojoin | delete

  After this a "u" command will undo the delete command and the previous
  change. ]]
end

local get_jumps = function()
  local jumps = vim.api.nvim_command_output('jumps')
  local lines = {}
  for jump in jumps:gmatch('[^\r\n]+') do
    table.insert(lines, jump)
  end
  return lines
end

local hist_trails = function(opts)
  -- local bufnrs = = get_buffers()
  local bufnrs = { vim.api.nvim_get_current_buf() }
end

--[[ return {
  get_buffers = get_buffers,
  get_changes = get_changes,
  get_undos = get_undos,
  get_jumps = get_jumps,
  hist_trails = hist_trails,
} ]]
