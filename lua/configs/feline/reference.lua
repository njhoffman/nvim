local vi_mode_colors = {
  NORMAL = 'green',
  OP = 'green',
  INSERT = 'red',
  CONFIRM = 'red',
  VISUAL = 'skyblue',
  LINES = 'skyblue',
  BLOCK = 'skyblue',
  REPLACE = 'violet',
  ['V-REPLACE'] = 'violet',
  ENTER = 'cyan',
  MORE = 'cyan',
  SELECT = 'orange',
  COMMAND = 'green',
  SHELL = 'green',
  TERM = 'green',
  NONE = 'yellow',
}

local vi_mode_text = {
  NORMAL = '<|',
  OP = '<|',
  INSERT = '|>',
  VISUAL = '<>',
  LINES = '<>',
  BLOCK = '<>',
  REPLACE = '<>',
  ['V-REPLACE'] = '<>',
  ENTER = '<>',
  MORE = '<>',
  SELECT = '<>',
  COMMAND = '<|',
  SHELL = '<|',
  TERM = '<|',
  NONE = '<>',
  CONFIRM = '|>',
}

local mode_colors = {
  ['n'] = { 'NORMAL', C.lavender },
  ['no'] = { 'N-PENDING', C.lavender },
  ['i'] = { 'INSERT', C.green },
  ['ic'] = { 'INSERT', C.green },
  ['t'] = { 'TERMINAL', C.green },
  ['v'] = { 'VISUAL', C.flamingo },
  ['V'] = { 'V-LINE', C.flamingo },
  [''] = { 'V-BLOCK', C.flamingo },
  ['R'] = { 'REPLACE', C.maroon },
  ['Rv'] = { 'V-REPLACE', C.maroon },
  ['s'] = { 'SELECT', C.maroon },
  ['S'] = { 'S-LINE', C.maroon },
  [''] = { 'S-BLOCK', C.maroon },
  ['c'] = { 'COMMAND', C.peach },
  ['cv'] = { 'COMMAND', C.peach },
  ['ce'] = { 'COMMAND', C.peach },
  ['r'] = { 'PROMPT', C.teal },
  ['rm'] = { 'MORE', C.teal },
  ['r?'] = { 'CONFIRM', C.mauve },
  ['!'] = { 'SHELL', C.green },
}

local assets = {
  left_separator = '',
  right_separator = '',
  mode_icon = '',
  dir = '󰉖',
  file = '󰈙',
  lsp = {
    server = '󰅡',
    error = '',
    warning = '',
    info = '',
    hint = '',
  },
  git = {
    branch = '',
    added = '',
    changed = '',
    removed = '',
  },
}
local M = {}

M.sections = {
  lualine_a = {
    function()
      local ft = vim.opt_local.filetype:get()
      return (ft == 'Mundo') and 'Change tree' or (ft == 'MundoDiff') and 'Change diff'
    end,
  },
  lualine_y = { 'progress' },
  lualine_z = { 'location' },
}
-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.

--- wrapper around job api
--- creates a job handler when called
local Job = setmetatable({
  --- start the job
  start = function(self)
    self.job_id = vim.fn.jobstart(self.args.cmd, self.args)
    return self.job_id > 0
  end,
  --- stop the job. Also immediately disables io from the job.
  stop = function(self)
    if self.killed then
      return
    end
    if self.job_id and self.job_id > 0 then
      vim.fn.jobstop(self.job_id)
    end
    self.job_id = 0
    self.killed = true
  end,
  -- Wraps callbacks so they are only called when job is alive
  -- This avoids race conditions
  wrap_cb_alive = function(self, name)
    local original_cb = self.args[name]
    if original_cb then
      self.args[name] = function(...)
        if not self.killed then
          return original_cb(...)
        end
      end
    end
  end,
}, {
  ---create new job handler
  ---@param self table base job table
  ---@param args table same args as jobstart except cmd is also passed in part of it
  ---@return table new job handler
  __call = function(self, args)
    args = vim.deepcopy(args or {})
    if type(args.cmd) == 'string' then
      args.cmd = vim.split(args.cmd, ' ')
    end
    self.__index = self
    local job = setmetatable({ args = args }, self)
    job:wrap_cb_alive('on_stdout')
    job:wrap_cb_alive('on_stderr')
    job:wrap_cb_alive('on_stdin')
    return job
  end,
})

