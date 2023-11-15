local state = require('hover.state')

local function get_title(active_provider_id)
  local title = {}
  local width = 0
  for _, p in ipairs(state.providers) do
    if p._enabled then
      local hl = p.id == active_provider_id and 'TabLineSel' or 'TabLineFill'
      title[#title + 1] = string.format('%%#%s# %s ', hl, p.name)
      title[#title + 1] = '%#Normal# '
      width = width + #p.name + 3
    end
  end
  local title_str = table.concat(title, '')
  return title_str, width
end

local function add_title()
  local win_ok, _ = pcall(vim.api.nvim_win_is_valid, state.winnr)
  if win_ok then
    local active_provider_id = state.enabled[state.curr_idx]
    local title_str, width = get_title(active_provider_id)
    -- if string.len(vim.trim(title_str)) > 0 then
    --   local win_height = vim.api.nvim_win_get_height(state.winnr)
    --   vim.api.nvim_win_set_height(state.winnr, win_height)
    -- end
    if width > state.width then
      vim.api.nvim_win_set_width(state.winnr, width + 1)
      state.width = width + 1
    end
    vim.wo[state.winnr].winbar = type(title_str) == 'string' and title_str or '...'
  end
end

return { get_title = get_title, add_title = add_title }
