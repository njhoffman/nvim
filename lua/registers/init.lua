---@brief [[
---Registers.nvim is a minimal but very configurable Neovim plugin.
---Keys can be bound using functions, to make it easier for use I've made all functions except `registers.setup()` return callback functions that can be configured and passed to fields in the `bind_keys` example.
---
---For example, to apply a delay of a second after selecting the register with its key (for example pressing the '0' key to apply the '0' register when it's open):
---use {
---  "tversteeg/registers.nvim",
---  config = function()
---    local registers = require("registers")
---    registers.setup({
---      bind_keys = {
---        registers = registers.apply_register({ delay = 1 }),
---      },
---    })
---  end
---}
---<
---@brief ]]

local ui = require("registers.ui")
local mappings = require("registers.mappings")
local state = require("registers.state")
local config = require("registers.config")
local log = require("logger").init("registers")

---@class registers
---@field options options
local registers = {}

---@mod setup `registers.setup` configuration options.

---`require("registers").setup({...})`
---@class options
---@field show string Which registers to show and in what order. Default is `"*+\"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:"`.
---@field show_empty boolean Show the registers which aren't filled in a separate line. Default is `true`.
---@field register_user_command boolean Whether to register the `:Registers` user command. Default is `true`.
---@field system_clipboard boolean Transfer selected register to the system clipboard. Default is `true`.
---@field trim_whitespace boolean Don't show whitespace at the begin and and of the registers, won't change the output from applying the register. Default is `true`.
---@field hide_only_whitespace boolean Treat registers with only whitespace as empty registers. Default is `true`.
---@field show_register_types boolean Show how the register will be applied in the sign bar, the characters can be customized in the `symbols` table. Default is `true`.
---@field bind_keys bind_keys_options|boolean Which keys to bind, `true` maps all keys and `false` maps no keys.
---@field events events_options Functions that will be called when certain events happen.
---@field symbols symbols_options Symbols used to replace text in the previous buffer.
---@field window window_options Floating window
---@field sign_highlights sign_highlights_options Highlights for the sign section of the window

---@alias register_mode
---| '"insert"' # Insert the register's contents like when in insert mode and pressing <C-R>.
---| '"paste"' # Insert the register's contents by pretending a pasting action, similar to pressing "*reg*p, cannot be used in insert mode.
---| '"motion"' # Create a motion from the register, similar to pressing "*reg* (without pasting it yet).

---`require("registers").setup({ bind_keys = {...} })`
---@class bind_keys_options
---@field normal fun()|false Function to map to " in normal mode to display the registers window, `false` to disable the binding. Default is `registers.show_window({ mode = "motion" })`.
---@field visual fun()|false Function to map to " in visual mode to display the registers window, `false` to disable the binding. Default is `registers.show_window({ mode = "motion" })`.
---@field insert fun()|false Function to map to <C-R> in insert mode to display the registers window, `false` to disable the binding. Default is `registers.show_window({ mode = "insert" })`.
---@field registers fun(register:string,mode:register_mode) Function to map to the register selected by pressing it's key. Default is `registers.apply_register()`.
---@field [string] fun()|false Function to map to the custom key binding in the registers window.
---@field return_key fun(register:string,mode:register_mode) Deprecated, function to map to <CR> in the registers window. Default is `registers.apply_register()`.
---@field escape fun(register:string,mode:register_mode) Deprecated, function to map to <ESC> in the registers window. Default is `registers.close_window()`.
---@field ctrl_n fun()|false Deprecated, function to map <C-N> in the registers window. Default is `registers.move_cursor_down()`.
---@field ctrl_p fun()|false Deprecated, function to map <C-P> in the registers window. Default is `registers.move_cursor_up()`.
---@field ctrl_j fun()|false Deprecated, function to map <C-J> in the registers window. Default is `registers.move_cursor_down()`.
---@field ctrl_k fun()|false Deprecated, function to map <C-K> in the registers window. Default is `registers.move_cursor_up()`.
---@field delete fun()|false Deprecated, function to map <DEL> in the registers window. Default is `registers.clear_highlighted_register()`.
---@field backspace fun()|false Deprecated, function to map <BS> in the registers window. Default is `registers.clear_highlighted_register()`.

---`require("registers").setup({ events = {...} })`
---@class events_options
---@field on_register_highlighted fun()|false Function that's called when a new register is highlighted when the window is open. Default is `registers.preview_highlighted_register({ if_mode = { "insert", "paste" } })`.

---@alias window_border
---| '"none"'
---| '"single"'
---| '"double"'
---| '"rounded"'
---| '"solid"'
---| '"shadow"'
---| 'string[]' # An array of eight strings which each corner and side character.

---`require("registers").setup({ window = {...} })`
---@class window_options
---@field max_width? number Maximum width of the window, normal size will be calculated based on the size of the longest register. Default is `100`.
---@field highlight_cursorline? boolean Whether to create key mappings for the register values inside the window. Default is `true`.
---@field border? window_border Border style of the window. Default is `"none"`.
---@field transparency? integer Transparency of the window, value can be between 0-100, 0 disables it. Default is `10`.

---`require("registers").setup({ symbols = {...} })`
---@class symbols_options
---@field newline? string Symbol to show for a line break character, can not be the `"\\n"` symbol, use `"\\\\n"` (two backslashes) instead. Default is `"⏎"`.
---@field space? string Symbol to show for a space character. Default is `" "`.
---@field tab? string Symbol to show for a tab character. Default is `"·"`.
---@field register_type_charwise? string Symbol to show next to the sign to signify that the register will be applied in a character by character way. Default is `"ᶜ"`.
---@field register_type_linewise? string Symbol to show next to the sign to signify that the register will be applied in a line by line way. Default is `"ˡ"`.
---@field register_type_blockwise? string Symbol to show next to the sign to signify that the register will be applied as a horizontal block, ignoring line endings. Default is `"ᵇ"`.

---`require("registers").setup({ sign_highlights = {...} })`
---@class sign_highlights_options
---@field cursorline? string Highlight group for when the cursor is over the line. Default is `"Visual"`.
---@field selection? string Highlight group for the selection registers, `*+`. Default is `"Constant"`.
---@field default? string Highlight group for the default register, `"`. Default is `"Function"`.
---@field unnamed? string Highlight group for the unnamed register, `\\`. Default is `"Statement"`.
---@field read_only? string Highlight group for the read only registers, `:.%`. Default is `"Type"`.
---@field alternate_buffer? string Highlight group for the alternate buffer register, `#`. Default is `"Type"`.
---@field expression? string Highlight group for the expression register, `=`. Default is `"Exception"`.
---@field black_hole? string Highlight group for the black hole register, `_`. Default is `"Error"`.
---@field last_search? string Highlight group for the last search register, `/`. Default is `"Operator"`.
---@field delete? string Highlight group for the delete register, `-`. Default is `"Special"`.
---@field yank? string Highlight group for the yank register, `0`. Default is `"Delimiter"`.
---@field history? string Highlight group for the history registers, `1-9`. Default is `"Number"`.
---@field named? string Highlight group for the named registers, `a-z`. Default is `"Todo"`.

---Let the user configure this plugin.
---
---This will also register the default user commands and key bindings.
---@param options? options Plugin configuration options.
---@usage `require("registers").setup({})`
function registers.setup(options)
  local opts = config.setup(options)

  -- Create the user command to manually open the window with :Registers
  if opts.register_user_command then
    vim.api.nvim_create_user_command("Registers", ui.show_window({ mode = "paste" }), {})
  end

  -- Create a namespace for the highlights and signs
  state._namespace = vim.api.nvim_create_namespace("registers")
  mappings.setup()

  log:info("registers.nvim setup complete")
end

return registers
