local defaults = {
  log_level = vim.log.levels.INFO,
  debounce = 25,
  commands = {
    { command = "jq", filetype = "json" },
    { command = "yq", filetype = "json" },
  },
  ui = {
    autoclose = true,
    border = "single",
    width = function(columns)
      if columns < 120 then
        return math.floor(columns * 0.95)
      end

      return 120
    end,
    height = function(lines)
      if lines < 36 then
        return math.floor(lines * 0.95)
      end

      return 36
    end,
    keymap = {
      close = "<Esc>",
      focus_next = "<Tab>",
      focus_prev = "<S-Tab>",
      focus_left = nil,
      focus_right = nil,
      focus_up = nil,
      focus_down = nil,
    },
  },
}
require("jq").setup(defaults)
