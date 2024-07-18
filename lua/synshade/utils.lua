local utils = {}

--- Verify the version of Neovim running has `nvim_win_set_hl_ns`, added via !13457
---
---@return boolean # whether or not the running Neovim instance has the functions necessary for this function to run
utils.verify_version = function()
  if not vim.api.nvim_win_set_hl_ns then
    vim.notify(
      "synshade.nvim requires a newer version of Neovim that provides 'nvim_win_set_hl_ns'",
      vim.lsp.log_levels.ERROR
    )
    return false
  end
  return true
end

--- Iterate all windows in all tabpages and call the passed function on them
---
---@param iter_func function(winid: number, tabpage: number) called for every valid tabpage and contained window
utils.iterate_all_windows = function(iter_func)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.api.nvim_tabpage_is_valid(tabpage) then
      for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        if vim.api.nvim_win_is_valid(winid) then
          iter_func(winid, tabpage)
        end
      end
    end
  end
end

return utils
