# Deprecated API migration (v0.13.0 - v0.14.0)

Record of the cleanup after the nvim build jumped from v0.13.0-dev-167 to v0.13.0-dev-1915.
`tests/unit/deprecated_api_spec.lua` fails if any of these patterns come back. Counts were
measured on 2026-10-19 and exclude the vendored `lua/plenary/`.

| Deprecated                                          | Replacement                                         | Hits | Files |
| --------------------------------------------------- | --------------------------------------------------- | ---- | ----- |
| `vim.loop`                                          | `vim.uv`                                            | 127  | 77    |
| `nvim_buf_get_option` / `nvim_buf_set_option`       | `nvim_get_option_value` / `nvim_set_option_value`   | 86   | 42    |
| `nvim_win_get_option` / `nvim_win_set_option`       | `nvim_get_option_value` / `nvim_set_option_value`   | 22   | 13    |
| `nvim_get_option` / `nvim_set_option`               | `nvim_get_option_value` / `nvim_set_option_value`   | 9    | 8     |
| `nvim_err_writeln`                                  | `nvim_echo({...}, true, { err = true })`            | 28   | 14    |
| `nvim_buf_add_highlight`                            | `vim.hl.range` / `nvim_buf_set_extmark`             | 27   | 16    |
| `vim.tbl_flatten`                                   | `vim.iter(t):flatten():totable()`                   | 16   | 13    |
| `vim.lsp.get_active_clients`                        | `vim.lsp.get_clients`                               | 14   | 12    |
| `vim.lsp.buf_get_clients`                           | `vim.lsp.get_clients({ bufnr = ... })`              | 10   | 9     |
| `nvim_get_hl_by_name`                               | `nvim_get_hl(0, { name = ... })`                    | 12   | 5     |
| `vim.diagnostic.goto_next` / `goto_prev`            | `vim.diagnostic.jump({ count = +-1 })`              | 12   | 5     |
| `vim.diagnostic.disable` / `is_disabled`            | `vim.diagnostic.enable(false)` / `is_enabled()`     | 11   | 7     |
| `vim.lsp.buf.formatting`                            | `vim.lsp.buf.format`                                | 11   | 8     |
| `vim.highlight.*`                                   | `vim.hl.*`                                          | 10   | 9     |
| `vim.validate({ ... })` table form                  | `vim.validate(name, value, validator)`              | 15   | 8     |
| `client.supports_method(...)` (dot call)            | `client:supports_method(...)`                       | 7    | 5     |
| `vim.lsp.util.make_position_params()` (no encoding) | pass `win, client.offset_encoding`                  | 5    | 5     |
| `vim.tbl_islist`                                    | `vim.islist`                                        | 6    | 1     |
| `vim.str_utfindex` (old signature)                  | `vim.str_utfindex(s, encoding, index)`              | 6    | 4     |
| `nvim_exec`                                         | `nvim_exec2`                                        | 4    | 4     |
| `vim.lsp.start_client`                              | `vim.lsp.start`                                     | 3    | 3     |
| `vim.lsp.util.jump_to_location`                     | `vim.lsp.util.show_document`                        | 2    | 2     |
| `vim.region`                                        | `vim.fn.getregionpos`                               | 1    | 1     |
| `nvim-treesitter.ts_utils`, `query.get_node_text`   | `vim.treesitter.get_node_text`, `vim.treesitter.*`  | 20   | 9     |

Also done: `nvim_get_commands()` consumers read `desc` for Lua-callback commands (empty
`definition`), and `vim.fn.has("nvim-0.x")` guards for older versions were dropped.

## Not cleaned up

- Deprecations inside third-party plugins in `lazy/`: copilot-cmp, hydra, git-conflict, bigfile, colortils,
  telescope-import, alpha, rest.nvim and a few telescope extensions. Fixing these means upstream issues or PRs.
- `~/git/telescope.nvim`: left its 180 `vim.F.if_nil` calls alone. Its CI tests stable and v0.10.4, but
  `vim.nonnil` needs 0.13, and the edit would conflict with upstream merges. They only warn until 0.15.
- `~/git/nvim-hlslens` and `~/git/what-key.nvim`: their remaining hits are in files with uncommitted work.
