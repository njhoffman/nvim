local cfg = {
  cmd = { "jq" }, -- gojq, jaq
  output_window = {
    split_direction = "right",
    width = nil,
    height = nil,
  },
  query_window = {
    split_direction = "bottom",
    width = nil,
    height = 0.3,
  },
  disable_default_keymap = false,
}
require("jq-playground").setup(cfg)

-- -- start the playground
-- vim.keymap.set("n", "<leader>jq", vim.cmd.JqPlayground)
--
-- -- when in the query window, run the jq query
-- vim.keymap.set("n", "R", "<Plug>(JqPlaygroundRunQuery)")
-- :JqPlayground sample.json
-- Some random tips that you may find useful while using this plugin.
--
-- If you have a saved jq program that you want to load into the filter window, then run:
--
-- :r path/to/some/query.jq
-- If you want to save the current query or output json, navigate to that buffer and run:
--
-- :w path/to/save/query.jq
-- " or:
-- :w path/to/save/output.json
-- Start the JQ editor from the command line without loading the input file:
--
-- $ nvim +'JqPlayground input.json'
-- $ # or put this in your bashrc:
-- $ jqplay() { nvim +"JqPlayground $1"; }
