vim.cmd([[
  highlight default link NotifyERRORCode Error
  highlight default link NotifyERRORMain healthWarning
  highlight default link NotifyERRORFile Comment
  highlight default link NotifyERRORLine Constant
  highlight default link NotifyERRORMessage Title
]])

local find = function(array, key, val)
  for _, v in ipairs(array) do
    if v[key] == val then
      return v
    end
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

local function open_error_file(path, line, orig_map)
  -- vim.api.nvim_set_current_win(currwin)
  -- vim.api.nvim_win_close(notify_win, true)
  if type(orig_map) == 'table' and type(orig_map.lhs) == 'string' then
    pcall(vim.api.nvim_del_keymap, { 'n', 'gF' })
    pcall(vim.api.nvim_set_keymap, {
      orig_map.mode,
      orig_map.lhs,
      orig_map.rhs,
      {
        nowait = orig_map.nowait,
        noremap = orig_map.noremap,
        silent = 1,
      },
    })
  end

  vim.cmd('e +' .. line .. ' ' .. path)
end

local function open_lua_error(line, orig_map)
  local line_parts = vim.fn.split(line, ': \\?')
  if #line_parts > 4 then
    local file = vim.fn.trim(line_parts[3]) or ''
    local num = vim.fn.trim(line_parts[4])
    if vim.fn.split(file, '/')[1] ~= 'home' then
      file = vim.fn.stdpath('config') .. '/' .. file
    end

    if file_exists(file) then
      if vim.v.did_enter == 1 then
        open_error_file(file, num, orig_map)
      else
        -- TODO: loop timer until vim.v.did_enter == 1
        vim.defer_fn(function()
          open_error_file(file, num, orig_map)
        end, 500)
      end
    end
  end
end

local on_open_error = function(win, buf, content)
  local orig_map = find(vim.api.nvim_get_keymap('n'), 'lhs', 'gF')
  local hl = {
    code = 'NotifyERRORCode',
    main = 'NotifyERRORMain',
    file = 'NotifyERRORFile',
    line = 'NotifyERRORLine',
    message = 'NotifyERRORMessage',
  }

  local parts = vim.fn.split(content[1], ':')

  vim.dbglog({ error = content })

  local new_content = {
    parts[1] .. ':' .. parts[2],
    '    ' .. parts[3] .. ':' .. (parts[4] or '') .. ':' .. (parts[5] or ''),
  }
  local line_width = 0
  for _, line in ipairs(new_content) do
    line_width = line_width < #line and #line or line_width
  end
  local max_width = math.floor(vim.opt.columns:get() / 3 * 2)
  local win_width = max_width < line_width and max_width or line_width
  vim.api.nvim_win_set_height(win, #new_content)
  vim.api.nvim_win_set_width(win, win_width)
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, new_content)

  local ns_id = vim.api.nvim_create_namespace('notify')
  local col = #parts[1] + 1
  -- line one:
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, { hl_group = hl.code, end_col = col })
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, col + 1, { hl_group = hl.main, end_col = #new_content[1] })
  -- line two:
  col = #parts[3] + 4
  vim.api.nvim_buf_set_extmark(buf, ns_id, 1, 0, { hl_group = hl.file, end_col = col })
  vim.api.nvim_buf_set_extmark(buf, ns_id, 1, col + 1, { hl_group = hl.line, end_col = col + 1 + #parts[4] })
  col = col + 2 + #parts[4]
  vim.api.nvim_buf_set_extmark(buf, ns_id, 1, col, { hl_group = hl.message, end_col = #new_content[2] })
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.api.nvim_set_keymap('n', 'gF', '', {
    callback = function()
      open_lua_error(content[1], orig_map)
    end,
  })
end

local on_open = function(win)
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_config(win, { zindex = 100 })
  local buf = vim.api.nvim_win_get_buf(win)
  local content = {}
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  for i = 1, #lines do
    if string.gsub(lines[i], '%s+$', '') ~= '' then
      table.insert(content, lines[i])
    end
  end

  if string.match(content[1], '^E51') then
    on_open_error(win, buf, content)
  end
end

return on_open

-- Error executing Lua callback: /home/nicholas/.config/nvim/lua/stats/commands/lazy.lua:17: attempt to index a function value
-- stack traceback:
-- 	/home/nicholas/.config/nvim/lua/stats/commands/lazy.lua:17: in function 'stats'
-- 	/home/nicholas/.config/nvim/lua/stats/init.lua:55: in function </home/nicholas/.config/nvim/lua/stats/init.lua:49>
--
-- E5112: Error while creating lua chunk:
-- E5113: Error while calling lua chunk:
-- E5108: Error executing lua ...scope.nvim/lua/telescope/finders/async_static_finder.lua:20: attempt to index local 'entry' (a function value)
-- E5108: Error executing lua /home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: attempt to call field 'new' (a nil value) stack traceback:
-- E5108: Error executing lua /home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: attempt to call field 'new' (a nil value)
-- stack traceback:
-- 	/home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: in function </home/nicholas/.config/nvim/lua/gitops/core/commits.lua:41>
-- 	/home/nicholas/.config/nvim/lua/telescope/run.lua:99: in function </home/nicholas/.config/nvim/lua/telescope/run.lua:70>
-- 	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:17: in function 'select_picker'
-- 	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:27: in function 'run_replace_or_original'
-- 	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
-- 	...las/.config/nvim/lua/plugs/config/telescope/mappings.lua:13: in function 'key_func'
-- 	...hare/nvim/lazy/telescope.nvim/lua/telescope/mappings.lua:350: in function 'execute_keymap'
-- 	[string ":lua"]:1: in main chunk
-- E5112: Error while creating lua chunk: scratch/tmp_error.lua:4: unexpected symbol near '{'"
-- E5108: Error executing lua ...scope.nvim/lua/telescope/finders/async_static_finder.lua:20: attempt to index local 'entry' (a function value)
-- stack traceback:
-- 	...scope.nvim/lua/telescope/finders/async_static_finder.lua:20: in function 'new_table'
-- 	...lazy/telescope.nvim/lua/telescope/builtin/__internal.lua:1168: in function 'v'
-- 	...lazy/telescope.nvim/lua/telescope/builtin/__internal.lua:1394: in function 'v'
-- 	.../nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:525: in function <.../nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:492>
-- 	/home/nicholas/.config/nvim/lua/telescope/run.lua:97: in function </home/nicholas/.config/nvim/lua/telescope/run.lua:70>
-- 	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:14: in function 'select_picker'
-- 	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:27: in function 'run_replace_or_original'
-- 	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
-- 	...las/.config/nvim/lua/plugs/config/telescope/mappings.lua:13: in function 'key_func'
-- 	...hare/nvim/lazy/telescope.nvim/lua/telescope/mappings.lua:350: in function 'execute_keymap'
-- [string ":lua"]:1: in main chunk
