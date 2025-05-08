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

-- require("jq").run({
--   --- you can pass additional options to configure the current instance
--   -- if you want to toggle from the memory
--   toggle = true,
--   -- commands for the instance else it will use the default
--   -- the default command would be the first one in the table
--   commands = {
--     {
--       -- command to be run
--       command = "jq",
--       -- filetype of the output
--       filetype = "json",
--       -- hidden arguments that will not be shown in the ui
--       arguments = "-r",
--     },
--   },
--   -- arguments to start with in the ui
--   arguments = "",
--   -- query to start with, if not provided it will use the default
--   query = ".",
-- })
-- require("jq").run({
--   filename = "test.json",
--   lines = { "lines", "i", "obtained", "from", "somewhere" }
-- })
