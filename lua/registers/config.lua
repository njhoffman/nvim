---Get the default values for all options.
---@return options options Default values for all options.
local default_options = function()
  local ui = require("registers.ui")
  local utils = require("registers.utils")
  local preview = require("registers.preview")

  return {
    -- Show these registers in the order of the string
    show = '*+"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:',
    -- Show a line at the bottom with registers that aren't filled
    show_empty = true,
    -- Expose the :Registers user command
    register_user_command = true,
    -- Always transfer all selected registers to the system clipboard
    system_clipboard = true,
    -- Don't show whitespace at the begin and end of the register's content
    trim_whitespace = true,
    -- Don't show registers which are exclusively filled with whitespace
    hide_only_whitespace = true,
    -- Show a character next to the register name indicating how the register will be applied
    show_register_types = true,
    bind_keys = {
      -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
      normal = ui.show_window({ mode = "motion" }),
      -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
      visual = ui.show_window({ mode = "motion" }),
      -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
      insert = ui.show_window({ mode = "insert" }),

      -- When pressing the key of a register, apply it with a very small delay, which will also highlight the selected register
      registers = utils.apply_register({ delay = 0.1 }),
      -- Immediately apply the selected register line when pressing the return key
      ["<CR>"] = utils.apply_register(),
      -- Close the registers window when pressing the Esc key
      ["<Esc>"] = ui.close_window(),

      -- Move the cursor in the registers window down when pressing <C-n>
      ["<C-n>"] = ui.move_cursor_down(),
      -- Move the cursor in the registers window up when pressing <C-p>
      ["<C-p>"] = ui.move_cursor_up(),
      -- Move the cursor in the registers window down when pressing <C-j>
      ["<C-j>"] = ui.move_cursor_down(),
      -- Move the cursor in the registers window up when pressing <C-k>
      ["<C-k>"] = ui.move_cursor_up(),
      -- Clear the register of the highlighted line when pressing <DeL>
      ["<Del>"] = utils.clear_highlighted_register(),
      -- Clear the register of the highlighted line when pressing <BS>
      ["<BS>"] = utils.clear_highlighted_register(),
      -- Toggle through pre-defined or custom layouts
      ["<C-^>"] = ui.switch_layout(),
    },
    events = {
      -- When a register line is highlighted, show a preview in the main buffer with how the register will be applied, but only if the register will be inserted or pasted
      on_register_highlighted = preview.preview_register({ if_mode = { "insert", "paste" } }),
    },
    symbols = {
      -- Show a special character for line breaks
      newline = "⏎",
      -- Show space characters without changes
      space = " ",
      -- Show a special character for tabs
      tab = "·",
      -- The character to show when a register will be applied in a char-wise fashion
      register_type_charwise = "ᶜ",
      -- The character to show when a register will be applied in a line-wise fashion
      register_type_linewise = "ˡ",
      -- The character to show when a register will be applied in a block-wise fashion
      register_type_blockwise = "ᵇ",
    },
    window = {
      -- The window can't be wider than 100 characters
      max_width = 100,
      -- Show a small highlight in the sign column for the line the cursor is on
      highlight_cursorline = true,
      -- Don't draw a border around the registers window
      border = "none",
      -- Apply a tiny bit of transparency to the the window, letting some characters behind it bleed through
      transparency = 10,
      -- Optional function to customize window properties
      func = nil,
    },
    -- Highlight the sign registers as regular Neovim highlights
    sign_highlights = {
      cursorlinesign = "CursorLine",
      signcolumn = "SignColumn",
      cursorline = "Visual",
      selection = "Constant",
      default = "Function",
      unnamed = "Statement",
      read_only = "Type",
      expression = "Exception",
      black_hole = "Error",
      alternate_buffer = "Operator",
      last_search = "Tag",
      delete = "Special",
      yank = "Delimiter",
      history = "Number",
      named = "Todo",
      register_preview = "Normal",
    },
  }
end

local log = require("logger").init("registers")

local options = nil
local setup = function(opts)
  -- Create the options object with default values
  options = vim.tbl_deep_extend("keep", opts or {}, default_options())
  log:debug("config.setup merged user opts into defaults")
  return options
end

local get = function()
  return options
end

return { setup = setup, get = get }
