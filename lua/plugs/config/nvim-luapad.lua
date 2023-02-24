require("luapad").setup {
  count_limit = 150000,
  error_indicator = false,
  eval_on_move = true,
  error_highlight = "WarningMsg",
  on_init = function() print "Hello from Luapad!" end,
  context = { the_answer = 42, shout = function(str) return (string.upper(str) .. "!") end },
}
-- https://www.2n.pl/blog/how-to-write-neovim-plugins-in-lua
-- https://www.2n.pl/blog/how-to-make-ui-for-neovim-plugins-in-lua
-- Name default value Description
-- count_limit  200000  Luapad uses count hook method to prevent infinite loops occurring during code execution. Setting count_limit too high will make Luapad laggy, setting it too low, may cause premature code termination.
-- error_indicator  true  Show virtual text with error message (except syntax or timeout errors)
-- preview  true  Show floating output window on cursor hold. It's a good idea to set low update time. For example: let &updatetime = 300 You can jump to it by ^w w
-- eval_on_change true  Evaluate buffer content when it changes
-- eval_on_move false Evaluate all luapad buffers when the cursor moves
-- print_highlight  'Comment' Highlight group used to coloring luapad print output
-- error_highlight  'ErrorMsg'  Highlight group used to coloring luapad error indicator
-- on_init  function  Callback function called after creating new luapad instance
-- context  {}  The default context tbl in which luapad buffer is evaluated. Its properties will be available in buffer as "global" variables.
