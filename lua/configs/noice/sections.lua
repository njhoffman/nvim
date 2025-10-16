local popupmenu = {
  relative = "editor",
  position = {
    row = 11,
    col = "50%",
  },
  size = {
    width = 60,
    height = 10,
  },
  border = {
    style = "rounded",
    padding = { 0, 1 },
  },
  win_options = {
    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
  },
}

local redirect = {
  view = "popup",
  filter = { event = "msg_show" },
}

local notify = {
  -- Noice can be used as `vim.notify` so you can route any notification like other messages
  -- Notification messages have their level and other properties set.
  -- event is always "notify" and kind can be any log level as a string
  -- The default routes will forward notifications to nvim-notify
  -- Benefit of using Noice for this is the routing and consistent history view
  view = "notify",
  fallback = "mini",
  enabled = true,
  -- format = "notify",
  -- replace = false,
}

local markdown = {
  -- Markdown.format(message, text) (highlights)
  -- message:render(buf, Config.ns)
  -- Markdown.keys(buf) (hover)
  -- hover = {
  --   -- noice.text.markdown.keys -- Markdown.keys
  --   ["|(%S-)|"] = vim.cmd.help, -- vim help links
  --   ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
  -- },
  highlights = {
    -- noice.text.markdown.format --  Markdown.format
    -- ['|%S-|'] = '@markup.link.vimdoc', --  '@markup.link.label.markdown_inline',
    -- ['%[.-%]%((%S-)%)'] = '@markup.link.label', -- markdown links, @string.special.url.vimdoc:@string.special.url
    -- ['@%S+'] = '@parameter',
    -- ['^%s(Parameters:)'] = '@text.title',
    -- ['^%s(Return:)'] = '@text.title',
    -- ['^%s(See also:)'] = '@text.title',
    -- ['{%S-}'] = '@parameter',
    -- @label.vimdoc, @comment.note.vimdoc, @variable.parameter.vimdoc, @markup.raw.block.vimdoc,
    -- @markup.link.vimdoc, @markup.heading.1.vimdoc
    -- • on_start:
    --                 • on_start:
    -- nvim_buf_del_keymap({buffer}, {mode}, {lhs})           *nvim_buf_del_keymap()*

    ["|%S-|"] = "@text.reference",
    ["@%S+"] = "@parameter",
    ["^%s*(Parameters:)"] = "@text.title",
    ["^%s*(Return:)"] = "@text.title",
    ["^%s*(See also:)"] = "@text.title",
    ["{%S-}"] = "@parameter",
  },
}

local smart_move = {
  -- noice tries to move out of the way of existing floating windows.
  enabled = true, -- you can disable this behaviour here
  -- add any filetypes here, that shouldn't trigger smart move.
  excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
}

local sections = {
  markdown = markdown,
  popupmenu = popupmenu,
  redirect = redirect,
  smart_move = smart_move,
  notify = notify,
  lsp = require("configs.noice.lsp"),
  cmdline = require("configs.noice.cmdline"),
  routes = require("configs.noice.routes"),
  views = require("configs.noice.views").config,
  -- popoupmenu = require('configs.noice.popupmenu'),
}

return sections
