
  Performance Comparison: tint.nvim vs vimade

  Architecture at a Glance

  ┌──────────────────────┬─────────────────────────────────────┬───────────────────────────────────────────────────────────────┐
  │        Aspect        │              tint.nvim              │                            vimade                             │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Mechanism            │ nvim_win_set_hl_ns()                │ nvim_win_set_hl_ns()                                          │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Same underlying API  │ Yes                                 │ Yes                                                           │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Namespaces           │ 2 global (tinted + default)         │ Pool of ~50 with LRU reuse                                    │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Highlight generation │ Once at setup + ColorScheme         │ Per-tick, cached by key                                       │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Tint/untint hot path │ 1 API call (namespace swap)         │ Full tick cycle: state refresh, style eval, namespace resolve │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Update trigger       │ Event-driven (WinEnter/WinLeave)    │ Timer polling (500ms interval)                                │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Color math           │ String-based hex (%06x round-trips) │ Bitwise integer ops (no string conversion)                    │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Per-window variation │ No (all windows get same tint)      │ Yes (fadelevel function per window)                           │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Focus mode           │ No                                  │ Yes (floating windows)                                        │
  ├──────────────────────┼─────────────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Animation            │ No                                  │ Yes (easing, duration, delay)                                 │
  └──────────────────────┴─────────────────────────────────────┴───────────────────────────────────────────────────────────────┘

  Hot Path Cost Breakdown

  tint.nvim tint(winid) -- init.lua:613-626:

  1. check __.user_config exists        -- table lookup
  2. check winid valid                   -- 1 API call
  3. check vim.w[winid].tint_hl_ns_id   -- 1 API call (window var read)
  4. nvim_win_set_var(...)               -- 1 API call (window var write)
  5. nvim_win_set_hl_ns(winid, ns)       -- 1 API call
  Total: 3-4 API calls, O(1) time, zero color computation

  vimade tick cycle -- fader.lua:update():

  1. GLOBALS.refresh()                   -- read global state, detect changes
  2. FOCUS.update()                      -- evaluate focus regions (if active)
  3. WIN_STATE.refresh()                 -- iterate all windows, read buf_opts/win_opts/win_config per window
  4. For each window:
     a. Compute hi_key from style chain  -- evaluate all style functions
     b. Look up namespace by key         -- table lookup (cache hit) or:
     c. Clone all highlights into ns     -- nvim_get_hl(0, {}) + N * nvim_set_hl()
     d. Apply fade/tint/invert styles    -- color interpolation per highlight
     e. Set corruption sentinel          -- 1 nvim_set_hl
     f. nvim_win_set_hl_ns(winid, ns)    -- 1 API call
  5. Cleanup deleted windows             -- iterate old state
  Total: On cache hit: ~5-10 API calls per window
         On cache miss: ~200+ API calls (all highlights regenerated)

  Startup / ColorScheme Cost

  tint.nvim setup_global_namespaces() -- init.lua:205-218:

  1. nvim_get_hl(0, {})                  -- 1 API call, returns all ~200+ groups
  2. For each group:
     a. ensure_valid_hl_keys()           -- table copy (21 fields)
     b. nvim_set_hl(default_ns, ...)     -- 1 API call (untinted copy)
     c. Transform fg/sp/bg:
        - colors.get_hex(val)            -- string.format("%06x", val)
        - colors.hex_to_rgb(hex)         -- tonumber(hex, 16) + 3 math.floor
        - saturate transform             -- 3 multiplications + 3 math.floor
        - tint transform                 -- 3 additions
        - colors.rgb_to_hex(r,g,b)       -- 3 clamp + string.format
     d. nvim_set_hl(tint_ns, ...)        -- 1 API call (tinted)
  Total: ~400 nvim_set_hl calls + ~200 string conversions

  vimade -- equivalent work happens on cache miss in highlighters/namespace.lua:set_highlights():
  Same ~200 nvim_set_hl calls, but:

