-- local sections = require("configs.noice.sections")
-- local commands = require("configs.noice.commands")
-- local mapping = require("configs.noice.mapping")
-- local views = require("configs.noice.views")

-- -- 			{ filter = { event = "msg_show", find = "%d+B written$" }, view = "mini" },
-- -- 			{ filter = { event = "msg_show", find = "%d+L, %d+B$" }, view = "mini" },
-- -- 			{ filter = { event = "msg_show", find = "%-%-No lines in buffer%-%-" }, view = "mini" },
-- --
-- -- 			-- search
-- -- 			{ filter = { event = "msg_show", find = "^E486: Pattern not found" }, view = "mini" },
-- -- 			{ filter = { event = "msg_show", find = "^[/?]." }, skip = true },
-- --
-- -- 			-- output from `:Inspect` for easier copying
-- -- 			{ filter = { event = "msg_show", find = "Treesitter.*- @" }, view = "popup" },
-- --
-- -- 			-- FIX https://github.com/artempyanykh/marksman/issues/348
-- -- 			{ filter = { event = "notify", find = "^Client marksman quit with" }, skip = true },
-- --
-- -- 			-- code actions
-- -- 			{ filter = { event = "notify", find = "No code actions available" }, skip = true },
-- local config = {
--   health = {
--     checker = false, -- Disable if you don't want health checks to run
--   },
--   presets = {
--     bottom_search = false, -- use a classic bottom cmdline for search
--     command_palette = false, -- position the cmdline and popupmenu together
--     -- https://github.com/neovim/neovim/issues/21044
--     long_message_to_split = false, -- long messages will be sent to a split
--     -- long_message_to_split = { routes = { { filter = { event = "msg_show", min_height = 20 }, view = "cmdline_output", }, }, },
--     -- inc_rename = { cmdline = { format = { IncRename =
--     --    { pattern = "^:%s*IncRename%s+", icon = " ", conceal = true,
--     --     opts = { relative = "cursor", size = { min_width = 20 }, position = { row = -3, col = 0 }, }, }, }, }, },
--     inc_rename = true, -- enables an input dialog for inc-rename.nvim
--     lsp_doc_border = true, -- add a border to hover docs and signature help
--     -- cmdline_output_to_split = true,
--     -- cmdline_output_to_split = { routes = { { view = "cmdline_output", filter = { cmdline = "^:" }, }, }, },
--   },
--   routes = sections.routes,
--   cmdline = sections.cmdline,
--   views = sections.views,
--   markdown = sections.markdown,
--   redirect = sections.redirect,
--   smart_move = sections.smart_move,
--   notify = sections.notify,
--   lsp = sections.lsp,
--   -- popupmenu = sections.popupmenu,
--   inc_rename = {
--     cmdline = {
--       format = {
--         IncRename = { icon = "⟳" },
--       },
--     },
--   },
--   messages = {
--     enabled = true, -- enables the Noice messages UI
--     view = "notify", -- default view for messages
--     view_error = "notify", -- view for errors
--     view_warn = "notify", -- view for warnings
--     view_history = "messages", -- view for :messages
--     view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
--   },
--   format = {
--     telescope = views.telescopeViewFormat,
--     level = { icons = { error = "", warn = "", info = "", debug = "", trace = "" } },
--   },
-- }

-- local error_message = function(message, opts)
--   if opts.text and opts.text ~= "" then
--     message:append(opts.text, opts.hl_group)
--   end
-- end

-- require("noice").setup(config)
-- -- require("telescope").load_extension("noice")

-- commands.setup()
-- mapping.setup()

-- -- require("noice.user.cmdline")
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  views = {
    split = {
      scrollbar = false,
    },
    popup = {
      scrollbar = false,
    },
  },
  commands = {
    history = {
      -- options for the message history that you get with `:Noice`
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
    -- :Noice last
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
    -- :Noice errors
    errors = {
      -- options for the message history that you get with `:Noice`
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
      -- options for the message history that you get with `:Noice`
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

  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
})
