local default_opts = {
  keypress_select               = "<Enter>",
  keypress_close                = '<Esc>',
  keypress_scroll_output_down   = '<C-Down>',
  keypress_scroll_output_up     = '<C-Up>',
  -- Can also be vertical, if I dont know what you passed I will assume horizontal
  output_split_type             = 'horizontal',
  --  ⛔ ✅    
  import_failed_icon            = "",
  import_success_icon           = "",
  import_info_icon              = "",
  import_enable_better_printing = true,
  import_show_intervals         = false,
  import_show_percentages       = false,
  import_sort_times             = false,
  report_details                = true
}

local user_opts = vim.deepcopy(default_opts)

local config = function(configuration)
  configuration = configuration or {}
  local _opts = vim.deepcopy(default_opts)
  for key, value in pairs(configuration) do
    if key == 'output_split_type'
      and (value ~= 'horizontal' and value ~= 'vertical') then
      value = 'horizontal'
    end
    _opts[key] = value
  end
  user_opts = _opts
end
return {
  user_opts = user_opts,
  config = config
}
