local opts = {
  scope = "line",
  modes = { "i", "ic", "ix", "R", "Rc", "Rx", "Rv", "Rvc", "Rvx" },
  blending = {
    threshold = 0.85,
    colorcode = "#000000",
    hlgroup = {
      "Normal",
      "background",
    },
  },
  warning = {
    alpha = 0.3,
    offset = 0,
    colorcode = "#FF0000",
    hlgroup = {
      "Error",
      "background",
    },
  },
  extra = {
    -- follow_tw = nil,
    follow_tw = "+1",
  },
}
require("deadcolumn").setup(opts)
