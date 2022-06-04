local cmd = vim.cmd

cmd([[command! -nargs=* -complete=customlist,options#complete Set :lua require'utils.options'.run_set_cmd(<q-args>, nil)]])
cmd([[command! -nargs=* -complete=customlist,options#complete_buf_local Setlocal :lua require'utils.options'.run_set_cmd(<q-args>, vim.api.nvim_get_current_buf())]])

local opt = require("utils.options")

opt.register_option({
  name = "indentsize",
  default = 4,
  type_info = "number",
  source = "buffers",
  buffer_local = true,
})

opt.register_callback("indentsize", function()
  local isize = opt.get_option_value('indentsize', vim.api.nvim_get_current_buf())
  cmd(string.format("setlocal tabstop=%s softtabstop=%s shiftwidth=%s", isize, isize, isize))
  print("doing callback: " .. isize)
end)



opt.register_option({
  name = "projectpath",
  default = "",
  type_info = "string",
  source = "buffers",
  global = true,
  description = "Project path identified by lsp server or path"
})

opt.register_option({
  name = "projectname",
  default = "",
  type_info = "string",
  source = "buffers",
  global = true,
  description = "Shortened project name for display"
})

opt.register_option({
  name = "projecttype",
  default = "",
  type_info = "string",
  source = "buffers",
  global = true,
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

opt.register_option({
  name = "scratchpad",
  default = false,
  type_info = "boolean",
  source = "opt",
  buffer_local = true,
})

opt.register_callback("scratchpad", function()
  bo[bufnr].buftype = "nofile"
  bo[bufnr].bufhidden = "hide"
  bo[bufnr].swapfile = false
  bo[bufnr].buflisted = true
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
