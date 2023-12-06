local function get_loaded_buffers()
  local buffers = {}
  local len = 0
  local vim_fn = vim.fn
  local buflisted = vim_fn.buflisted

  for buffer = 1, vim_fn.bufnr('$') do
    if buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

local function check_nav_split(movement_key)
  local keymap = { h = { '-L' }, l = { '-R' }, k = { '-U' }, j = { '-D' } }
  return function()
    local curr_win = vim.fn.winnr()
    local mapkeys = keymap[movement_key]
    local keys = { tmux_view = mapkeys[1] }
    -- only check one direction for split if navigating
    if vim.fn.winnr(movement_key) ~= curr_win then
      vim.cmd('wincmd ' .. movement_key)
    else
      vim.fn.system('tmux select-pane ' .. keys.tmux_view)
    end
  end
end

local function check_resize_split(navigation_key)
  local keymap = {
    h = { '-L 2', '2>', 'l', '2<' },
    l = { '-R 2', '2<', 'h', '2>' },
    k = { '-U 1', '1-', 'j', '1+' },
    j = { '-D 1', '1+', 'k', '1-' },
  }
  return function()
    local curr_win = vim.fn.winnr()
    local mapkeys = keymap[navigation_key]
    local keys = {
      tmux_resize = mapkeys[1],
      vim_resize = mapkeys[2],
      alt_nav = mapkeys[3],
      alt_resize = mapkeys[4],
    }

    local has_split = vim.fn.winnr(navigation_key) ~= curr_win
    local alt_split = vim.fn.winnr(keys.alt_nav) ~= curr_win

    if has_split then
      vim.cmd('wincmd ' .. keys.vim_resize)
    elseif alt_split then
      vim.cmd('wincmd ' .. keys.alt_resize)
    end
    vim.fn.system('tmux resize-pane ' .. keys.tmux_resize)
  end
end

local get_splits = function(directions)
  -- let window_count = winnr('$')
  -- let prev_window = winnr('#')

  -- these ft will not window close on delete
  local ignored_ft = {
    -- 'CompetiTest',
    -- 'Mundo',
    -- 'MundoDiff',
    -- 'NvimTree',
    -- 'SidebarNvim',
    -- 'Trouble',
    -- 'aerial',
    -- 'NeoTree',
    -- 'nerdtree',
    -- 'qf',
    -- 'query',
  }

  local splits = {}
  local curwin = vim.fn.winnr()
  for _, dir in ipairs(directions) do
    local testwin = vim.fn.winnr(dir)
    local testwinid = vim.fn.win_getid(testwin)
    if curwin ~= testwinid and not vim.tbl_contains(splits, testwinid) then
      local bufid = vim.api.nvim_win_get_buf(testwinid)
      local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
      if not vim.tbl_contains(ignored_ft, ft) then
        table.insert(splits, testwinid)
      end
    end
  end
  return splits
end

local close_multi = function(skip_prompt)
  local tabs = vim.api.nvim_list_tabpages() or {}
  local splits = get_splits({ 'l', 'h', 'j', 'k' }, true) or {}
  local curr_win = vim.api.nvim_get_current_win()
  local is_popup = vim.tbl_get(vim.api.nvim_win_get_config(curr_win), 'relative') ~= ''
  if #tabs > 1 then
    vim.cmd('Bdelete')
    vim.cmd('tabclose!')
    return
  end

  if is_popup then
    vim.api.nvim_win_close(curr_win, skip_prompt)
  elseif #splits > 1 then
    vim.api.nvim_win_close(curr_win, skip_prompt)
  else
    if skip_prompt == true then
      vim.cmd('Bdelete!')
      if #get_loaded_buffers() == 0 then
        vim.cmd('exit')
      end
    else
      if #get_loaded_buffers() > 0 then
        vim.cmd('Bdelete')
      end
    end
  end
  if #get_loaded_buffers() == 0 then
    vim.cmd('Alpha')
  end
end

local close_multi_no_prompt = function()
  close_multi(true)
end

local close_popups = function()
  local n = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      n = n + 1
      vim.api.nvim_win_close(win, false)
    end
  end
  print('Closed ' .. n .. ' popup windows')
end

return {
  close_multi = close_multi,
  close_multi_no_prompt = close_multi_no_prompt,
  close_popups = close_popups,
  check_resize_split = check_resize_split,
  check_nav_split = check_nav_split,
}
