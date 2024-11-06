local sections = require("configs.noice.sections")
local commands = require("configs.noice.commands")
local mapping = require("configs.noice.mapping")
local views = require("configs.noice.views")

---@param message NoiceMessage
---@param stay? fun():boolean
-- function M.show(message, stay)
--   M.autohide()
--   message.opts.timeout = 100
--   message.opts.keep = function()
--     return true
--   end
--   message.opts.stay = stay
--   for _, m in pairs(M._messages) do
--     if m ~= message then
--       M.hide(m)
--     end
--   end
--   Manager.add(message)
-- end

local config = {
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    -- https://github.com/neovim/neovim/issues/21044
    long_message_to_split = false, -- long messages will be sent to a split
    -- long_message_to_split = { routes = { { filter = { event = "msg_show", min_height = 20 }, view = "cmdline_output", }, }, },
    -- inc_rename = { cmdline = { format = { IncRename =
    --    { pattern = "^:%s*IncRename%s+", icon = " ", conceal = true,
    --     opts = { relative = "cursor", size = { min_width = 20 }, position = { row = -3, col = 0 }, }, }, }, }, },
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
    -- cmdline_output_to_split = true,
    -- cmdline_output_to_split = { routes = { { view = "cmdline_output", filter = { cmdline = "^:" }, }, }, },
  },
  routes = sections.routes,
  cmdline = sections.cmdline,
  views = sections.views,
  markdown = sections.markdown,
  redirect = sections.redirect,
  smart_move = sections.smart_move,
  notify = sections.notify,
  lsp = sections.lsp,
  -- popupmenu = sections.popupmenu,
  messages = {
    enabled = true, -- enables the Noice messages UI
    view = "notify", -- default view for messages
    view_error = "notify", -- view for errors
    view_warn = "notify", -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  format = {
    telescope = views.telescopeViewFormat,
    level = {
      icons = {
        error = "",
        warn = "",
        info = "",
        debug = "",
        trace = "",
      },
    },
  },
  commands = {
    history = views.historyView,
    -- :Noice last
    last = vim.tbl_extend("force", views.historyView, { filter_opts = { count = 10 } }),
    -- :Noice errors
    errors = {
      -- options for the message history that you get with `:Noice errors`
      -- view = 'popup',
      view = views.errorView,
      -- opts = { enter = true, format = views.errorViewFormat },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
  },
}

local error_message = function(message, opts)
  if opts.text and opts.text ~= "" then
    message:append(opts.text, opts.hl_group)
  end
end

-- vim.cmd([[]])
-- require('noice').setup(cfg)
require("noice").setup(config)
require("telescope").load_extension("noice")

-- commands.setup()
-- mapping.setup()

-- require("noice.user.cmdline")
