local diff = require("mini.diff")
local cfg = {
  -- disableddd by default
  source = diff.gen_source.none(),
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = "",
    -- Reset hunks inside a visual/operator region
    reset = "",
    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = "",
    -- Go to hunk range in corresponding direction
    goto_first = "",
    goto_prev = "",
    goto_next = "",
    goto_last = "",
  },
  -- source = nil,
}
-- MiniDiffOverAdd
-- MiniDiffOverChange
-- MiniDiffOverContext
-- MiniDiffOverDelete
diff.setup(cfg)

-- "Change" hunks with equal number of buffer and reference lines have special treatment and show "word diff".
-- Reference line is shown next to its buffer counterpart and only changed parts of both lines are highlighted with MiniDiffOverChange.
-- The rest of reference line has MiniDiffOverContext highlighting.
--
-- This usually is the case when config.options.linematch is enabled.
-- MiniDiff.toggle_overlay()
-- vim.b.minidiff_summary is a table with the following fields:
--   source_name - name of the source.
-- n_ranges - number of hunk ranges (sequences of contiguous hunks).
-- add - number of added lines.
-- change - number of changed lines.
-- delete - number of deleted lines.
-- Examples:
-- vip followed by gh / gH applies/resets hunks inside current paragraph. Same can be achieved in operator form ghip / gHip, which has the advantage of being dot-repeatable.
-- gh_ / gH_ applies/resets current line (even if it is not a full hunk).
-- ghgh / gHgh applies/resets hunk range under cursor.
-- dgh deletes hunk range under cursor.
-- [H / [h / ]h / ]H navigate cursor to the first / previous / next / last hunk range of the current buffer.
