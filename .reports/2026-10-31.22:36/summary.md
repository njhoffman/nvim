# Nvim Config Report - 2026-10-31.22:36 (v0.15.1)

Fixes tmux border detection on tmux next-3.9, which prints `#{window_layout}` as JSON; the
layout parser now reads both the JSON and classic formats.

| Metric                    | Value                         | Delta vs v0.15.0 |
| ------------------------- | ----------------------------- | ---------------- |
| Unit test files           | 32                            | 0                |
| Tests passing             | 394/394 (377 plenary, 17 mini.test) | +6         |
| Line coverage (lua/)      | 50.25%                        | +0.06            |
| Lua code lines (cloc)     | 184,511 in 1,761 files        | +78              |
| Markdown code lines       | 5,084                         | +25              |
| Total code lines          | 215,466 in 2,039 files        | +103             |
| Installed plugins (lazy/) | 377                           | 0                |
