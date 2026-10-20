# Nvim Config Report - 2026-10-19 22:32 (v0.13.0)

## Deprecated API usage (config repo, non-comment lines)

| Category                                  | Before | After |
|-------------------------------------------|--------|-------|
| Calls to removed APIs (runtime errors)    | 35     | 0     |
| Mechanical (uv, options, err_writeln ...) | 300    | 0     |
| Remaining (Phase 3: highlights, goto_*, validate{}, exec, start_client, ...) | 40 | 72 incl. vendored plenary |
| Total scanner hits                        | 375    | 86 -> mostly Phase 3 |

## Counts

| Metric                   | Current   | Previous (v0.12.1) | Delta |
|--------------------------|-----------|--------------------|-------|
| Config files             | 2,032     | 2,032              | 0     |
| Config code lines        | 215,195   | 215,190            | +5    |
| Lua code lines           | 184,416   | 184,431            | -15   |
| Test cases (unit/integ.) | 359/17    | 359/17             | 0     |
| Tests passing            | 376/376   | 376/376            | 0     |
| Line coverage (lua/)     | 50.28%    | 50.28%             | 0     |

## Verification

- `nvim -l` parse check of all 174 changed files: 0 new parse errors (8 files were already broken at HEAD)
- Headless smoke (all plugins loaded): 0 errors, 0 config-level deprecation warnings
- Unit suite run 3x: 29/29 spec files, 359/359 each run
