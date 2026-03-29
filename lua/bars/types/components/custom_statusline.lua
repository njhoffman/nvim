---@meta

--- Custom statusline component types.
--- Extends bars.nvim's built-in component types with
--- additional components for a full-featured statusline.

-----------------------------------------------------------------------------

--- Shows project name from project_nvim.
---
---```txt
--- abc----de
--- │││    │└ corner_right
--- │││    └ padding_right
--- ││└ icon
--- │└ padding_left
--- └ corner_left
---```
---@class bars.statusline.project
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field corner_left? string
---@field corner_left_hl? string
---@field padding_left? string
---@field padding_left_hl? string
---@field icon? string
---@field icon_hl? string
---@field padding_right? string
---@field padding_right_hl? string
---@field corner_right? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Shows human-readable file size.
---@class bars.statusline.file_size
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Icon shown before the size.
---@field icon? string
---@field icon_hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows cursor position as line:col.
---@class bars.statusline.cursor_position
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Separator between line and column.
---@field separator? string
---
---@field icon? string
---@field icon_hl? string
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows character code under cursor in hex.
---@class bars.statusline.ascii
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows total line count or visual selection info.
---@class bars.statusline.line_count
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Highlight group for normal mode.
---@field hl? string
---
--- Highlight group for visual mode.
---@field visual_hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows line position as percentage, Top, Bot, or All.
---@class bars.statusline.line_percentage
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows scroll position as block characters.
---@class bars.statusline.scroll_bar
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Block characters used for the bar (8 entries, low to high).
---@field chars? string[]

-----------------------------------------------------------------------------

--- Shows file encoding (only when non-UTF-8).
---@class bars.statusline.encoding
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Only show when encoding differs from this value.
---@field hide_when? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows file format (unix/dos/mac).
---@class bars.statusline.fileformat
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows lowercase filetype name.
---@class bars.statusline.filetype
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows search count as [current/total].
---@class bars.statusline.search_count
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows visual selection count.
---@class bars.statusline.selection_count
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows neocodeium + notify + noice stats.
---@class bars.statusline.misc_stats
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Throttle delay in milliseconds.
---@field throttle? integer
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows noice cmdline mode with vi_mode color.
---@class bars.statusline.noice_mode
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows git diff counts (added/changed/removed).
---@class bars.statusline.git_diff
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Which diff type: "added", "changed", or "removed".
---@field diff_type "added" | "changed" | "removed"
---
--- Icon shown before the count.
---@field icon? string
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows attached LSP client names.
---@class bars.statusline.lsp_clients
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Icon shown before client names.
---@field icon? string
---@field icon_hl? string
---
--- Name overrides for specific LSP clients.
---@field name_map? table<string, { icon?: string, name?: string, hl?: string }>
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows hostname.
---@class bars.statusline.hostname
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows date and/or time.
---@class bars.statusline.datetime
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Format string for os.date().
---@field format? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows spell check status.
---@class bars.statusline.spell
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Icon to show when spell is enabled.
---@field icon? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows current working directory.
---@class bars.statusline.workdir
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Maximum display length before truncation.
---@field max_len? integer
---
---@field icon? string
---@field icon_hl? string
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows DAP (debug) session status.
---@class bars.statusline.dap
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
--- Icon shown when debugging.
---@field icon? string
---
---@field padding_left? string
---@field padding_right? string

-----------------------------------------------------------------------------

--- Shows tab page count.
---@class bars.statusline.tabs
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Primary highlight group.
---@field hl? string
---
---@field icon? string
---@field padding_left? string
---@field padding_right? string
