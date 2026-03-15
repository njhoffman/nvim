# Nvim Config Report - 2026-03-09 19:17

## Code Stats (config)

| Language     | Files | Code    | Comments | Blank  |
|-------------|-------|---------|----------|--------|
| Lua          | 1,947 | 203,150 | 54,019   | 26,856 |
| vim script   | 61    | 3,462   | 1,013    | 670    |
| Text         | 3     | 9,130   | 0        | 518    |
| Markdown     | 8     | 1,760   | 0        | 419    |
| Scheme       | 12    | 212     | 154      | 30     |
| Other        | 10    | 398     | 41       | 65     |
| **Total**    | **2,041** | **218,112** | **55,227** | **28,558** |

## Code Stats (lazy plugins)

| Language     | Files  | Code      |
|-------------|--------|-----------|
| Lua          | 9,382  | 1,089,638 |
| JSON         | 547    | 236,972   |
| Markdown     | 1,222  | 182,434   |
| vim script   | 1,294  | 101,600   |
| Scheme       | 1,619  | 90,436    |
| Other        | 4,611  | 423,558   |
| **Total**    | **18,675** | **2,124,638** |

## Counts

| Metric           | Current | Previous (17:30) | Delta |
|------------------|---------|------------------|-------|
| Config files     | 2,041   | 2,453            | -412  |
| Config code lines| 218,112 | 277,973          | -59,861 |
| Lua files        | 1,947   | 2,078            | -131  |
| Lua code lines   | 203,150 | 218,593          | -15,443 |
| Enabled plugins  | 411     | --               | --    |
| Test files       | 6       | --               | --    |
| Test cases       | 88      | --               | --    |
| Tests passing    | 82/82   | --               | --    |

> Note: Previous report scanned entire config dir (including data/lock files);
> current report scopes to lua/, after/, plugin/, tests/, init.lua, filetype.lua.
> The delta is inflated by this scope change plus cleanup of dead files.

## Changes This Session

### Backed up to ~/.local/backup/nvim-refactor/

- 9 dead root files (tmp*.lua, err.txt, _config.txt, test HTML files, unicode_table.txt)
- fzf-build/ (build artifacts, compiled result still in build/)
- lua/configs/render-markkdown/ (empty typo directory)
- lua/_notify/ (dead plugin source duplicate)
- lua/gitblame/, lua/cmdline/, lua/pretty/ (unreferenced modules)
- lua/rewind/ (dead code, just comments)

### Consolidated

- lua/funcs/quality-of-life.lua -> lua/utils/quality-of-life.lua
  - Updated 19 require references across 4 files

### Fixed

- .editorconfig: added missing `root = true`