return Job

-- Copyright (c) 2020-2021 shadmansaleh                                                                                    local Window = require('lualine.components.buffers.buffer'):extend()                     local Window = require('lualine.components.windows.window')
-- MIT license, see LICENSE for more details.                                                                                                                                                                       local M = require('lualine.components.buffers'):extend()
local Buffer = require('lualine.utils.class'):extend()

local modules = require('lualine_require').lazy_require {
  highlight = 'lualine.highlight',
  utils = 'lualine.utils.utils',
}

---initialize a new buffer from opts
---@param opts table
function Buffer:init(opts)
  assert(opts.bufnr, 'Cannot create Buffer without bufnr')
  self.bufnr = opts.bufnr
  self.buf_index = opts.buf_index
  self.options = opts.options
  self.highlights = opts.highlights
  self:get_props()
end

function Buffer:is_current()
  return vim.api.nvim_get_current_buf() == self.bufnr
end

function Buffer:is_alternate()
  return vim.fn.bufnr('#') == self.bufnr and not self:is_current()
end

---setup icons, modified status for buffer
function Buffer:get_props()
  self.file = modules.utils.stl_escape(vim.api.nvim_buf_get_name(self.bufnr))
  self.buftype = vim.api.nvim_get_option_value('buftype', { buf = self.bufnr })
  self.filetype = vim.api.nvim_get_option_value('filetype', { buf = self.bufnr })
  local modified = self.options.show_modified_status and vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
  self.modified_icon = modified and self.options.symbols.modified or ''
  self.alternate_file_icon = self:is_alternate() and self.options.symbols.alternate_file or ''
  self.icon = ''
  if self.options.icons_enabled then
    local dev
    local status, _ = pcall(require, 'nvim-web-devicons')
    if not status then
      dev, _ = '', ''
    elseif self.filetype == 'TelescopePrompt' then
      dev, _ = require('nvim-web-devicons').get_icon('telescope')
    elseif self.filetype == 'fugitive' then
      dev, _ = require('nvim-web-devicons').get_icon('git')
    elseif self.filetype == 'vimwiki' then
      dev, _ = require('nvim-web-devicons').get_icon('markdown')
    elseif self.buftype == 'terminal' then
      dev, _ = require('nvim-web-devicons').get_icon('zsh')
    elseif vim.fn.isdirectory(self.file) == 1 then
      dev, _ = self.options.symbols.directory, nil
    else
      dev, _ = require('nvim-web-devicons').get_icon(self.file, vim.fn.expand('#' .. self.bufnr .. ':e'))
    end
    if dev then
      self.icon = dev .. ' '
    end
  end
end

---returns line configured for handling mouse click
---@param name string
---@return string
function Buffer:configure_mouse_click(name)
  return string.format('%%%s@LualineSwitchBuffer@%s%%T', self.bufnr, name)
end

---returns rendered buffer
---@return string
function Buffer:render()
  local name = self:name()
  if self.options.fmt then
    name = self.options.fmt(name or '', self)
  end

  if self.ellipse then -- show ellipsis
    name = '...'
  else
    name = self:apply_mode(name)
  end
  name = Buffer.apply_padding(name, self.options.padding)
  self.len = vim.fn.strchars(name)

  -- setup for mouse clicks
  local line = self:configure_mouse_click(name)
  -- apply highlight
  line = modules.highlight.component_format_highlight(self.highlights[(self.current and 'active' or 'inactive')])
    .. line

  -- apply separators
  if self.options.self.section < 'x' and not self.first then
    local sep_before = self:separator_before()
    line = sep_before .. line
    self.len = self.len + vim.fn.strchars(sep_before)
  elseif self.options.self.section >= 'x' and not self.last then
    local sep_after = self:separator_after()
    line = line .. sep_after
    self.len = self.len + vim.fn.strchars(sep_after)
  end
  return line
