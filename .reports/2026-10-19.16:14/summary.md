# Nvim Config Report - 2026-10-19 16:14 (v0.11.0)

## Code Stats (config)

| Language  | Files     | Code        | Comments   | Blank      |
|-----------|-----------|-------------|------------|------------|
| Lua       | 1,757     | 184,375     | 44,518     | 22,487     |
| **Total** | **2,029** | **210,904** | **47,395** | **28,388** |

## Code Stats (lazy plugins)

| Language  | Files      | Code          |
|-----------|------------|---------------|
| Lua       | 9,414      | 1,105,937     |
| **Total** | **18,299** | **2,404,957** |

## Counts

| Metric                 | Current   | Previous (03-16) | Delta    |
|------------------------|-----------|------------------|----------|
| Config files           | 2,029     | 2,004            | +25      |
| Config code lines      | 210,904   | 204,063          | +6,841   |
| Lua files              | 1,757     | 1,909            | -152     |
| Lua code lines         | 184,375   | 189,068          | -4,693   |
| Installed plugins      | 379       | 378              | +1       |
| Unit test files        | 29        | 11               | +18      |
| Test cases (unit)      | 359       | 132              | +227     |
| Test cases (integration)| 17       | n/a              | n/a      |
| Tests passing          | 376/376   | 132/132          | +244     |
| Line coverage (lua/)   | 50.28%    | not measured     | n/a      |

## Coverage

- First run with working coverage: luacov hooked via `NVIM_COVERAGE` in `tests/minimal_init.lua`,
  reported under nvim's LuaJIT so `goto`-using modules are included.
- 5,756 hit / 5,691 missed lines across files loaded by tests; full table in `coverage.txt`.
- Lowest covered loaded modules: `project_nvim/root.lua` (8.6%), `components/diagnostics.lua` (12.8%),
  `utils/core.lua` (13.9%).

## Notes

- Lua file count dropped because of the notify demo/render removals and the cleanup in `b0207e6d`;
  total config code rose because non-Lua files (markdown, json, scripts) grew.
- Previous counts come from the 2026-03-16 report; v0.7.0 through v0.10.0 were released without reports.
- Run against NVIM v0.13.0-dev-1915+gc5641b2bfb. In this build `nvim_get_commands()` returns an empty
  `definition` for Lua-callback commands, so `quickclose_spec` now asserts on `desc`.
