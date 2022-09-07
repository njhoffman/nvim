local telescope = require("codebox.telescope")

local default_conf = {
  width = 120, -- Width of the floating window
  height = 15, -- Height of the floating window
  border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
  default_mappings = false, -- Bind default mappings
  resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
  debug = false, -- Print debug information
  opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  references = {
    telescope = telescope.has_telescope and telescope.themes.get_dropdown({
      hide_preview = false,
    }) or nil,
  },
  focus_on_open = true, -- Focus the floating window when opening it.
  dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true, -- Whether to nest floating windows
}

local conf = vim.deepcopy(default_conf)

local setup = function(_conf)
  _conf = _conf or {}
  conf = vim.tbl_deep_extend("force", default_conf, _conf) or {}
  return conf
end

return {
  conf = conf,
  width = '80%',
  setup = setup,
  default = default_conf,
  has_telescope = telescope.has_telescope,
  telescope = telescope.has_telescope and {
    themes = telescope.themes,
  } or nil,
  preview_window = nil,
  windows = {},
  anchored = {},
}
