     Phase 1: Fade Controller (lua/configs/vimade/fade_controller.lua)

     Thin state layer wrapping vimade's fadelevel system.

     State: Table keyed by bufnr: { level = 0.45, source = "split" }
     - Every mutation syncs to vim.b[bufnr].fadelevel and vim.b[bufnr].fade_source
     - Reads current level from buffer var on init (survives module reload)

     Relative values: parse_level(value, current) function
     - Accepts number (0.5), string ("+0.2", "-0.1"), or nil (no change)
     - Clamps result to [0, 1.0]

     Public API:
     - M.fade(bufnr, level, source) -- set fade, sync to buffer var, force vimade update
     - M.unfade(bufnr) -- restore to 1.0
     - M.get(bufnr) -- return current {level, source}
     - M.fadetint(bufnr, level) -- exposed for plugin integration (requirement 2)

     Scenario fadelevel function: M.make_fadelevel(cfg) returns a function compatible with vimade's fadelevel option
     - Checks fade_controller.get(bufnr) first (for API-set levels)
     - Falls through to scenario detection (reuses existing logic from utils.lua:95-111)
     - Scenarios: command buffer (0.2), split (0.6), popup, whichkey, etc.

     Phase 2: Wire into vimade config

     init.lua changes:
     - Line 39: Replace fadelevel = 0.45 with fadelevel = fade_controller.make_fadelevel(fadelevel_cfg)
     - The fadelevel_cfg table at lines 27-34 already has the right shape

     utils.lua changes:
     - Refactor M.fadelevel to delegate to fade_controller
     - Remove the standalone get_active_info (move to fade_controller if needed)

     Autocommands (in init.lua or fade_controller):
     - CmdlineEnter / CmdlineLeave -- trigger fade level change for command buffer scenario
     - Integration hook for whichkey: listen to whichkey's open/close events and call fadetint

     Phase 3: Per-Range Module (lua/configs/vimade/range_hl.lua)

     Uses nvim_set_decoration_provider (like snacks.dim, NOT floating windows like vimade focus).

     Decoration provider on_win callback:
     - Checks internal range table for active ranges in the current buffer
     - Sets ephemeral extmarks (ephemeral = true) with appropriate highlight groups
     - Ephemeral extmarks override vimade's window namespace for specific character ranges

     Restore mode (visual select use case):
     - M.restore_range(bufnr, start_pos, end_pos) -- marks a range for original-color restoration
     - M.clear_restore(bufnr) -- removes restore ranges
     - In on_win: for each restore range, set ephemeral extmarks that reference the original (unfaded) highlight groups
     - Visual mode integration: detect vim.fn.mode() in on_win, auto-restore visual selection range

     How restore works technically:
     - The original highlights live in namespace 0 (global)
     - Vimade's faded highlights are in a vimade namespace applied via nvim_win_set_hl_ns
     - Ephemeral extmarks with explicit hl_group override the window namespace for those ranges
     - Source highlight data comes from treesitter queries + existing extmarks (reuse tmp7.lua's ts_range_highlights and buffer_range_highlights)

     Phase 4: Color Transform Module (lua/configs/vimade/color_math.lua)

     Imports from vimade: require("vimade.util.color") for to24b, toRgb, interpolate24b

     New transforms:
     - M.lighten(rgb, amount) -- blend toward white
     - M.darken(rgb, amount) -- blend toward black
     - M.saturate(rgb, amount) -- increase/decrease saturation via HSL
     - M.hue_shift(rgb, degrees) -- rotate hue in HSL space
     - M.rgb_to_hsl(r, g, b) / M.hsl_to_rgb(h, s, l) -- conversion utilities

     Derived highlight cache:
     - Key: original_group:transform:amount -> created highlight group name
     - Cleared on ColorScheme autocmd
     - Used by range_hl.lua to create transformed highlight groups on demand

     Range transform API:
     - range_hl.transform_range(bufnr, start, end, {lighten=0.2}) -- apply transform to range
     - range_hl.transform_range(bufnr, start, end, {darken=0.3, saturate=-0.2}) -- composable

     Phase 5: Benchmarks (lua/configs/vimade/bench.lua)

     Scenarios measured with vim.uv.hrtime(), 100 iterations each:

     1. Vimade tick cost: Full require("vimade").update() cycle
     2. Custom namespace approach: Clone all hls from ns 0, apply fade, set on window
     3. Decoration provider cost: Ephemeral extmarks across 5 restore ranges
     4. Combined: Vimade tick + decoration provider together
     5. tint.nvim setup cost: Full setup_global_namespaces() -- regenerate both tint namespaces from scratch (the expensive one-time cost)
     6. tint.nvim hot path: tint()/untint() cycle on a window (O(1) namespace swap)
     7. tint.nvim color math vs vimade color math: Transform a single color through each pipeline to compare string-based hex round-trips (tint.nvim) vs bitwise integer ops (vimade)

     Also track namespace stats (total count, highlights per ns, tint-specific ns counts).

     Changes to bench.lua

     Add three new benchmark functions after the existing four:

     bench_tint_setup(): Measures the cost of regenerating tint.nvim's two global namespaces. This is tint.nvim's most expensive operation -- it runs once at startup and on ColorScheme change.
     The benchmark:
     - Calls tint.refresh() which re-runs setup_global_namespaces() (iterates all ~200+ hl groups, transforms each color through the saturate+tint pipeline, calls nvim_set_hl twice per group)
     - If tint.nvim isn't loaded, falls back to simulating the same work: nvim_get_hl(0, {}) then for each group, hex conversion + saturate + tint + nvim_set_hl into two test namespaces
     - Reports: timing, highlight count, namespace count

     bench_tint_hot_path(): Measures the tint/untint cycle -- the operation that happens on every WinEnter/WinLeave:
     - Calls tint.tint(winid) then tint.untint(winid) (each is a single nvim_win_set_hl_ns call with a window var guard)
     - If tint.nvim isn't loaded, simulates with raw nvim_win_set_hl_ns + nvim_win_set_var calls
     - Reports: timing (should be sub-microsecond on cache hit)

     bench_color_math(): Head-to-head comparison of the color transform pipelines:
     - tint.nvim path: colors.get_hex(val) -> colors.hex_to_rgb(hex) -> saturate(r,g,b) -> tint(r,g,b) -> colors.rgb_to_hex(r,g,b) (string-based, ~1.5us/color)
     - vimade path: color.interpolate24b(source, target, fade) (bitwise integer, ~0.2us/color)
     - Runs both over 1000 colors, reports mean per-color time

     Add "tint_setup", "tint_hot", "color_math" to the run_single map.

     Register all 7 benchmarks in M.run() so the full suite output includes tint.nvim rows.

     ---
     Files to Create

     - lua/configs/vimade/fade_controller.lua -- state, API, scenario fadelevel
     - lua/configs/vimade/range_hl.lua -- decoration provider, restore/transform ranges
     - lua/configs/vimade/color_math.lua -- HSL transforms, derived highlight cache
     - lua/configs/vimade/bench.lua -- benchmark suite

     Files to Modify

     - lua/configs/vimade/init.lua -- wire fade_controller, add autocommands
     - lua/configs/vimade/utils.lua -- delegate fadelevel to fade_controller

     Key Dependencies

     - vimade.util.color -- color math (import, don't copy)
     - nvim_set_decoration_provider -- per-range highlighting
     - nvim_win_set_hl_ns -- managed by vimade (don't touch)

     Verification

     1. Open 3-4 splits, confirm different fade levels per scenario
     2. Enter command mode, verify source buffer fades to 0.2
     3. Call fadetint(bufnr, "+0.1") from cmdline, verify relative adjustment + buffer var
     4. Visual select a range in a faded buffer, confirm selection shows original colors
     5. Run :lua require("configs.vimade.bench").run() and review timing output
     6. Check vim.b.fadelevel on various buffers to confirm state persistence

     Open Questions for Discussion

     1. Whichkey integration: Should this listen to whichkey's WhichKeyOpened/WhichKeyClosed events, or should the fadetint call be placed in the whichkey config directly?
     2. Visual mode restore: Should this activate on entering visual mode (instant) or only after a brief delay (to avoid flicker on quick selections)?
     3. Transform highlight caching: How aggressively to cache derived highlights? Per-colorscheme clear is the baseline, but should there be a size limit?