end

---apply separator before current buffer
---@return string
function Buffer:separator_before()
  if self.current or self.aftercurrent then
    return '%Z{' .. self.options.section_separators.left .. '}'
  else
    return self.options.component_separators.left
  end
end

---apply separator after current buffer
---@return string
function Buffer:separator_after()
  if self.current or self.beforecurrent then
    return '%z{' .. self.options.section_separators.right .. '}'
  else
    return self.options.component_separators.right
  end
end

---returns name of current buffer after filtering special buffers
---@return string
function Buffer:name()
  if self.options.filetype_names[self.filetype] then
    return self.options.filetype_names[self.filetype]
  elseif self.buftype == 'help' then
    return 'help:' .. vim.fn.fnamemodify(self.file, ':t:r')
  elseif self.buftype == 'terminal' then
    local match = string.match(vim.split(self.file, ' ')[1], 'term:.*:(%a+)')
    return match ~= nil and match or vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif self.buftype == 'quickfix' then
    local is_loclist = 0 ~= vim.fn.getloclist(0, { filewinid = 1 }).filewinid
    return is_loclist and 'Location list' or 'Quickfix List'
  elseif vim.fn.isdirectory(self.file) == 1 then
    return vim.fn.fnamemodify(self.file, ':p:.')
  elseif self.file == '' then
    return '[No Name]'
  end

  local name
  if self.options.show_filename_only then
    name = vim.fn.fnamemodify(self.file, ':t')
  else
    name = vim.fn.pathshorten(vim.fn.fnamemodify(self.file, ':p:.'))
  end
  if self.options.hide_filename_extension then
    name = vim.fn.fnamemodify(name, ':r')
  end
  return name
end

---adds spaces to left and right
function Buffer.apply_padding(str, padding)
  local l_padding, r_padding = 1, 1
  if type(padding) == 'number' then
    l_padding, r_padding = padding, padding
  elseif type(padding) == 'table' then
    l_padding, r_padding = padding.left or 0, padding.right or 0
  end
  return string.rep(' ', l_padding) .. str .. string.rep(' ', r_padding)
end

function Buffer:apply_mode(name)
  if self.options.mode == 0 then
    return string.format('%s%s%s%s', self.alternate_file_icon, self.icon, name, self.modified_icon)
  end

  if self.options.mode == 1 then
    return string.format('%s%s %s%s', self.alternate_file_icon, self.buf_index or '', self.icon, self.modified_icon)
  end

  if self.options.mode == 2 then
    return string.format(
      '%s%s %s%s%s',
      self.alternate_file_icon,
      self.buf_index or '',
      self.icon,
      name,
      self.modified_icon
    )
  end

  if self.options.mode == 3 then
    return string.format('%s%s %s%s', self.alternate_file_icon, self.bufnr or '', self.icon, self.modified_icon)
  end

  -- if self.options.mode == 4 then
  return string.format('%s%s %s%s%s', self.alternate_file_icon, self.bufnr or '', self.icon, name, self.modified_icon)
end

return Buffer

local require = require('lualine_require').require                                                                         ---initialize a new buffer from opts
local Buffer = require('lualine.components.buffers.buffer')                                                                ---@param opts table                                                                     local default_options = {
local M = require('lualine.component'):extend()                                                                            function Window:init(opts)                                                                 disabled_filetypes = {},
local highlight = require('lualine.highlight')                                                                               assert(opts.winnr, 'Cannot create Window without winnr')                                 disabled_buftypes = { 'quickfix', 'prompt' },
                                                                                                                             opts.bufnr = vim.api.nvim_win_get_buf(opts.winnr)                                      }
