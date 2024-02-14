local M = {}
function M.save_all_sessions()
  require('trailblazer.trails.stacks').add_stack()
  local buffers = require('trailblazer.trails.stacks').create_buf_file_lookup_table(true)
  if vim.tbl_isempty(buffers) then
    local open_bufs = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_loaded(buf)
    end, vim.api.nvim_list_bufs())

    for _, buffer in ipairs(open_bufs) do
      local buf_name = vim.api.nvim_buf_get_name(buffer)
      local file = vim.fn.expand(
        require('trailblazer').options.custom_session_storage_dir
          .. vim.fn.sha256(tostring(vim.fn.expand(buf_name)))
          .. '.tbsv'
      )
      if vim.fn.filereadable(file) == 1 then
        vim.fn.delete(file)
      end
    end
  else
    for _, buf in ipairs(buffers) do
      M.save_session(buf)
    end
  end
end

function M.save_session(buf)
  buf = buf or vim.api.nvim_buf_get_name(0)
  local file = require('trailblazer').options.custom_session_storage_dir
    .. vim.fn.sha256(tostring(vim.fn.expand(buf)))
    .. '.tbsv'
  require('trailblazer').save_trailblazer_state_to_file(file, nil, false)
end

local autocmd = vim.api.nvim_create_autocmd
autocmd('User', {
  pattern = 'TrailBlazerCurrentTrailMarkStackChanged',
  callback = function(event)
    local line = 'Stacks: '
    for _, stack in ipairs(event.data.available_stacks) do
      if stack == event.data.current_stack then
        line = line .. '[ ' .. stack .. ' ]  '
      else
        line = line .. '  ' .. stack .. '    '
      end
    end

    vim.opt.statusline = line
  end,
})

autocmd('User', {
  pattern = 'TrailBlazerTrailMarkStackSaved',
  callback = function(_)
    vim.notify('Session saved.')
  end,
})

-- autocmd('VimLeavePre', {
--   pattern = '*',
--   callback = function(_)
--     M.save_all_sessions()
--   end,
-- })
--
function M.new_mark()
  local tb = require('trailblazer')
  tb.new_trail_mark()
  tb.open_trail_mark_list()
  vim.cmd('wincmd p')
end

function M.load_session()
  local tb = require('trailblazer')
  local file = tb.options.custom_session_storage_dir
    .. vim.fn.sha256(vim.fn.expand(vim.api.nvim_buf_get_name(0)))
    .. '.tbsv'
  tb.load_trailblazer_state_from_file(file, false)
  tb.open_trail_mark_list()
  vim.cmd('wincmd p')
end

function M.add_stack()
  vim.ui.input({ prompt = 'Stack Name: ' }, function(input)
    require('trailblazer').switch_trail_mark_stack(input, false)
  end)
end

function M.delete_all_marks()
  local tb = require('trailblazer')
  tb.close_trail_mark_list()
  tb.delete_all_trail_marks()
  vim.opt.statusline = ' '
end

return M
