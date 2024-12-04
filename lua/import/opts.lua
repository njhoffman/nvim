local default_opts = {
  keypress_select = "<Enter>",
  keypress_close = "<Esc>",
  keypress_scroll_output_down = "<C-Down>",
  keypress_scroll_output_up = "<C-Up>",
  -- Can also be vertical, if I dont know what you passed I will assume horizontal
  output_split_type = "horizontal",
  --  ⛔ ✅    
  import_failed_icon = "",
  import_success_icon = "",
  import_info_icon = "",
  import_enable_better_printing = true,
  import_show_intervals = false,
  import_show_percentages = false,
  import_sort_times = false,
  detailed_metrics = true,
  benchmarks = {
    -- "keymaps",
    -- "aucommands",
    -- "variables",
  },
}

local opts = vim.deepcopy(default_opts)

local config = function(conf)
  local _opts = vim.tbl_deep_extend("force", opts, conf or {})
  for key, value in pairs(conf) do
    if key == "output_split_type" and (value ~= "horizontal" and value ~= "vertical") then
      value = "horizontal"
    end
    _opts[key] = value
  end
  opts = _opts
  return opts
end

return {
  user_opts = opts,
  config = config,
}
