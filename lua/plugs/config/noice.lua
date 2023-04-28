-- vim.keymap.set()

-- Adding the following keymap, will redirect the active cmdline when pressing <S-Enter>. The cmdline stays open, so you can change the command and execute it again. When exiting the cmdline, the popup window will be focused.
vim.keymap.set('c', '<S-Enter>', function()
  require('noice').redirect(vim.fn.getcmdline())
end, { desc = 'Redirect Cmdline' })

local viewFormat = {
  '{date} ',
  '{event}',
  { '{kind}', before = { '.', hl_group = 'NoiceFormatKind' } },
  ' ',
  -- '{level} ',
  -- '{cmdline} ',
  '{title} ',
  '| {message}',
}

local historyViewOpts = {
  -- options for the message history that you get with `:Noice`
  -- view = 'split',
  view = 'popup',
  opts = { enter = true, format = viewFormat },
  filter = {
    any = {
      { event = '' },
      { event = 'notify' },
      { error = true },
      { warning = true },
      { event = 'msg_show' },
      { event = 'lsp', kind = 'message' },
    },
  },
}

local cfg = {
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  lsp = {
    progress = {
      enabled = true,
      -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
      -- See the section on formatting for more details on how to customize.
      format = 'lsp_progress',
      format_done = 'lsp_progress_done',
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = 'mini',
    },
    override = {
      -- override the default lsp markdown formatter with Noice
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      -- override the lsp markdown formatter with Noice
      ['vim.lsp.util.stylize_markdown'] = true,
      -- override cmp documentation with Noice (needs the other options to work)
      ['cmp.entry.get_documentation'] = true,
    },
    hover = {
      enabled = false,
      view = nil, -- when nil, use defaults from documentation
      opts = {}, -- merged with defaults from documentation
    },
    signature = {
      enabled = false,
    },

    -- defaults for hover and signature help
    documentation = {
      view = 'hover',
      opts = {
        lang = 'markdown',
        replace = false,
        render = 'plain',
        format = { '{message}' },
        win_options = { concealcursor = 'n', conceallevel = 3 },
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
    ['notify'] = {
      render = 'minimal',
    },
    -- ['mini'] = {
    --   reverse = false,
    --   align = 'message-left',
    --   timeout = 5000,
    --   position = { row = -2, col = -2 },
    --
    --   size = {
    --     max_height = math.ceil(0.8 * vim.o.lines),
    --     max_width = math.ceil(0.5 * vim.o.columns),
    --     min_width = 30,
    --     width = 'auto',
    --     height = 'auto',
    --   },
    --
    --   border = {
    --     text = { top = '', top_align = 'left', bottom = '' },
    --     style = {
    --       { '▐', 'NoiceMiniBorder' },
    --       { ' ', 'NoiceMini' },
    --       { ' ', 'NoiceMini' },
    --       { ' ', 'NoiceMini' },
    --       { ' ', 'NoiceMini' },
    --       { ' ', 'NoiceMini' },
    --       { '▐', 'NoiceMiniBorder' },
    --       { '▐', 'NoiceMiniBorder' },
    --     },
    --     padding = { top = 0, bottom = 0, left = 1, right = 0 },
    --   },
    --
    --   win_options = { winblend = 0 },
    -- },
    --
    --         ['cmdline'] = {
    --           backend = 'mini',
    --           relative = 'editor',
    --           align = 'message-left',
    --           timeout = 100,
    --           reverse = true,
    --           position = { row = -2, col = 0 },
    --           size = 'auto',
    --           zindex = 60,
    --
    --           border = {
    --             style = {
    --               { '╭', 'NoiceCmdlineBorder' },
    --               { '─', 'NoiceCmdlineBorder' },
    --               { '╮', 'NoiceCmdlineBorder' },
    --               { '│', 'NoiceCmdlineBorder' },
    --               { '╯', 'NoiceCmdlineBorder' },
    --               { '─', 'NoiceCmdlineBorder' },
    --               { '╰', 'NoiceCmdlineBorder' },
    --               { '│', 'NoiceCmdlineBorder' },
    --             },
    --             padding = { left = 1, right = 1 },
    --           },
    --
    --           win_options = {
    --             winblend = 0,
    --             winhighlight = { Normal = 'NoiceCmdlineNormal', IncSearch = '', Search = '' },
    --           },
    --         },
    cmdline_popup = {
      position = {
        -- row = 5,
        row = '30%',
        col = '50%',
      },
      size = {
        width = 'auto',
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
        cursorline = true,
      },
      -- border = {
      -- style = "none",
      -- padding = { 2, 3 },
      -- },
      -- filter_options = {},
      -- win_options = {
      -- winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      -- },
    },
    cmdline_output = {
      format = 'details',
      view = 'popup',
    },
  },
  popupmenu = {
    -- backend = 'nui', -- backend to use to show regular cmdline completions
    relative = 'editor',
    position = {
      -- row = 8,
      row = '50%',
      col = '50%',
    },
    size = {
      width = 'auto',
      height = 'auto',
      -- max_height = 20,
      -- min_width = 10,
    },
    cmdline_output = {
      format = 'details',
      view = 'popup',
    },
    border = {
      style = 'rounded',
      padding = { 0, 1 },
    },
    win_options = {
      winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
    },
  },
  notify = {
    -- Noice can be used as `vim.notify` so you can route any notification like other messages
    -- Notification messages have their level and other properties set.
    -- event is always "notify" and kind can be any log level as a string
    -- The default routes will forward notifications to nvim-notify
    -- Benefit of using Noice for this is the routing and consistent history view
    backend = 'notify',
    fallback = 'mini',
    -- format = "notify",
    -- replace = false,
    -- merge = false,
  },
  smart_move = {
    -- noice tries to move out of the way of existing floating windows.
    enabled = true, -- you can disable this behaviour here
    -- add any filetypes here, that shouldn't trigger smart move.
    excluded_filetypes = { 'cmp_menu', 'cmp_docs', 'notify' },
  },
  commands = {
    history = historyViewOpts,

    -- :Noice last
    last = vim.tbl_extend('force', historyViewOpts, { filter_opts = { count = 10 } }),

    -- :Noice errors
    errors = {
      -- options for the message history that you get with `:Noice`
      view = 'popup',
      opts = { enter = true, format = viewFormat },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
  },
  routes = {
    -- { -- all messages over 20 to split
    --   view = 'split',
    --   filter = { event = 'msg_show', min_height = 20 },
    -- },
    { -- all search not found messages to mini
      view = 'mini',
      filter = { event = 'msg_show', find = '^E486:' },
    },
    { -- all 'no more items' to mini
      view = 'mini',
      filter = { event = 'msg_show', find = '^E553:' },
    },
    { -- all read messages to imini
      filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+ lines? %-%-%d+%%%-%-$' },
      view = 'mini',
    },
    { -- Hide diagnostics messages
      filter = { event = 'lsp', find = ' diagnostics_on_open ' },
      opts = { skip = true },
    },
    -- {
    --   filter = { event = 'msg_show', kind = '', find = '^".+"  ?%[.+%] %d+ lines? %-%-%d+%%%-%-$' },
    --   opts = { skip = true },
    -- },
    -- {
    --   filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+L, %d+B$' },
    --   opts = { skip = true },
    -- },
    -- {
    --   filter = { event = 'msg_show', kind = '', find = '^".+"  ?%[.+%] %d+L, %d+B$' },
    --   opts = { skip = true },
    -- },
    -- { -- Hide Search
    --   filter = { event = 'msg_show', kind = 'search_count' },
    --   opts = { skip = true },
    -- },
    -- { -- Hide Search
    --   filter = { event = 'msg_show', kind = '', find = '^[/?].+ +%[%d+/%d+%]' },
    --   opts = { skip = true },
    -- },
    -- { -- Hide Search
    --   filter = { event = 'msg_show', kind = '', find = '^[/?].+' },
    --   opts = { skip = true },
    -- },
  },
}

-- >lua
--     vim.keymap.set("n", "<leader>nl", function()
--       require("noice").cmd("last")
--     end)
--
--     vim.keymap.set("n", "<leader>nh", function()
--       require("noice").cmd("history")
--     end)
-- <
-- -- -- redirect ":hi"
-- require("noice").redirect("hi")
--
-- -- redirect some function
-- require("noice").redirect(function()
--   print("test")
-- end)
require('noice').setup(cfg)
require('telescope').load_extension('noice')

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

-- vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
--   if not require("noice.lsp").scroll(4) then
--     return "<c-f>"
--   end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
--   if not require("noice.lsp").scroll(-4) then
--     return "<c-b>"
--   end
-- end, { silent = true, expr = true })
