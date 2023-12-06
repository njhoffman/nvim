local routes = {
  -- { filter = { event = 'notify.error_error' }, view = 'mini' },
  -- { filter = { event = 'msg_show.lua_error' }, view = 'mini' },
  -- skip all lines
  -- { filter = { event = "msg_show", ["not"] = { kind = { "confirm", "confirm_sub" }, }, }, opts = { skip = true }, },
  {
    view = 'mini',
    filter = {
      any = {
        -- write/deletion messages
        { event = 'msg_show', find = '%d+B written$' },
        { event = 'msg_show', find = '%d+L, %d+B$' },
        { event = 'msg_show', find = '%-%-No lines in buffer%-%-' },
        -- all "Closed # popup windows" to mini
        { event = 'msg_show', find = '^Closed %d+ popup windows' },
        -- all "Cannot make changes, 'modifiable' is off" to mini
        { event = 'msg_show', find = '^E21:' },
        -- Could not apply exmtark to....
        { event = 'msg_show', find = '^Could not apply exmtark to ' },
        -- all search not found messages to mini
        { event = 'msg_show', find = '^E486: Pattern not found' },
        -- no tags file message
        { event = 'msg_show', find = '^E433:' },
        -- tags not found message
        { event = 'msg_show', find = '^E426:' },
        -- no previous command name
        { event = 'msg_show', find = '^E433:' },
        -- all 'no more items' to mini
        { event = 'msg_show', find = '^E553:' },
        -- all '%d change; after #%d  %d seconds ago'
        { event = 'msg_show', find = '^%d+ change' },
        -- all '%d line less/more; before #%d  %d seconds ago'
        { event = 'msg_show', find = '^%d+ line less' },
        { event = 'msg_show', find = '^%d+ line more' },
        { event = 'msg_show', find = '^%d+ more lines?' },
        -- all delete line messages to imini
        { event = 'msg_show', find = '^%d+ fewer lines?' },
        -- Diagnostics
        { event = 'msg_show', find = 'No more valid diagnostics to move to' },
        -- :make
        { event = 'msg_show', find = '^:!make' },
        { event = 'msg_show', find = '^%(%d+ of %d+%):' },
      },
      -- -- nvim-treesitter
      -- { filter = { event = "msg_show", find = "^%[nvim%-treesitter%]" }, view = "mini" },
      -- { filter = { event = "notify", find = "All parsers are up%-to%-date" }, view = "mini" },
      -- -- Mason
      -- { filter = { event = "notify", find = "%[mason%-tool%-installer%]" }, view = "mini" },
      -- {
      --   filter = {
      --     event = "notify",
      --     cond = function(msg)
      --       return msg.opts and msg.opts.title and msg.opts.title:find("mason.*.nvim")
      --     end,
      --   },
      --   view = "mini",
      -- },
      -- -- DAP
      -- { filter = { event = "notify", find = "^Session terminated$" }, view = "mini" },
    },
  },
  {
    filter = {
      any = {
        -- hide treesitter out of bounds messages
        -- TODO: set syn to filetype after this happens
        { event = 'msg_show', find = '^Error in decoration provider treesitter/highlighter.line:' },
        -- hide hover no information available
        { event = 'msg_show', find = 'No information available' },
        -- hide diagnostics messages
        { event = 'lsp', find = ' diagnostics_on_open ' },
        -- all jsonls Unhandled method textDocument/diagnostic errors hidden
        { event = 'notify', find = '^jsonls: ' },
      },
    },
    opts = { skip = true },
  },
  {
    filter = {
      any = {
        { event = 'msg_show', find = '^RPC%[Error%]' },
      },
    },
    view = 'notify',
    opts = {
      title = 'Error',
      level = vim.log.levels.ERROR,
    },
  },
  -- route messages to notify view
  {
    view = 'notify',
    opts = {
      level = vim.log.levels.DEBUG,
    },
    filter = {
      any = {
        { event = 'msg_show', kind = '' },
        { event = 'msg_show', kind = 'echo' },
        { event = 'msg_show', kind = 'echomsg' },
      },
    },
  },
  -- always route any messages with more than 20 lines to the split view
  {
    view = 'split',
    filter = { event = 'msg_show', min_height = 20 },
  },
  -- { filter = { event = 'msg_show', find = '^ERROR: ' }, view = 'notify' },
  -- { filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+L, %d+B$' }, opts = { skip = true }, },
  -- { filter = { event = 'msg_show', kind = '', find = '^".+"  ?%[.+%] %d+L, %d+B$' },
  -- {  filter = { event = 'msg_show', kind = '', find = '^".+"  ?%d+ lines? %-%-%d+%%%-%-$' },
  -- {  filter = { event = 'msg_show', find = '^".+"  ?%[.+%] %d+ lines? %-%-%d+%%%-%-$' }, opts = { skip = true }},
  -- Hide Search
  -- { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true }, },
  -- { filter = { event = 'msg_show', kind = '', find = '^[/?].+ +%[%d+/%d+%]' }, opts = { skip = true }, },
  -- { filter = { event = 'msg_show', kind = '', find = '^[/?].+' }, opts = { skip = true }, },
}

return routes

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
--                           confirm	confirm_sub	emsg echo echomsg	echoerr	lua_error	rpc_error
--                           return_prompt	quickfix	search_count	wmsg
--   max_height   number     maximum height of the message
--   max_length   number     maximum length of the message (total width of all the lines)
--   max_width    number     maximum width of the message
--   min_height   number     minimum height of the message
--   min_length   number     minimum length of the message (total width of all the lines)
--   min_width    number     minimum width of the message
--   mode         string     checks if vim.api.nvim_get_mode() contains the given mode
--   not          filter     checks wether the filter matches or not
--   warning      boolean    all warning-like kinds from ext_messages
