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

local cmdlineView = {
  reverse = false,
  align = 'message-left',
  timeout = 5000,
  position = { row = -2, col = -2 },

  size = {
    max_height = math.ceil(0.8 * vim.o.lines),
    max_width = math.ceil(0.5 * vim.o.columns),
    min_width = 30,
    width = 'auto',
    height = 'auto',
  },
  border = {
    text = { top = '', top_align = 'left', bottom = '' },
    style = {
      { '▐', 'NoiceMiniBorder' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { ' ', 'NoiceMini' },
      { '▐', 'NoiceMiniBorder' },
      { '▐', 'NoiceMiniBorder' },
    },
    padding = { top = 0, bottom = 0, left = 1, right = 0 },
  },
  win_options = { winblend = 0 },
}

local miniView = {
  backend = 'mini',
  relative = 'editor',
  align = 'message-left',
  timeout = 100,
  reverse = true,
  position = { row = -2, col = 0 },
  size = 'auto',
  zindex = 60,
  border = {
    style = {
      { '╭', 'NoiceCmdlineBorder' },
      { '─', 'NoiceCmdlineBorder' },
      { '╮', 'NoiceCmdlineBorder' },
      { '│', 'NoiceCmdlineBorder' },
      { '╯', 'NoiceCmdlineBorder' },
      { '─', 'NoiceCmdlineBorder' },
      { '╰', 'NoiceCmdlineBorder' },
      { '│', 'NoiceCmdlineBorder' },
    },
    padding = { left = 1, right = 1 },
  },

  win_options = {
    winblend = 0,
    winhighlight = { Normal = 'NoiceCmdlineNormal', IncSearch = '', Search = '' },
  },
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

local errorViewOpts = {
  -- options for the message history that you get with `:Noice`
  -- view = 'split',
  view = 'notify',
  opts = { enter = true, format = viewFormat },
  filter = {
    any = {
      { event = '' },
      { event = 'notify' },
      { error = true },
      { warning = true },
      { event = 'msg_show' },
    },
  },
}

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
    -- ['mini'] = miniView,
    -- ['cmdline'] = cmdlineView,
    ['notify'] = {
      render = 'minimal',
    },
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
    backend = 'nui', -- backend to use to show regular cmdline completions
    relative = 'window',
    position = {
      -- row = 8,
      row = '50%',
      col = '50%',
    },
    size = {
      width = 'auto',
      height = 'auto',
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
    -- FILTERS                       *noice.nvim-noice-(nice,-noise,-notice)-filters*
    -- **Noice** uses filters to route messages to specific views.
    --   ------------------------------------------------------------------------------
    --   Name         Type       Description
    --   ------------ ---------- ------------------------------------------------------
    --   any          filter[]   checks that at least one of the filters matches
    --   blocking     boolean    are we in blocking mode?
    --   cleared      boolean    checks if the message is cleared, meaning it’s in the history
    --   cmdline      boolean or checks if the message was generated by executing a string cmdline. When string, then it is used as a pattern
    --   error        boolean    all error-like kinds from ext_messages
    --   event        string or  any of the events from ext_messages or cmdline. See :h string[]   ui-messages
    --   find         string     uses lua string.find to match the pattern
    --   has          boolean    checks if the message is exists, meaning it’s in the history
    --   kind         string or  any of the kinds from ext_messages. See :h ui-messages string[]
    --   max_height   number     maximum height of the message
    --   max_length   number     maximum length of the message (total width of all the lines)
    --   max_width    number     maximum width of the message
    --   min_height   number     minimum height of the message
    --   min_length   number     minimum length of the message (total width of all the lines)
    --   min_width    number     minimum width of the message
    --   mode         string     checks if vim.api.nvim_get_mode() contains the given mode
    --   not          filter     checks wether the filter matches or not
    --   warning      boolean    all warning-like kinds from ext_messages

    -- all search not found messages to mini
    { filter = { event = 'msg_show', find = '^E486:' }, view = 'mini' },
    { filter = { event = 'msg_show', find = '^E433:' }, view = 'mini' },
    -- no tags file message
    { filter = { event = 'msg_show', find = '^E426:' }, view = 'mini' },
    -- tags not found message
    { filter = { event = 'msg_show', find = '^E433:' }, view = 'mini' },
    -- no previous command name
    { filter = { event = 'msg_show', find = '^E30:' }, view = 'mini' },
    -- all 'no more items' to mini
    { filter = { event = 'msg_show', find = '^E553:' }, view = 'mini' },
    -- all put line messages to mini
    { filter = { event = 'msg_show', kind = '', find = '^%d+ more lines?$' }, view = 'mini' },
    -- all delete line messages to imini
    { filter = { event = 'msg_show', kind = '', find = '^%d+ fewer lines?$' }, view = 'mini' },
    -- hide hover no information available
    { filter = { event = 'msg_show', find = 'No information available' }, opts = { skip = true } },
    -- hide diagnostics messages
    { filter = { event = 'lsp', find = ' diagnostics_on_open ' }, opts = { skip = true } },
    -- { filter = { event = 'msg_show', find = '^ERROR: ' }, view = 'notify' },

    -- {
    --   filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+L, %d+B$' },
    --   opts = { skip = true },
    -- },
    -- {
    --   filter = { event = 'msg_show', kind = '', find = '^".+"  ?%[.+%] %d+L, %d+B$' },
    -- filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+ lines? %-%-%d+%%%-%-$' },
    -- filter = { event = 'msg_show', kind = '', find = '^".+"  ?%[.+%] %d+ lines? %-%-%d+%%%-%-$' },
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

vim.keymap.set({ 'n', 'i', 's' }, '<M-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<M-f>'
  end
end, { silent = true, expr = true })

-- vim.keymap.set({ 'n', 'i', 's' }, '<C-f>', function()
--   if not require('noice.lsp').scroll(2) then
--     return '<C-f>'
--   end
-- end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<M-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<M-b>'
  end
end, { silent = true, expr = true })

-- vim.keymap.set({ 'n', 'i', 's' }, '<C-b>', function()
--   if not require('noice.lsp').scroll(-2) then
--     return '<C-b>'
--   end
-- end, { silent = true, expr = true })

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

local error_message = function(message, opts)
  if opts.text and opts.text ~= '' then
    message:append(opts.text, opts.hl_group)
  end
end

require('noice').setup(cfg)
require('telescope').load_extension('noice')
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
