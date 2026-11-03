local function get_loaded_buffers()
  local buffers = {}
  local len = 0
  local vim_fn = vim.fn
  local buflisted = vim_fn.buflisted

  for buffer = 1, vim_fn.bufnr("$") do
    if buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

local function numberOfWins()
  local count = 0
  local wins = vim.api.nvim_list_wins()
  for _, win in pairs(wins) do
    local winConf = vim.api.nvim_win_get_config(win)
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))

    if
      bufname
      and bufname ~= ""
      and not winConf.external
      and winConf.focusable
      and vim.api.nvim_win_is_valid(win)
    then
      count = count + 1
    end
  end
  return count
end

local get_splits = function(directions)
  -- let window_count = winnr('$')
  -- let prev_window = winnr('#')

  -- these ft will not window close on delete
  local ignored_splits_ft = {
    "CompetiTest",
    "Mundo",
    "MundoDiff",
    "NvimTree",
    "SidebarNvim",
    "Trouble",
    "aerial",
    "NeoTree",
    "nerdtree",
    "query",
  }

  local splits = {}
  local curwin = vim.fn.winnr()
  for _, dir in ipairs(directions) do
    local testwin = vim.fn.winnr(dir)
    local testwinid = vim.fn.win_getid(testwin)
    if curwin ~= testwinid and not vim.tbl_contains(splits, testwinid) then
      local bufid = vim.api.nvim_win_get_buf(testwinid)
      -- local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufid })
      if not vim.tbl_contains(ignored_splits_ft, ft) then
        table.insert(splits, testwinid)
      end
    end
  end
  return splits
end

return {
  get_splits = get_splits,
  get_loaded_buffers = get_loaded_buffers,
}
