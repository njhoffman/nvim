# Statusline Components

Masterlist of all available statusline components for bars.nvim.
Components are organized as individual modules in `lua/bars/components/`.

## Built-in Components (from bars.nvim)

These are rendered by bars.nvim's component system directly.

### mode

Shows current Vim mode with icon and text.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"mode"` | Component type |
| `compact` | `boolean \| function` | Show compact version (no text) |
| `default` | `mode.opts` | Default config applied to all modes |
| `["^pattern"]` | `mode.opts` | Mode-specific overrides via regex |

Mode opts: `corner_left`, `padding_left`, `icon`, `text`, `padding_right`, `corner_right`, `hl`, and `*_hl` variants.

### bufname

Shows buffer filename with filetype icon.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"bufname"` | Component type |
| `max_len` | `integer` | Maximum name length before truncation |
| `truncate_symbol` | `string` | Character for truncation (default: `...`) |
| `default` | `bufname.opts` | Default config |
| `["^pattern"]` | `bufname.opts` | Pattern-matched overrides |

Bufname opts: `corner_left`, `padding_left`, `icon`, `nomodifiable_icon`, `text`, `padding_right`, `corner_right`, `hl`, `icon_hl` (string or string[]).

### diagnostics

Shows LSP diagnostic counts with severity icons.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"diagnostics"` | Component type |
| `default_mode` | `1-5` | 1=Error, 2=Warn, 3=Info, 4=Hint, 5=All |
| `compact` | `boolean` | Hide zero-count types |
| `auto_hide` | `boolean` | Hide when no LSP clients |
| `error_icon/hl` | `string` | Error icon and highlight |
| `warn_icon/hl` | `string` | Warning icon and highlight |
| `info_icon/hl` | `string` | Info icon and highlight |
| `hint_icon/hl` | `string` | Hint icon and highlight |
| `empty_icon/text/hl` | `string` | Shown when no diagnostics |
| `separator/separator_hl` | `string` | Between diagnostic types |

### branch

Shows current git branch name.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"branch"` | Component type |
| `throttle` | `integer` | Update delay in ms (default: 2000) |
| `default` | `branch.opts` | Default config |
| `["^pattern"]` | `branch.opts` | Branch name pattern overrides |

Branch opts: `corner_left`, `padding_left`, `icon`, `text`, `padding_right`, `corner_right`, `hl`, and `*_hl` variants.

### ruler

Shows cursor position or visual selection size.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"ruler"` | Component type |
| `mode` | `"normal" \| "visual" \| function` | Display mode |
| `default` | `ruler.opts` | Normal mode config |
| `visual` | `ruler.opts` | Visual mode config |

Ruler opts: `corner_left`, `padding_left`, `icon`, `separator`, `padding_right`, `corner_right`, `hl`.

### macro

Shows macro recording/executing status.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"macro"` | Component type |
| `record_icon` | `string` | Icon when recording |
| `record_hl` | `string` | Highlight when recording |
| `exec_icon` | `string` | Icon when executing |
| `exec_hl` | `string` | Highlight when executing |

### progress

Shows animated progress indicator (e.g., LSP loading).

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"progress"` | Component type |
| `check` | `string` | Variable name to monitor (default: `"progress_state"`) |
| `update_delay` | `integer` | Animation frame delay in ms |
| `start/start_hl` | `string` | Start state icon/highlight |
| `progress/progress_hl` | `string[]` | Progress frame icons/highlights |
| `finish/finish_hl` | `string` | Finish state icon/highlight |

### empty

Right-alignment separator (`%=`).

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"empty"` | Component type |
| `hl` | `string` | Background highlight |

### section

Static text section with optional click handler.

| Field | Type | Description |
|-------|------|-------------|
| `kind` | `"section"` | Component type |
| `click` | `string` | Click handler function name |
| `icon/text` | `string` | Content |
| `hl` | `string` | Highlight |

---

## Custom Components (lua/bars/components/)

These are implemented as `kind = "custom"` with value functions.

### project

Shows project name from project_nvim.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Project` | Highlight group |

**Source**: `lua/bars/components/project.lua`
**Depends on**: project_nvim

### file_size

Shows human-readable file size (b, k, M, G, T).

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_FileSize` | Highlight group |

**Source**: `lua/bars/components/file_size.lua`

### cursor_position

Shows cursor position as `line:col`.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Position` | Highlight group |

**Source**: `lua/bars/components/cursor_position.lua`

### ascii

Shows hex character code under cursor.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Ascii` | Highlight group |

**Source**: `lua/bars/components/ascii.lua`

### line_count

