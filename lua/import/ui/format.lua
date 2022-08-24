local opts = require('import.opts')
local cmds = require('import.commands')

--  plugins.config.cmp-git  l

local format_module = function(module, details)
  local icon = ""
  if not details then
    details = cmds.get_status(module)
  end

  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  if details.imported then
    icon = opts.user_opts.import_success_icon
  else
    icon = opts.user_opts.import_failed_icon
  end
  return " " .. icon .. " " .. tostring(module)
end

--   icon    = 'ImportErrorIcon',
--   title   = 'ImportErrorTitle',
--   file    = 'ImportErrorFile',
--   line    = 'ImportErrorLine',
--   message = 'ImportErrorMessage',
--   command = 'ImportErrorCommand',
--   stack   = 'ImportErrorStack',
-- }
local format_failed = function(module, details, file_width)
  local icon = ""
  if not details then details = cmds.get_status(module) end
  icon = opts.user_opts.import_failed_icon
  local items = {
    { icon, 'ImportFailedIcon' },
    { ' ', '' },
    { module, 'ImportFailedModule' },
    { ' ', '' },
    { 'Some further details', 'Comment' },
  }
  return items
end

local format_success = function(module, details, file_width)
  local icon = ""
  if not details then
    details = cmds.get_status(module)
  end

  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  if details.imported then
    icon = opts.user_opts.import_success_icon
  else
    icon = opts.user_opts.import_failed_icon
  end
  return " " .. icon .. " " .. tostring(module)
end

return {
  module = format_module,
  failed = format_failed,
  success = format_success
}
