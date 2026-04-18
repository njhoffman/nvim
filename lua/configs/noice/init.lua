local sections = require("configs.noice.sections")

require("noice").setup({
  lsp = sections.lsp,
  cmdline = sections.cmdline,
  routes = sections.routes,
  markdown = sections.markdown,
  redirect = sections.redirect,
  smart_move = sections.smart_move,
  notify = sections.notify,
  messages = {
    view_search = false,
  },
  popupmenu = vim.tbl_deep_extend("force", sections.popupmenu, {
    enabled = true,
    backend = "nui",
  }),
  views = vim.tbl_deep_extend("force", sections.views, {
    split = { scrollbar = false },
    popup = { scrollbar = false },
  }),
  commands = {
    history = {
      view = "split",
      opts = {
        enter = true,
        format = "details",
        tail = true,
        win_options = { winbar = "Noice History" },
      },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
    },
    last = {
      view = "popup",
      opts = { enter = true, format = "details", win_options = { winbar = "Noice Details" } },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    errors = {
      view = "popup",
      opts = {
        tail = true,
        enter = true,
        format = "details",
        win_options = { winbar = "Noice Errors" },
      },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
    all = {
      view = "split",
      opts = {
        tail = true,
        enter = true,
        format = "details",
        win_options = { winbar = "Noice All" },
      },
      filter = {},
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
})
