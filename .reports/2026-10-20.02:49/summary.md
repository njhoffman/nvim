# Nvim Config Report - 2026-10-20 02:49 (v0.14.0)

## Deprecated Neovim APIs (TODO item 1)

| Scope                          | Start (v0.12.1) | v0.13.0 | v0.14.0 |
|--------------------------------|-----------------|---------|---------|
| Config repo (guard spec hits)  | 375             | 86      | 0       |
| Calls to removed APIs          | 35              | 0       | 0       |
| Runtime warnings from config   | 8               | 0       | 0       |
| Runtime warnings, all plugins  | 19              | 19      | 18 (third-party + telescope fork) |

## Counts

| Metric                   | Current   | Previous (v0.13.0) | Delta |
|--------------------------|-----------|--------------------|-------|
| Config files             | 2,035     | 2,032              | +3    |
| Config code lines        | 215,215   | 215,195            | +20   |
| Lua files                | 1,760     | 1,757              | +3    |
| Lua code lines           | 184,399   | 184,416            | -17   |
| Unit test files          | 31        | 29                 | +2    |
| Test cases (unit/integ.) | 367/17    | 359/17             | +8    |
| Tests passing            | 384/384   | 376/376            | +8    |
| Line coverage (lua/)     | 50.33%    | 50.28%             | +0.05 |

## Verification

- Parse check of all changed files: 0 errors
- Headless smoke, all plugins loaded: 0 errors. It caught one regression from the `project_nvim` LspAttach change (`on_buf_enter` called without an event), which was fixed before release.
- Guard spec verified to fail on a planted `vim.loop` / `nvim_buf_set_option` file
