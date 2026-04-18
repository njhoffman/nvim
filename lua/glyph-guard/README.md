# glyph-guard

A Neovim Lua module that detects ambiguous Unicode glyphs — Nerd Font icons,
Powerline separators, and other characters in the Private Use Area — and
rewrites them into explicit, portable escape sequences.

## Why this exists

Nerd Fonts, Powerline, and similar icon sets assign glyphs to codepoints in the
Unicode Private Use Area (`U+E000`–`U+F8FF`). Two problems follow from that:

- **The byte is invisible without the exact font.** A config that works on one
  machine renders as a box or question mark on another. Copying lines across
  terminals, SSH sessions, or pull request diffs silently strips meaning.
- **The byte is unsearchable and unreviewable.** Reviewers can't tell
  `` (U+E0B0) from `` (U+E0BC). Linters can't flag them. `grep` needs
  binary-safe mode. `diff` looks identical.

The explicit form `\u{E0B0}` (Lua) or `$'\uE0B0'` (shell) fixes all of this:
bytes are ASCII, intent is reviewable, the file renders the same everywhere,
and the original glyph is recovered at runtime by the language's own escape
handling.

`glyph-guard` is the tool that finds those glyphs in your config files and
rewrites them — idempotently, filetype-aware, with an inline comment recording
the codepoint.

## What it does

- **Detects** PUA (or optionally all non-ASCII) codepoints inside string
  literals, using treesitter to avoid false positives in comments and code.
- **Highlights** each finding in the buffer via extmarks.
- **Escapes** glyphs to the language's native escape form:
  - Lua: `\u{XXXX}` inline.
  - bash/sh/zsh: `$'\uXXXX'` (or `$'\UXXXXXXXX'` for supplementary planes),
    wrapped in the string's quote character so the result stays syntactically
    valid: `"ab\u{E0B0}cd"` → `"ab"$'\uE0B0'"cd"`.
- **Annotates** each affected line with a trailing comment like
  `-- U+E0B0 ` so the glyph is recoverable at a glance without a font.
- **Scans repos** recursively with glob-based ignore patterns
  (`.git`, `node_modules`, `**/dist/**`, …).
- **Previews** changes without mutating the buffer.
- **Operates on visual ranges** — escape just the selection.
- **Fixes multiple files** from the quickfix list in one command.

## Commands

| Command | Description |
| --- | --- |
| `:GlyphCheck` | Scan the current buffer, highlight findings, populate quickfix. |
| `:GlyphCheck <file\|dir>` | Scan a specific file or directory recursively. |
| `:GlyphEscape` | Replace all glyphs in the current buffer with their escape form; add comment annotations. |
| `:'<,'>GlyphEscape` | Same, but only the selected range. |
| `:GlyphPreview` | Show the escaped form as virtual text; buffer is not modified. |
| `:GlyphPreview!` | Clear the preview virtual text. |
| `:GlyphEscapeQF` | Apply fixes to every file currently in the quickfix list. |

Running `:GlyphEscape` twice on the same buffer is a no-op. The tool is
designed to produce a byte-stable output.

## Usage

1. Open a config file with Nerd Font glyphs:
   ```lua
   local x = ""   -- sep_right, Powerline
   ```
2. Run `:GlyphCheck` — the glyph highlights, quickfix opens.
3. Run `:GlyphEscape`:
   ```lua
   local x = "\u{E0B0}" -- U+E0B0 
   ```
4. The file now renders identically regardless of font, diffs cleanly, and
   the comment preserves the original character for humans.

For a repo-wide sweep:

```
:GlyphCheck .
:GlyphEscapeQF
```

## Configuration

Defaults are loaded by `lua/configs/glyph-guard.lua`. Override by calling
`setup()` directly with the keys you want to change:

```lua
require("glyph-guard").setup({
  registry_path = vim.fn.stdpath("config") .. "/glyphs.json",

  detect = {
    pua = true,        -- Nerd Font / Powerline range U+E000-U+F8FF
    non_ascii = false, -- set true to flag every non-ASCII codepoint
  },

  filetypes = { "lua", "sh", "bash", "zsh" },
  extensions = { ".lua", ".sh", ".zsh", ".bash" },

  scan = {
    ignore = { ".git", "node_modules", "dist", "**/build/**" },
  },

  ui = {
    highlight = "WarningMsg",
    auto_open_qf = "on_results", -- "always" | "never" | "on_results"
  },

  write = {
    behavior = "notify", -- "silent" | "notify" | "confirm"
  },

  progress = {
    enabled = true,
  },
})
```

### Glyph registry

`glyphs.json` maps codepoints to human-readable names that appear in the
quickfix listing:

```json
{
  "sep_right": { "codepoint": "U+E0B0" },
  "branch":    { "codepoint": "U+E0A0" },
  "check":     { "codepoint": "U+2713" }
}
```

Names are cosmetic; they do not affect detection or escaping.

## Architecture

```
glyph-guard/
  init.lua        -- setup() + defaults
  registry.lua    -- loads glyphs.json
  scanner.lua     -- UTF-8 iterator, buffer/file/directory scans
  treesitter.lua  -- collects string-node ranges per filetype
  fixer.lua       -- in-buffer replacement + comment annotation
  escape.lua      -- filetype-aware escape formatting
  ignore.lua      -- glob-based ignore matcher
  ui.lua          -- extmark highlighting
  commands.lua    -- user command wiring
```

Key design choices:

- **Treesitter-gated detection.** Only codepoints inside string nodes are
  flagged, eliminating the common failure mode where a glyph in a comment
  annotation gets re-detected on subsequent runs.
- **Byte-accurate UTF-8 iterator.** Hand-written, Lua 5.1 compatible, validates
  leading and continuation bytes; malformed sequences are skipped without
  producing bogus codepoints.
- **Right-to-left replacement.** Glyphs on the same line are replaced from
  highest column to lowest, so earlier byte positions remain valid.
- **Per-filetype escape module.** Escaping is the only part that cares about
  the target language; everything else is format-agnostic.

## Design constraints

- Lua 5.1 compatible (runs under LuaJIT and PUC-Rio 5.1).
- No external runtime dependencies; optional treesitter parsers are a soft
  dependency — without them, the scanner falls back to raw-line mode.
- Output is deterministic: running `:GlyphEscape` twice produces an identical
  byte sequence.
- Heuristic fallbacks are opt-in: the shell fallback (`\u{XXXX}` inside a sh
  file when treesitter can't identify the string) emits a
  `| WARN non-portable escape` marker so the ambiguity is visible.

## Testing

Specs live in `tests/unit/glyph_guard_*_spec.lua` (plenary-based). Run just the
module's tests with:

```
nvim --headless --noplugin -u tests/minimal_init.lua \
  -c "PlenaryBustedFile tests/unit/glyph_guard_scanner_spec.lua"
```

Or the whole unit suite via `scripts/run_tests.sh unit`.

## Limitations

- Comment parsing uses literal prefix matching (`--` / `#`); a `#` inside a
  shell string that also contains a glyph at the tail can confuse comment
  reconstruction. Treesitter gating makes this rare in practice.
- Scanning is synchronous; large repos block the UI for the duration of the
  scan.
- The shell escape form wraps the `$'\u...'` sequence in the surrounding
  quote character, which is portable but visually noisy for strings containing
  many glyphs.
