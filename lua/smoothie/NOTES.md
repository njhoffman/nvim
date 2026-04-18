
### Vim's Two Scroll Categories

#### Category 1: View Scroll (C-e, C-y)

  These move the window viewport without moving the cursor's buffer position. The cursor only moves if it would go off-screen.

- C-e -- scroll viewport down 1 line (content moves up)
- C-y -- scroll viewport up 1 line (content moves down)

  The cursor's line number stays the same unless that would push it outside the visible area. scrolloff directly constrains this: with scrolloff=5, the cursor is forced to move once it's within 5 lines of the window edge.

  These are the primitive scroll operations -- they map directly to changing topline.

#### Category 2: Cursor+Scroll (C-u, C-d, C-f, C-b)

  These move the cursor and the viewport scrolls as a side effect of the cursor moving.

  C-u / C-d (half-page):

- Move the cursor by &scroll lines (default: half window height)
- The viewport scrolls to keep the cursor visible
- The cursor's window-relative position (winline) is preserved -- if the cursor was on screen row 10, it stays on row 10 after scrolling
- scrolloff affects the final resting position of the cursor

  C-f / C-b (full-page):

- Move the viewport by a full window height
- The cursor lands at the top of the new view (C-f) or bottom (C-b), adjusted by scrolloff
- These are more aggressive -- they reposition both view and cursor together
- scrolloff determines how far from the edge the cursor lands after the page flip

  The key behavioral difference: C-e/C-y keep the cursor in place and move the view. C-u/C-d/C-f/C-b keep the cursor's screen position and move everything. With scrolloff=0, C-u/C-d still scroll the view, but C-e/C-y with cursor at the edge won't force the cursor to follow.

  Why This Matters for Smooth Scrolling

  There are two fundamentally different architectural approaches:

  Approach A: Keymap Interception (what smoothie does)

  Intercept the keypress, calculate the destination, then animate toward it using repeated micro-steps. Each step executes normal! 1<C-d> or normal! 1<C-u> (single-line scroll commands).

  The problem: you need per-command logic. C-d needs different handling from C-f from C-b. The early-exit guards differ (the bug we just fixed). The scrolloff interaction differs. Fold handling differs. You're reimplementing Vim's native scroll semantics and every edge case that comes with them.

  The advantage: full control over the animation curve. You can have velocity easing, acceleration, deceleration.

  Approach B: Event-Driven Reaction (what mini.animate does)

  Let Vim execute the scroll command natively and instantly (the view jumps to the final position). Then detect the change via the WinScrolled autocmd, snap back to the original topline, and animate the transition using C-e/C-y micro-steps.

  User presses C-d
    → Vim executes C-d natively (instant, correct behavior guaranteed)
    → WinScrolled fires
    → mini.animate captures: old topline=50, new topline=75
    → Restores topline to 50
    → Animates 25 lines of C-e steps over ~200ms
    → Cursor interpolates linearly from old to new position

  The key insight: mini.animate only uses C-e and C-y for animation. It doesn't care what triggered the scroll. C-d, C-f, mouse wheel, :123, search /pattern, gd -- all produce the same thing: a topline delta. The animation is always the same primitive: N repetitions of C-e or C-y.

  It also temporarily sets scrolloff=0 during animation to prevent the cursor from being pushed by scrolloff constraints during the micro-steps, then restores it at the end.

  #### The Tradeoffs

  ┌───────────────────┬──────────────────────────────────────────────────┬──────────────────────────────────────────────────┐
  │                   │          Keymap interception (smoothie)          │           Event-driven (mini.animate)            │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Scope             │ Only mapped keys                                 │ Any scroll source                                │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Correctness       │ Must reimplement scroll semantics                │ Vim handles semantics natively                   │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ scrolloff         │ Must handle per-command                          │ Disable during animation, restore after          │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Edge cases        │ Must handle folds, wraps, boundaries per command │ Vim already handled them before animation starts │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Animation quality │ Full easing/velocity control                     │ Substep-based (equal or custom timing)           │
  ├───────────────────┼──────────────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Bug surface       │ Large (the bug we fixed is a direct consequence) │ Small (just view interpolation)                  │
  └───────────────────┴──────────────────────────────────────────────────┴──────────────────────────────────────────────────┘