Shows total lines (`%L`) or visual selection info (`{lines} {chars}`).

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_LineCount` | Normal mode highlight |
| `visual_hl` | `string` | `BarsSL_LineCountVisual` | Visual mode highlight |

**Source**: `lua/bars/components/line_count.lua`

### line_percentage

Shows scroll position as Top, Bot, All, or percentage.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_LinePct` | Highlight group |

**Source**: `lua/bars/components/line_percentage.lua`

### scroll_bar

Shows scroll position as Unicode block characters.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_ScrollBar` | Highlight group |
| `chars` | `string[]` | `{ "▁" .. "█" }` | 8 block characters |

**Source**: `lua/bars/components/scroll_bar.lua`

### filetype

Shows lowercase filetype name.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |

**Source**: `lua/bars/components/filetype.lua`

### encoding

Shows file encoding (hidden when UTF-8).

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |
| `hide_when` | `string` | `"utf-8"` | Encoding to hide |

**Source**: `lua/bars/components/encoding.lua`

### fileformat

Shows file format with icon (unix/dos/mac).

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |

**Source**: `lua/bars/components/fileformat.lua`

### search_count

Shows search result position as `[current/total]`.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_SearchCount` | Highlight group |

**Source**: `lua/bars/components/search_count.lua`

### selection_count

Shows visual selection character/line/block count.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_ModeVisual` | Highlight group |

**Source**: `lua/bars/components/selection_count.lua`
**Modes**: `v` = `[chars-bytes / lines]`, `V` = `[lines]`, `Ctrl-V` = `[lines x cols]`

### misc_stats

Shows neocodeium status + animate toggle + noice/notify counts.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_MiscStats` | Highlight group |
| `throttle` | `integer` | `100` | Throttle delay in ms |

**Source**: `lua/bars/components/misc_stats.lua`
**Setup**: Call `require("bars.components.misc_stats").setup()` to register autocmds.

### noice_mode

Shows noice cmdline mode status with vi_mode-derived highlight.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| (dynamic) | | | Highlight follows current mode |

**Source**: `lua/bars/components/noice_mode.lua`
**Depends on**: noice.nvim

### git_diff

Shows git diff counts (added/changed/removed).

| Function | Icon | Highlight | Description |
|----------|------|-----------|-------------|
| `.added` | ` ` | `BarsSL_GitDiffAdd` | Added lines |
| `.changed` | ` ` | `BarsSL_GitDiffChange` | Changed lines |
| `.removed` | ` ` | `BarsSL_GitDiffRemove` | Removed lines |

**Source**: `lua/bars/components/git_diff.lua`
**Depends on**: gitsigns.nvim (reads `b:gitsigns_status_dict`)

### lsp_clients

Shows attached LSP client names with icons.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | varies | Highlight group |
| `name_map` | `table` | built-in | Name/icon overrides per client |

**Source**: `lua/bars/components/lsp_clients.lua`

### hostname

Shows system hostname.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |

**Source**: `lua/bars/components/hostname.lua`

### datetime

Shows date and/or time.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |
| `format` | `string` | `"%H:%M"` | Format string for `os.date()` |

**Source**: `lua/bars/components/datetime.lua`
**Factory**: `datetime.with_format(fmt)` returns a custom value function.

### spell

Shows spell check icon when enabled.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_ModeCommand` | Highlight group |
| `icon` | `string` | `"暈 "` | Spell icon |

**Source**: `lua/bars/components/spell.lua`

### workdir

Shows current working directory, truncated.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |
| `max_len` | `integer` | `20` | Max display length |

**Source**: `lua/bars/components/workdir.lua`
**Factory**: `workdir.with_max_len(n)` returns a custom value function.

### dap

Shows DAP debug session status.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_ModeReplace` | Highlight group |
| `icon` | `string` | `" "` | Debug icon |

**Source**: `lua/bars/components/dap.lua`
**Depends on**: nvim-dap

### tabs

Shows tab page count (hidden when only 1 tab).

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hl` | `string` | `BarsSL_Filetype` | Highlight group |
| `icon` | `string` | `" "` | Tab icon |

**Source**: `lua/bars/components/tabs.lua`

---

## Themes

Available via `:StatuslineTheme <name>`.

| Theme | Separators | Description |
|-------|-----------|-------------|
| **slashed** | `` `` | Feline replica with powerline transitions (default) |
| **minimal** | none | Mode + bufname + diagnostics + branch + ruler |
| **stealth** | none | Blends into default StatusLine highlights |
| **bubble** | `` `` | Rounded bubbles with elevated background |
| **rainbow** | none | Distinct hue per component section |
| **pure** | none | Text-only, bold, no icons, monochrome |
