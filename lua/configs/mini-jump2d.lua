require("mini.jump2d").setup({
  allowed_lines = { cursor_before = true },
  allowed_windows = { not_current = true },
  mappings = {
    start_jumping = "<F7>",
  },
  view = {
    -- Whether to dim lines with at least one jump spot
    dim = true,

    -- How many steps ahead to show. Set to big number to show all steps.
    n_steps_ahead = 10,
  },
})
