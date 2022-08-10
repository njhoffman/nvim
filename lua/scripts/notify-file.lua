local notify     = require('notify')
local path_utils = require('plenary.path')
local devicons   = require('nvim-web-devicons')

local paths     = {}
local file_path = vim.api.nvim_buf_get_name(0)
local dirs      = path_utils.new(file_path):_split()
paths.full      = path_utils.new(file_path):normalize('.')
paths.relative  = path_utils.new(file_path):normalize(vim.fn.getcwd())
paths.file      = dirs[#dirs]
paths.extension = dirs[#dirs]:match("^.*%.(.*)$") or ""
-- paths.filetype  = devicons
vim.dbg(paths)

--     ~/ghq/github.com/njhoffman/fzfmenu/README.md [350l utf-8 unix]
--   ~/ghq/github.com/njhoffman/fzfmenu/proto-widgets/fzf-preview/fzf-preview.plugin.zsh [350l utf-8 unix]
--   fzfmenu/./proto-widgets/fzf-preview/fzf-preview.plugin.zsh [350l utf-8 unix]
--   fzfmenu:proto-widgets/fzf-preview/fzf-preview.plugin.zsh [350l utf-8 unix]
--   ./proto-widgets/fzf-preview/fzf-preview.plugin.zsh [350l utf-8 unix]
local render_current_file = function(bufnr, notif, highlights)
  local ns = vim.api.nvim_create_namespace("notify")
  local width = vim.api.nvim_win_get_width(0)
  local msg = notif.message
  local line = ''
  local hlmap = {}
  local render_icon = function(icon_name, hl_name, hl_def)
    if msg[icon_name] ~= nil then
      vim.api.nvim_set_hl(ns, hl_name, hl_def)
      table.insert(hlmap, { hl_name, #line, #line + #msg[icon_name] })
      line = line .. msg[icon_name]
    end
  end

  -- file_icon = ' ',
  render_icon('lsp_icon', 'LspIcon', { fg = "#008000" })
  render_icon('file_icon', 'FileIcon', { fg = "#ff0000" })
  render_icon('git_icon', 'GitIcon', { fg = "#008080" })
  render_icon('watch_icon', 'WatchIcon', { fg = "#ffff00" })

  vim.api.nvim_set_hl(ns, 'ParentPath', { fg = '#666666' })
  vim.api.nvim_set_hl(ns, 'ProjectFolder', { fg = '#ffffff' })
  vim.api.nvim_set_hl(ns, 'ProjectPath', { fg = '#999999' })
  vim.api.nvim_set_hl(ns, 'ProjectFile', { fg = '#cccccc' })

  if msg.format == 'long' then
    -- table.insert(hlmap, { hl_name, #line, #line + #msg.file_path })
    line = line .. msg.file_path
  end

  local msgs = { line }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msgs)
  for _, hl in pairs(hlmap) do
    vim.api.nvim_buf_add_highlight(bufnr, ns, hl[1], 0, hl[2], hl[3])
  end
end


local notify_current_file = function()
  notify({
    lsp_icon = ' ',
    git_icon = ' ',
    watch_icon = ' ',
    file_path = vim.api.nvim_buf_get_name(0),
    project_path = vim.bo.projectpath,
    git_path = "~/ghq/github.com/njhoffman/fzfmenu",
    project_name = vim.bo.projectname,
    line_count = vim.api.nvim_buf_line_count(0),
    file_format = vim.bo.fileformat,
    file_encoding = vim.bo.fileencoding,
    format = 'long',
    -- format = 'project',
    -- format = 'short',
  }, 'task', {
    render = render_current_file,
    anchor = 'TC'
  })
end

notify_current_file()
