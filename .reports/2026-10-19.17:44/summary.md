# Nvim Config Report - 2026-10-19 17:44 (v0.12.0)

## Code Stats

| Scope        | Files  | Lua files | Lua code  | Total code |
|--------------|--------|-----------|-----------|------------|
| config       | 2,031  | 1,757     | 184,431   | 215,135    |
| lazy plugins | 18,990 | 9,956     | 1,190,324 | 2,245,271  |

## Counts

| Metric                   | Current   | Previous (v0.11.1) | Delta   |
|--------------------------|-----------|--------------------|---------|
| Config files             | 2,031     | 2,030              | +1      |
| Config code lines        | 215,135   | 215,030            | +105    |
| Lua code lines           | 184,431   | 184,375            | +56     |
| Lazy plugin Lua files    | 9,956     | 9,890              | +66     |
| Lazy plugin code lines   | 2,245,271 | 2,228,209          | +17,062 |
| Plugin dirs installed    | 383       | 379                | +4      |
| Test cases (unit/integ.) | 359/17    | 359/17             | 0       |
| Tests passing            | 376/376   | 376/376            | 0       |
| Line coverage (lua/)     | 50.28%    | 50.28%             | 0       |

## Headless smoke test (scripts/smoke.lua, all 404 plugin specs loaded)

| Check                               | Result                              |
|-------------------------------------|-------------------------------------|
| Errors                              | 0 (was 3: avante, dap-view, E201)   |
| Config deprecation warnings         | 0 (was 8)                           |
| Blocking prompts                    | 0 (was 1: kulala license token)     |
| Upstream plugin deprecations        | 19 (plugin code and ~/git forks)    |
| `:checkhealth rest-nvim` / `avante` | all OK                              |

## Notes

- Plugin dirs +4: mega.cmdparse, mega.logging, rest.nvim, plus a leftover `hererocks` dir from
  the reverted hererocks attempt. The four removed telescope extensions and kulala stay on disk
  until `:Lazy clean`.