- Uses bitwise integer interpolation (no string conversion)
- Resolves highlight links (walks chain)
- Checks blocklist patterns per group
- Sets corruption sentinel highlight

  Color Transform Performance

  tint.nvim -- per highlight group, per transform:
  -- hex round-trip: number -> hex string -> parse -> transform -> format -> hex string
  colors.get_hex(val)        -- string.format("%06x", val)           ~0.5us
  colors.hex_to_rgb(hex)     -- tonumber(hex, 16) + 3 divisions     ~0.3us
  saturate(r, g, b)          -- 3 multiply + 3 floor                 ~0.1us
  tint(r, g, b)              -- 3 additions                          ~0.05us
  colors.rgb_to_hex(r, g, b) -- 3 clamp + string.format             ~0.5us
                                                           Total: ~1.5us/group

  vimade -- per highlight group:
  -- pure integer math, no string conversion
  INTERPOLATE_24B(source, target, fade)  -- 6 bitwise ops + 3 floor  ~0.2us
  -- applied to fg, bg, sp independently                   Total: ~0.6us/group

  Vimade's color math is roughly 2-3x faster per group because it stays in integer space with bitwise operations. tint.nvim pays for string.format and tonumber round-trips
  on every color. However, this only matters during setup/ColorScheme -- tint.nvim never recomputes at runtime.

  Runtime Steady-State Performance

  This is where the architectures diverge most:

  tint.nvim: After setup, runtime cost is effectively zero per redraw. tint()/untint() is a single namespace swap. Focus changes are event-driven (WinEnter/WinLeave) with
  no polling.

  vimade: Runs a full tick cycle every 500ms regardless of whether anything changed. Even on cache hits, each tick:

- Calls nvim_win_get_config() for every window
- Calls nvim_win_get_buf() for every window
- Evaluates all style functions
- Computes cache keys
- Checks for namespace corruption

  What tint.nvim Cannot Do

  1. No per-window variation -- Every tinted window gets the same 2 shared namespaces. You can't have cmdline at 0.2 and splits at 0.6.
  2. No dynamic fadelevel -- The tint amount is fixed at setup. Changing it requires full namespace regeneration.
  3. No buffer-aware state -- No concept of per-buffer fade levels.
  4. No animation -- Binary tinted/untinted.
  5. No per-range anything -- Same as vimade, whole-window only.
  6. No tmux focus integration -- Only tracks Neovim WinEnter/WinLeave (though you could add FocusGained/FocusLost events).

  What tint.nvim Does Better

  1. Event-driven, not polling -- Zero CPU cost between focus changes.
  2. O(1) tint/untint -- Single API call, no computation.
  3. Simpler mental model -- ~300 lines vs ~2000 lines, easier to extend.
  4. Lower memory -- 2 namespaces vs 50+ namespace pool.

  Relevance to Your Requirements

  ┌───────────────────────────────┬───────────────────────┬────────────────────┬──────────────────────────────────┐
  │          Requirement          │    tint.nvim alone    │    vimade alone    │        tint.nvim extended        │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Scenario-specific fade levels │ No                    │ Yes (fadelevel fn) │ Would need per-window namespaces │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Plugin API (fadetint)         │ Partial (tint/untint) │ Via wrapper        │ Easy to add                      │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Buffer variable state         │ No                    │ Via wrapper        │ Easy to add                      │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Relative fade values          │ No                    │ Via wrapper        │ Possible                         │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Per-range restore             │ No                    │ No                 │ No                               │
  ├───────────────────────────────┼───────────────────────┼────────────────────┼──────────────────────────────────┤
  │ Per-range transforms          │ No                    │ No                 │ No                               │
  └───────────────────────────────┴───────────────────────┴────────────────────┴──────────────────────────────────┘

  The per-window variation requirement is the key differentiator. tint.nvim's 2-namespace design fundamentally can't give different fade levels to different windows without
   creating per-window namespace pairs (which it already has scaffolding for -- see setup_local_namespaces at line 222, currently unused). If you added that, you'd
  essentially be rebuilding what vimade already does, but with event-driven updates instead of polling.

  Bottom Line

  For your use case, the hybrid approach from the plan is still the right call. tint.nvim's architecture is faster at steady-state but can't support per-window fade
  variation without significant extension. vimade's polling overhead is the main cost (~500ms timer), but the actual namespace work is well-cached. The per-range features
  need a decoration provider regardless of which window-level system you use.

  If the 500ms polling bothers you, the most impactful change would be lowering vimade's checkinterval and adding event-driven triggers in the fade_controller (which we
  already did --_trigger_update() calls vimade.update() immediately on API-driven changes).
