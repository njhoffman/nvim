

-- NuiLine
-- NuiLine is an abstraction layer on top of the following native functions:

-- vim.api.nvim_buf_set_lines (check :h nvim_buf_set_lines())
-- vim.api.nvim_buf_set_text (check :h nvim_buf_set_text())
-- vim.api.nvim_buf_add_highlight (check :h nvim_buf_add_highlight())
-- It helps you create line on the buffer containing multiple NuiTexts.


-- local NuiLine = require("nui.line")

-- local line = NuiLine()

-- line:append("Something Went Wrong!", "Error")

-- local bufnr, linenr = 0, 1

-- line:render(bufnr, linenr)
-- Parameters
-- Signature: NuiLine(texts?)

-- texts
-- Type: table[]

-- List of NuiText objects to set as initial texts.

-- Example


-- local text_one = NuiText("One")
-- local text_two = NuiText("Two")
-- local line = NuiLine({ text_one, text_two })
-- Methods
-- line:append(text, highlight?)
-- Adds a chunk of text to the line.

-- Parameters

-- Name	Type	Description
-- text	string or NuiText	text content
-- highlight	string or table	highlight information
-- If text is string, these parameters are passed to NuiText and a NuiText object is returned.

-- It text is already a NuiText object, it is returned unchanged.

-- line:content()
-- Returns the line content.

-- line:highlight(bufnr, ns_id, linenr)
-- Applies highlight for the line.

-- Parameters

-- Name	Type	Description
-- bufnr	number	buffer number
-- ns_id	number	namespace id (use -1 for fallback namespace)
-- linenr	number	line number (1-indexed)
-- line:render(bufnr, ns_id, linenr_start, linenr_end?)
-- Sets the line on buffer and applies highlight.

-- Parameters

-- Name	Type	Description
-- bufnr	number	buffer number
-- ns_id	number	namespace id (use -1 for fallback namespace)
-- linenr_start	number	start line number (1-indexed)
-- linenr_end	number	end line number (1-indexed)
--

-- nui.text, nui.line, nui.tree
----------------------------------------------------

-- local Popup = require("nui.popup")
-- local event = require("nui.utils.autocmd").event

-- local popup = Popup({
--   position = "50%",
--   size = {
--     width = 80,
--     height = 40,
--   },
--   enter = true,
--   focusable = true,
--   zindex = 50,
--   relative = "editor",
--   border = {
--     highlight = "FloatBorder",
--     padding = {
--       top = 2,
--       bottom = 2,
--       left = 3,
--       right = 3,
--     },
--     style = "rounded",
--     text = {
--       top = " I am top title ",
--       top_align = "center",
--       bottom = "I am bottom title",
--       bottom_align = "left",
--     },
--   },
--   buf_options = {
--     modifiable = true,
--     readonly = false,
--   },
--   win_options = {
--     winblend = 10,
--     winhighlight = "Normal:Normal",
--   },
-- })


-- -- mount/open the component
-- popup:mount()

-- -- unmount component when cursor leaves buffer
-- popup:on(event.BufLeave, function()
--   popup:unmount()
-- end)

-- -- set content
-- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })

----------------------------------------------------

-- local Input = require("nui.input")
-- local event = require("nui.utils.autocmd").event

-- local input = Input({
--   position = "20%",
--   size = {
--       width = 20,
--       height = 2,
--   },
--   relative = "editor",
--   border = {
--     highlight = "MyHighlightGroup",
--     style = "single",
--     text = {
--         top = "How old are you?",
--         top_align = "center",
--     },
--   },
--   win_options = {
--     winblend = 10,
--     winhighlight = "Normal:Normal",
--   },
-- }, {
--   prompt = "> ",
--   default_value = "42",
--   on_close = function()
--     print("Input closed!")
--   end,
--   on_submit = function(value)
--     print("You are " .. value .. " years old")
--   end,
-- })

-- -- mount/open the component
-- input:mount()

-- -- unmount component when cursor leaves buffer
-- input:on(event.BufLeave, function()
--   input:unmount()
-- end)

----------------------------------------------------


-- local Menu = require("nui.menu")
-- local event = require("nui.utils.autocmd").event

-- local menu = Menu({
--   position = "20%",
--   size = {
--     width = 20,
--     height = 2,
--   },
--   relative = "editor",
--   border = {
--     highlight = "MyHighlightGroup",
--     style = "single",
--     text = {
--       top = "Choose Something",
--       top_align = "center",
--     },
--   },
--   win_options = {
--     winblend = 10,
--     winhighlight = "Normal:Normal",
--   },
-- }, {
--   lines = {
--     Menu.item("Item 1"),
--     Menu.item("Item 2"),
--     Menu.separator("Menu Group"),
--     Menu.item("Item 3"),
--   },
--   max_width = 20,
--   separator = {
--     char = "-",
--     text_align = "right",
--   },
--   keymap = {
--     focus_next = { "j", "<Down>", "<Tab>" },
--     focus_prev = { "k", "<Up>", "<S-Tab>" },
--     close = { "<Esc>", "<C-c>" },
--     submit = { "<CR>", "<Space>" },
--   },
--   on_close = function()
--     print("CLOSED")
--   end,
--   on_submit = function(item)
--     print("SUBMITTED", vim.inspect(item))
--   end,
-- })

-- -- mount the component
-- menu:mount()

-- -- close menu when cursor leaves buffer
-- menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })

----------------------------------------------------

-- local Split = require("nui.split")
-- local event = require("nui.utils.autocmd").event

-- local split = Split({
--   relative = "editor",
--   position = "bottom",
--   size = "20%",
-- })

-- -- mount/open the component
-- split:mount()

-- -- unmount component when cursor leaves buffer
-- split:on(event.BufLeave, function()
--   split:unmount()
-- end)
