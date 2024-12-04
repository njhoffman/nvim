local opts = require("import.opts")
local cmds = require("import.commands")

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

return { module = format_module }