local default_options = {
  show_filename_only = true,                                                                                                 Window.super.init(self, opts)                                                          function M:init(options)
  hide_filename_extension = false,                                                                                                                                                                                    options.buffers_color = nil -- buffers_color isn't windows option.
  show_modified_status = true,                                                                                               self.winnr = opts.winnr                                                                  M.super.init(self, options)
  mode = 0,                                                                                                                  self.win_number = vim.api.nvim_win_get_number(self.winnr)
  max_length = 0,                                                                                                          end                                                                                        self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  filetype_names = {                                                                                                                                                                                                  self.options.windows_color = vim.tbl_deep_extend('keep', self.options.windows_color or {}, self.options.buffers_color)
    TelescopePrompt = 'Telescope',                                                                                         function Window:is_current()                                                               self.options.buffers_color = nil -- this is the default value of colors generated by parent buffers component.
    dashboard = 'Dashboard',                                                                                                 return vim.api.nvim_get_current_win() == self.winnr
    packer = 'Packer',                                                                                                     end                                                                                        self.highlights = {
    fzf = 'FZF',                                                                                                                                                                                                        active = self:create_hl(self.options.windows_color.active, 'active'),
    alpha = 'Alpha',                                                                                                       function Window:apply_mode(name)                                                             inactive = self:create_hl(self.options.windows_color.inactive, 'inactive'),
  },                                                                                                                         if self.options.mode == 0 then                                                           }
  use_mode_colors = false,                                                                                                     return string.format('%s%s%s', self.icon, name, self.modified_icon)                  end
  buffers_color = {                                                                                                          end
    active = nil,                                                                                                                                                                                                   function M:new_buffer(winnr)
    inactive = nil,                                                                                                          if self.options.mode == 1 then                                                           winnr = winnr or vim.api.nvim_get_current_win()
  },                                                                                                                           return string.format('%s %s%s', self.win_number, self.icon, self.modified_icon)
  symbols = {                                                                                                                end                                                                                      return Window:new {
    modified = ' ●',                                                                                                                                                                                            winnr = winnr,
    alternate_file = '#',                                                                                                    return string.format('%s %s%s%s', self.win_number, self.icon, name, self.modified_icon)    options = self.options,
    directory = '',                                                                                               end                                                                                          highlights = self.highlights,
  },                                                                                                                                                                                                                  }
}                                                                                                                          function Window:configure_mouse_click(name)                                              end
                                                                                                                             return string.format('%%%s@LualineSwitchWindow@%s%%T', self.win_number, name)
