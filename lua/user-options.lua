local opt = require("utils.options")
local cmd = vim.cmd

opt.register_option({
  name = "indentsize",
  default = 4,
  type_info = "number",
  source = "buffers",
  buffer_local = true,
})

opt.register_callback("indentsize", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local isize = opt.get_option_value('indentsize', bufnr)
  local format_str = "setlocal tabstop=%s softtabstop=%s shiftwidth=%s"
  cmd(string.format(format_str, isize, isize, isize))
  print("doing callback: " .. isize)
end)

opt.register_option({
  name = "useroptions_output",
  default = "notify",
  type_info = "string",
  source = "user-options",
  global = true,
  description = "Output method of user options (notifications or print)"
})

-- NOTIFICATIONS --
-- notify_level_record, notify_level_show, notify_level_log
opt.register_option({
  name = "notify_level_show",
  default = "debug",
  type_info = "string",
  source = "settings",
  global = true,
  description = "Cutoff level to show notifications (error, warn, info, debug, trace)"
})
opt.register_option({
  name = "notify_level_record",
  default = "trace",
  type_info = "string",
  source = "settings",
  global = true,
  description = "Cutoff level to record notifications (error, warn, info, debug, trace)"
})

opt.register_option({
  name = "notify_level_log",
  default = "trace",
  type_info = "string",
  source = "settings",
  global = true,
  description = "Cutoff level to log notifications (error, warn, info, debug, trace)"
})

-- PROJECT --
opt.register_option({
  name = "projectpath",
  default = "",
  type_info = "string",
  source = "project_nvim",
  buffer_local = true,
  description = "Project path identified by lsp server or path"
})

opt.register_option({
  name = "projectname",
  default = "",
  type_info = "string",
  source = "project_nvim",
  buffer_local = true,
  description = "Shortened project name for display"
})

opt.register_option({
  name = "projectmethod",
  default = "",
  type_info = "string",
  source = "project_nvim",
  buffer_local = true,
  description = "Which LSP server or method identified the project"
})

opt.register_option({
  name = "tags_completion_enabled",
  default = true,
  type_info = "boolean",
  source = "lsp",
  buffer_local = true,
})

opt.register_option({
  name = "clstrailingwhitespace",
  default = true,
  type_info = "boolean",
  source = "buffers",
  buffer_local = true,
})

opt.register_option({
  name = "lsptagfuncenabled",
  default = true,
  type_info = "boolean",
  source = "vimrc",
  global = true,
})

opt.register_option({
  name = "clstrailingspacelimit",
  default = 0,
  type_info = "number",
  source = "buffers",
  buffer_local = true,
  description = "If the number of trailing white spaces below this number, they will be cleared automatically. Otherwise you will be prompted for each one.",
})

opt.register_option({
  name = "trailingwhitespacehighlight",
  default = true,
  type_info = "boolean",
  source = "buffers",
  buffer_local = true,
})

opt.register_option({
  name = "shell",
  default = "pwsh",
  type_info = "string",
  source = "opt",
  global = true,
})

-- options.set("shell", vim.opt.shell:get())

opt.register_option({
  name = "scratchpad",
  default = false,
  type_info = "boolean",
  source = "opt",
  buffer_local = true,
})

local s_scratch_buffer_count
opt.register_callback("scratchpad", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].buflisted = true
  cmd("file scratchpad-" .. s_scratch_buffer_count)
end)

opt.register_option({
  name = "markdownfenced",
  default = {},
  type_info = "table",
  source = "buffers",
  buffer_local = true,
})
opt.register_option({
  name = "todofenced",
  default = {},
  type_info = "table",
  source = "todo",
  buffer_local = true,
})
opt.register_option({
  name = "minimal_buffer",
  default = false,
  type_info = "boolean",
  source = "buffers",
  buffer_local = true,
})
return opt
