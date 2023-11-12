-- vim.keymap.set()

-- Cursor fix
-- The existing function no longer exists, but you now have require("noice").api.get_cmdline_position() instead.
-- ---@class CmdlinePosition
-- ---@field win number Window containing the cmdline
-- ---@field buf number Buffer containing the cmdline
-- ---@field bufpos {row:number, col:number} (1-0)-indexed position of the cmdline in the buffer
-- ---@field screenpos {row:number, col:number} (1-0)-indexed screen position of the cmdline
-- This no longer returns the cursor position, but the position where the cmdline starts.
--
-- You can then use vim.fn.getcmdpos to get the cursor if needed.

local noice_views = require('noice.user.views')
local noice_routes = require('noice.user.routes')
local noice_mapping = require('noice.user.mapping')
local render = require('configs.nvim-notify.render')

local cfg = {
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = false, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  lsp = {
    progress = {
      enabled = true,
      format = 'lsp_progress',
      format_done = 'lsp_progress_done',
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = 'mini',
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = {
      enabled = true,
      -- view = nil, -- when nil, use defaults from documentation
      opts = { win_options = {} }, -- merged with defaults from documentation
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
    },
    message = {
      -- Messages shown by lsp servers
      enabled = true,
      view = 'notify',
      opts = {},
    },
    -- defaults for hover and signature help
    documentation = {
      view = 'hover',
      opts = {
        lang = 'markdown',
        replace = true,
        render = 'plain',
        format = { '{message}' },
        win_options = { concealcursor = 'n', conceallevel = 3, cursorline = false },
      },
    },
  },
  markdown = {
    hover = {
      ['|(%S-)|'] = vim.cmd.help, -- vim help links
      ['%[.-%]%((%S-)%)'] = require('noice.util').open, -- markdown links
    },
    highlights = {
      ['|%S-|'] = '@text.reference',
      ['@%S+'] = '@parameter',
      ['^%s(Parameters:)'] = '@text.title',
      ['^%s(Return:)'] = '@text.title',
      ['^%s(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
    },
  },
  cmdline = {
    view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {}, -- global options for the cmdline. See section on views
    format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- conceal = false,
    },
  },
  messages = {
    enabled = true, -- enables the Noice messages UI
    view = 'notify', -- default view for messages
    view_error = 'notify', -- view for errors
    view_warn = 'notify', -- view for warnings
    view_history = 'messages', -- view for :messages
    view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
  },
  views = {
    ['mini'] = { zindex = 10 },
    -- ['cmdline'] = cmdlineView,
    ['notify_error'] = noice_views.errorView,
    ['notify'] = {
      -- render = 'minimal',
      render = render,
      -- level = vim.log.levels.DEBUG,
      fps = 30,
      -- render = render,
      stages = 'fade_in_slide_out',
      background_colour = '#000000',
      -- timeout = 5000,
      minimum_width = 5,
      max_height = function()
        return math.floor(vim.opt.lines:get() / 5 * 4)
      end,
      max_width = function()
        return math.floor(vim.opt.columns:get() / 5 * 3)
      end,
      icons = {
        ERROR = '',
        WARN = '',
        INFO = '',
        DEBUG = '',
        TRACE = '✎',
        INSPECT = '',
        RUN = '',
        STATUS = '',
      },
    },
    cmdline_popup = {
      position = {
        row = 10,
        col = '50%',
      },
      size = {
        width = 60,
        height = 'auto',
      },
      in_options = {
        winhighlight = {
          Normal = 'NoiceCmdlinePopup',
          FloatBorder = 'NoiceCmdlinePopupBorder',
          IncSearch = '',
          CurSearch = '',
          Search = '',
        },
        cursorline = false,
      },
    },
    cmdline_output = {
      format = 'details',
      view = 'popup',
    },
    popupmenu = {
      relative = 'editor',
      position = {
        row = 11,
        col = '50%',
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = 'rounded',
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
      },
    },
  },
  notify = {
    -- Noice can be used as `vim.notify` so you can route any notification like other messages
    -- Notification messages have their level and other properties set.
    -- event is always "notify" and kind can be any log level as a string
    -- The default routes will forward notifications to nvim-notify
    -- Benefit of using Noice for this is the routing and consistent history view
    view = 'notify',
    fallback = 'mini',
    enabled = true,
    -- format = "notify",
    -- replace = false,
  },
  smart_move = {
    -- noice tries to move out of the way of existing floating windows.
    enabled = true, -- you can disable this behaviour here
    -- add any filetypes here, that shouldn't trigger smart move.
    excluded_filetypes = { 'cmp_menu', 'cmp_docs', 'notify' },
  },
  commands = {
    history = noice_views.historyView,
    -- :Noice last
    last = vim.tbl_extend('force', noice_views.historyView, { filter_opts = { count = 10 } }),
    -- :Noice errors
    errors = {
      -- options for the message history that you get with `:Noice errors`
      -- view = 'popup',
      view = noice_views.errorView,
      -- opts = { enter = true, format = noice_views.errorViewFormat },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
  },
  routes = noice_routes,
}

local error_message = function(message, opts)
  if opts.text and opts.text ~= '' then
    message:append(opts.text, opts.hl_group)
  end
end

-- vim.cmd([[]])
-- require('noice').setup(cfg)
require('noice').setup(cfg)
require('telescope').load_extension('noice')
noice_mapping.setup()

vim.keymap.set('c', '<S-Enter>', function()
  require('noice').redirect(vim.fn.getcmdline())
end, { desc = 'Redirect Cmdline' })

-- {
--   -- default format
--   default = { "{level} ", "{title} ", "{message}" },
--   -- default format for vim.notify views
--   notify = { "{message}" },
--   -- default format for the history
--   details = { "{level} ", "{date} ", "{event}",
--     { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
--     " ", "{title} ", "{cmdline} ", "{message}",
--   },
--   telescope = ..., -- formatter used to display telescope results
--   telescope_preview = ..., -- formatter used to preview telescope results
--   lsp_progress = ..., -- formatter used by lsp progress
--   lsp_progress_done = ..., -- formatter used by lsp progress
-- }

-- -- -- redirect ":hi"
-- require("noice").redirect("hi")
--
-- -- redirect some function
-- require("noice").redirect(function()
--   print("test")
-- end)
--
-- vim.api.nvim_create_autocmd('BufEnter', {})

-- notify           notify     nvim-notify with level=nil, replace=false,
--                             merge=false
-- split            split      horizontal split
-- vsplit           split      vertical split
-- popup            popup      simple popup
-- mini             mini       minimal view, by default bottom right, right-aligned
-- cmdline          popup      bottom line, similar to the classic cmdline
-- cmdline_popup    popup      fancy cmdline popup, with different styles according
-- cmdline_output   split      split used by config.presets.cmdline_output_to_split
-- messages         split      split used for :messages
-- confirm          popup      popup used for confirm events
-- hover            popup      popup used for lsp signature help and hover
-- popupmenu        nui.menu   special view with the options used to render the
