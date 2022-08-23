local notify     = require('notify')
local path_utils = require('plenary.path')
local utils      = require('notifications.utils')
local devicons   = require('nvim-web-devicons')
-- local ns_id = vim.api.nvim_create_namespace("nvim-notify")
local ns_id      = 0

vim.cmd([[
  highlight default link NotifyFileIcon Function
  highlight default link NotifyFileName Normal
  highlight default link NotifyFileFiletype Comment
  highlight default link NotifyFileLines Comment
]])

local render_info = function(bufnr, notif, highlights)
  --  ~/ghq/github.com/fzf-preview.plugin.zsh [lua] [1,509 L]
  local msgs = notif.message
  local hl = {
    icon     = 'NotifyFileIcon',
    name     = 'NotifyFileName',
    filetype = 'NotifyFileFiletype',
    lines    = 'NotifyFileLines',
  }

  local shortfile = utils.path_home(utils.path_nvim(msgs[2]))

  utils.build_line(bufnr, 0, {
    { msgs[1] .. ' ', hl.icon },
    { shortfile .. ' ', hl.name },
    { msgs[3] .. ' ', hl.filetype },
    { msgs[4] .. ' L', hl.lines },
  })
end

local file_path = "~/ghq/github.com/njhoffman/fzfmenu/widgets/system/fzf.params.zsh"
local render_current_file = function(bufnr, notif, highlights)
  local paths     = {}
  -- local file_path = vim.api.nvim_buf_get_name(0)
  local dirs      = path_utils.new(file_path):_split()
  paths.full      = path_utils.new(file_path):normalize('.')
  paths.relative  = path_utils.new(file_path):normalize(vim.fn.getcwd())
  paths.file      = dirs[#dirs]
  paths.extension = dirs[#dirs]:match("^.*%.(.*)$") or ""
  -- paths.filetype  = devicons

  local width = vim.api.nvim_win_get_width(0)
  local msg = notif.message
  local line = ''
  local hlmap = {}
  local render_icon = function(icon_name, hl_name, hl_def)
    if msg[icon_name] ~= nil then
      vim.api.nvim_set_hl(ns_id, hl_name, hl_def)
      table.insert(hlmap, { hl_name, #line, #line + #msg[icon_name] })
      line = line .. msg[icon_name]
    end
  end

  -- file_icon = ' ',
  render_icon('lsp_icon', 'LspIcon', { fg = "#008000" })
  render_icon('file_icon', 'FileIcon', { fg = "#ff0000" })
  render_icon('git_icon', 'GitIcon', { fg = "#008080" })
  render_icon('watch_icon', 'WatchIcon', { fg = "#ffff00" })

  vim.api.nvim_set_hl(ns_id, 'ParentPath', { fg = '#666666' })
  vim.api.nvim_set_hl(ns_id, 'ProjectFolder', { fg = '#ffffff' })
  vim.api.nvim_set_hl(ns_id, 'ProjectPath', { fg = '#999999' })
  vim.api.nvim_set_hl(ns_id, 'ProjectFile', { fg = '#cccccc' })

  if msg.format == 'long' then
    -- table.insert(hlmap, { hl_name, #line, #line + #msg.file_path })
    line = line .. msg.file_path
  end

  local msgs = { line }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msgs)
  for _, hl in pairs(hlmap) do
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, hl[1], 0, hl[2], hl[3])
  end
end


-- notify(info1, 'task', { render = render_info, anchor = 'TC' })
notify({
  lsp_icon = ' ',
  git_icon = ' ',
  watch_icon = ' ',
  -- file_path = vim.api.nvim_buf_get_name(0),
  file_path = file_path,
  project_path = "~/ghq/github.com/njhoffman/fzfmenu",
  git_path = "~/ghq/github.com/njhoffman/fzfmenu",
  project_name = "fzfmenu",
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

-- notify(
-- '~/ghq/github.com/njhoffman/fzfmenu/proto-widgets/fzf-preview/fzf-preview.plugin.zsh',
--   'warn',
--   { title = { 'Testing ', 'WARN' }, anchor = 'TL', icon = '' }
-- )