-- This function is duplicated in tabs                                                                                     end                                                                                      --- Override to only return buffers shown in the windows of the current tab
---returns the proper hl for buffer in section. Used for setting default highlights                                                                                                                                 function M:buffers()
---@param section string name of section buffers component is in                                                           return Window                                                                              local tabnr = vim.api.nvim_get_current_tabpage()
---@param is_active boolean                                                                                                  local buffers = {}
---@return string hl name
local function get_hl(section, is_active)                                                                                    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
  local suffix = is_active and highlight.get_mode_suffix() or '_inactive'                                                      if not self:should_hide(winnr) then
  local section_redirects = {                                                                                                    buffers[#buffers + 1] = self:new_buffer(winnr)
    lualine_x = 'lualine_c',                                                                                                   end
    lualine_y = 'lualine_b',                                                                                                 end
    lualine_z = 'lualine_a',
  }                                                                                                                          return buffers
  if section_redirects[section] then                                                                                       end
    section = highlight.highlight_exists(section .. suffix) and section or section_redirects[section]
  end                                                                                                                      function M:should_hide(winnr)
  return section .. suffix                                                                                                   local bufnr = vim.api.nvim_win_get_buf(winnr)
end                                                                                                                          local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                                                                                                                             local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
function M:init(options)                                                                                                     local is_filetype_disabled = vim.tbl_contains(self.options.disabled_filetypes, filetype)
  M.super.init(self, options)                                                                                                local is_buftype_disabled = vim.tbl_contains(self.options.disabled_buftypes, buftype)
  -- if use_mode_colors is set, use a function so that the colors update                                                     local is_floating = '' ~= vim.api.nvim_win_get_config(winnr).relative
  local default_active = options.use_mode_colors
      and function()                                                                                                         return is_floating or is_buftype_disabled or is_filetype_disabled
        return get_hl('lualine_' .. options.self.section, true)                                                            end
      end
    or get_hl('lualine_' .. options.self.section, true)                                                                    vim.cmd([[
  default_options.buffers_color = {                                                                                          function! LualineSwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
    active = default_active,                                                                                                   execute a:win_number . 'wincmd w'
    inactive = get_hl('lualine_' .. options.self.section, false),                                                            endfunction
  }                                                                                                                        ]])
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  if self.options.component_name == 'buffers' then                                                                         return M
    self.highlights = {
      active = self:create_hl(self.options.buffers_color.active, 'active'),                                                -- -- table.insert(components.right.active, 1, {
      inactive = self:create_hl(self.options.buffers_color.inactive, 'inactive'),                                          -- --   provider = LspLightbulb, -- hl = { fg = "cyan", bg = "bg", style = "bold" },
    }                                                                                                                      -- -- })
  end
end                                                                                                                        -- table.insert(properties.force_inactive.filetypes, "dapui_scopes")
                                                                                                                           -- table.insert(properties.force_inactive.filetypes, "dapui_watches")
function M:new_buffer(bufnr, buf_index)                                                                                    -- table.insert(properties.force_inactive.filetypes, "dapui_breakpoints")
  bufnr = bufnr or vim.api.nvim_get_current_buf()                                                                          -- table.insert(properties.force_inactive.filetypes, "dapui_stacks")
  buf_index = buf_index or ''                                                                                              -- table.insert(properties.force_inactive.filetypes, "dap-repl")
  return Buffer:new {                                                                                                      -- -- properties = {
    bufnr = bufnr,                                                                                                         -- --   force_inactive = {
    buf_index = buf_index,                                                                                                 -- --     bufnames = {},
    options = self.options,                                                                                                -- --     buftypes = { "terminal" },
    highlights = self.highlights,                                                                                          -- --     filetypes = {
  }                                                                                                                        -- --       "NvimTree",
end                                                                                                                        -- --       "dbui",
                                                                                                                           -- --       "packer",
function M:buffers()                                                                                                       -- --       "startify",
  local buffers = {}                                                                                                       -- --       "fugitive",
  M.bufpos2nr = {}                                                                                                         -- --       "fugitiveblame",
  for b = 1, vim.fn.bufnr('$') do                                                                                          -- --       "dashboard",
    if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_get_option_value('buftype', { buf = b }) ~= 'quickfix' then                           -- --     },
      buffers[#buffers + 1] = self:new_buffer(b, #buffers + 1)                                                             -- --   },
      M.bufpos2nr[#buffers] = b                                                                                            -- -- }
    end
  end                                                                                                                      -- local separators = {
                                                                                                                           --   vertical_bar = "┃",
  return buffers                                                                                                           --   vertical_bar_thin = "│",
end                                                                                                                        --   left = "",
                                                                                                                           --   right = "",
function M:update_status()                                                                                                 --   block = "█",
  local data = {}                                                                                                          --   left_filled = "  ",
  local buffers = self:buffers()                                                                                           --   right_filled = "  ",
  local current = -2                                                                                                       --   slant_left = " ",
  -- mark the first, last, current, before current, after current buffers                                                  --   slant_left_thin = " ",
  -- for rendering                                                                                                         --   slant_right = " ",
  if buffers[1] then                                                                                                       --   slant_right_thin = " ",
    buffers[1].first = true                                                                                                --   slant_left_2 = " ",
  end                                                                                                                      --   slant_left_2_thin = "  ",
  if buffers[#buffers] then                                                                                                --   slant_right_2 = " ",
    buffers[#buffers].last = true                                                                                          --   slant_right_2_thin = " ",
  end                                                                                                                      --   left_rounded = "  ",
  for i, buffer in ipairs(buffers) do                                                                                      --   left_rounded_thin = "  ",
    if buffer:is_current() then                                                                                            --   right_rounded = "   ",
      buffer.current = true                                                                                                --   right_rounded_thin = "  ",
      current = i                                                                                                          --   circle = "●",
    end                                                                                                                    -- }
  end
  if buffers[current - 1] then                                                                                             -- -- components.left.active[3] = {
    buffers[current - 1].beforecurrent = true                                                                              -- --   provider = "file_info",
  end                                                                                                                      -- --   hl = { fg = "white", bg = "dodgerblue3", style = "bold" },
  if buffers[current + 1] then                                                                                             -- --   left_sep = { "slant_left", { hl = { bg = "NONE", fg = "dodgerblue3" }, " " } },
    buffers[current + 1].aftercurrent = true                                                                               -- --   right_sep = { "slant_right_2", " " },
  end                                                                                                                      -- -- }

  local max_length = self.options.max_length                                                                               -- local bgcolor = "oceanblue"
  if type(max_length) == 'function' then                                                                                   -- if vim.api.nvim_buf_get_name(0) == "[Command Line]" then bgcolor = "#330000" end
    max_length = max_length(self)
  end                                                                                                                      -- components.left.active[3] = {
                                                                                                                           --   provider = "file_info",
  if max_length == 0 then                                                                                                  --   hl = { fg = "white", bg = "oceanblue", style = "bold" },
    max_length = math.floor(2 * vim.o.columns / 3)                                                                         --   left_sep = { " ", "slant_left", { str = "", hl = { bg = bgcolor, fg = "NONE" } } },
  end                                                                                                                      --   right_sep = { "slant_right_2", " " },
  local total_length                                                                                                       -- }
  for i, buffer in pairs(buffers) do
    if buffer.current then                                                                                                 -- -- components.left.active[3] = {
      current = i                                                                                                          -- --   provider = function()
    end                                                                                                                    -- --     get_project_path()
  end                                                                                                                      -- --     return project_name or ""
  -- start drawing from current buffer and draw left and right of it until                                                 -- --   end,
  -- all buffers are drawn or max_length has been reached.                                                                 -- --   hl = function()
  if current == -2 then                                                                                                    -- --     if project_path == nil or project_path == "" then
    local b = self:new_buffer()                                                                                            -- --       return { fg = "white", bg = "#333333" }
    b.current = true                                                                                                       -- --     end
    if self.options.self.section < 'x' then                                                                                -- --     return { fg = "white", bg = "#440088" }
      b.last = true                                                                                                        -- --   end,
      if #buffers > 0 then                                                                                                 -- --   -- left_sep = {str = "slant_left", hl = {fg = "#224488", bg = "NONE"}},
        buffers[#buffers].last = nil                                                                                       -- --   left_sep = function()
      end
      buffers[#buffers + 1] = b                                                                                            -- --     local val = {
      current = #buffers                                                                                                   -- --       str = "slant_left",
    else                                                                                                                   -- --       fg = "white",
      b.first = true                                                                                                       -- --       bg = "#224488",
      if #buffers > 0 then                                                                                                 -- --       style = "bold",
        buffers[1].first = nil                                                                                             -- --     }
      end                                                                                                                  -- --     if project_path == nil then val.bg = "#333333" end
      table.insert(buffers, 1, b)                                                                                          -- --     return val
      current = 1                                                                                                          -- --   end,
    end                                                                                                                    -- --   right_sep = { "slant_right_2" },
  end                                                                                                                      -- -- }
  local current_buffer = buffers[current]                                                                                  -- -- local active_clients = nil
  data[#data + 1] = current_buffer:render()                                                                                -- -- local last_active_client_buffer = vim.fn.bufnr()
  total_length = current_buffer.len
  local i = 0                                                                                                              -- -- local function lsp_active_status()
  local before, after                                                                                                      -- --   -- lsp_status:                ⏻ ⏼ ⭘      
  while true do                                                                                                            -- --   if vim.fn.bufnr() ~= last_active_client_buffer then
    i = i + 1                                                                                                              -- --     active_clients = vim.lsp.buf_get_clients()
    before = buffers[current - i]                                                                                          -- --     last_active_client_buffer = vim.fn.bufnr()
    after = buffers[current + i]                                                                                           -- --   end
    local rendered_before, rendered_after
    if before == nil and after == nil then                                                                                 -- --   -- if active_clients == nil or #active_clients == 0 then
      break                                                                                                                -- --   --   active_clients = vim.lsp.buf_get_clients()
    end                                                                                                                    -- --   -- end
    -- draw left most undrawn buffer if fits in max_length
    if before then                                                                                                         -- --   -- if #active_clients == 0 then return " " end
      rendered_before = before:render()                                                                                    -- --   -- if #active_clients > 1 then return #active_clients end
      total_length = total_length + before.len                                                                             -- --   -- if active_clients[1].name == "efm" then return "" end
      if total_length > max_length then                                                                                    -- --   return ""
        break                                                                                                              -- -- end
      end
      table.insert(data, 1, rendered_before)                                                                               -- -- components.right.active[5] = {
    end                                                                                                                    -- --   provider = function() return vim.bo.filetype:lower() end,
    -- draw right most undrawn buffer if fits in max_length                                                                -- --   hl = function()
    if after then                                                                                                          -- --     if active_clients == nil or #active_clients == 0 then
      rendered_after = after:render()                                                                                      -- --       return { fg = "fg" }
      total_length = total_length + after.len                                                                              -- --     else
      if total_length > max_length then                                                                                    -- --       if active_clients[1].name == "efm" then
        break                                                                                                              -- --         return { fg = "#6688cc", style = "italic" }
      end                                                                                                                  -- --       end
      data[#data + 1] = rendered_after                                                                                     -- --       return { fg = "#00aacc", style = "italic" }
    end                                                                                                                    -- --     end
  end                                                                                                                      -- --   end,
  -- draw ellipsis (...) on relevant sides if all buffers don't fit in max_length                                          -- -- }
  if total_length > max_length then
    if before ~= nil then                                                                                                  -- -- components.right.active[6] = {
      before.ellipse = true                                                                                                -- --   provider = lsp_active_status,
      before.first = true                                                                                                  -- --   hl = function()
      table.insert(data, 1, before:render())                                                                               -- --     if active_clients == nil or #active_clients == 0 then
    end                                                                                                                    -- --       return { fg = "none" }
    if after ~= nil then                                                                                                   -- --     end
      after.ellipse = true                                                                                                 -- --     if #active_clients > 1 then return { fg = "#ff0000", style = "bold" } end
      after.last = true                                                                                                    -- --     if active_clients[1].name == "efm" then
      data[#data + 1] = after:render()                                                                                     -- --       return { fg = "#6688ff", style = "none" }
    end                                                                                                                    -- --     end
  end                                                                                                                      -- --     return { fg = "#00ccff", style = "none" }
                                                                                                                           -- --   end,
  return table.concat(data)
end                                                                                                                        -- --   left_sep = " ",
                                                                                                                           -- --   right_sep = " ",
function M:draw()                                                                                                          -- -- }
  self.status = ''
  self.applied_separator = ''                                                                                              -- require("feline").setup({
                                                                                                                           --   default_fg = "#909090",
  if self.options.cond ~= nil and self.options.cond() ~= true then                                                         --   default_bg = "#0F1216",
    return self.status                                                                                                     --   components = components,
  end                                                                                                                      --   separators = separators,
  local status = self:update_status()                                                                                      -- })
  if type(status) == 'string' and #status > 0 then
    self.status = status
    self:apply_section_separators()
    self:apply_separator()
  end
  return self.status
end

function M.buffer_jump(buf_pos, bang)
  if buf_pos == '$' then
    buf_pos = #M.bufpos2nr
  else
    buf_pos = tonumber(buf_pos)
  end
  if buf_pos < 1 or buf_pos > #M.bufpos2nr then
    if bang ~= '!' then
      error('Error: Unable to jump buffer position out of range')
    else
      return
    end
  end
  vim.api.nvim_set_current_buf(M.bufpos2nr[buf_pos])
end

vim.cmd([[
  function! LualineSwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    execute ":buffer " . a:bufnr
  endfunction

  command! -nargs=1 -bang LualineBuffersJump call v:lua.require'lualine.components.buffers'.buffer_jump(<f-args>, "<bang>")
]])

return M
