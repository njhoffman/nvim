local change_tab = function(direction, winnr)
  local state = require("hover.state")
  local max_idx = #vim.tbl_keys(state.enabled)
  local next_idx = nil
  local curr_idx = nil
  local i = 1
  for _, provider in pairs(state.enabled) do
    if provider.name == state.provider then
      curr_idx = i
    end
    i = i + 1
  end
  if direction == "right" then
    if curr_idx + 1 > max_idx then
      next_idx = 1
    else
      next_idx = curr_idx + 1
    end
  else
    if curr_idx - 1 < 1 then
      next_idx = max_idx
    else
      next_idx = curr_idx - 1
    end
  end

  i = 1
  local next_provider = nil
  for _, provider in pairs(state.enabled) do
    if i == next_idx then
      next_provider = provider
    end
    i = i + 1
  end
  require("hover").hover({ provider = next_provider.name })
end

local scroll_float = function(mapping, winnr)
  if winnr and winnr ~= 0 and vim.api.nvim_win_is_valid(winnr) then
    local scroll_up = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
    if mapping == scroll_up then
      local linenr = vim.api.nvim_win_get_cursor(winnr)[1]
      local scrolloff = vim.api.nvim_get_option("scrolloff")
      local winheight = vim.api.nvim_win_get_height(winnr)
      if linenr > (winheight - scrolloff - 2) then
        vim.fn.win_execute(winnr, "normal! " .. mapping)
      end
    else
      vim.fn.win_execute(winnr, "normal! " .. mapping)
    end
  end
end

local clear = function()
  vim.keymap.del({ "n" }, "q")
  vim.keymap.del({ "n", "i" }, "<S-Right>")
  vim.keymap.del({ "n", "i" }, "<S-Left>")
  vim.keymap.del({ "n", "i" }, "<S-Up>")
  vim.keymap.del({ "n", "i" }, "<S-Down>")
end

local function init(winnr, opts)
  vim.keymap.set({ "n" }, "q", function()
    vim.api.nvim_win_close(winnr, true)
  end, { noremap = true, silent = true })

  local scroll_up = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
  local scroll_down = vim.api.nvim_replace_termcodes("<Down>", true, false, true)

  vim.keymap.set({ "i", "n" }, "<S-Right>", function()
    change_tab("right", winnr)
  end, { noremap = true, silent = true })
  vim.keymap.set({ "i", "n" }, "<S-Left>", function()
    change_tab("left", winnr)
  end, { noremap = true, silent = true })
  vim.keymap.set({ "i", "n" }, "<S-Up>", function()
    scroll_float(scroll_up, winnr)
  end, { noremap = true, silent = true })
  vim.keymap.set({ "i", "n" }, "<S-Down>", function()
    scroll_float(scroll_down, winnr)
  end, { noremap = true, silent = true })
end

return {
  init = init,
  clear = clear,
}
