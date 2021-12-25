local bars = { thick = "▎", thin = "│" }
local signs_config_1 = {
  add = { hl = "GitSignsAddFaded", text = bars.thin },
  change = { hl = "GitSignsChangeFaded", text = bars.thin },
  delete = { hl = "GitSignsDeleteFaded", text = bars.thin },
  topdelete = { hl = "GitSignsDeleteFaded", text = bars.thin },
  changedelete = { hl = "GitSignsChangeDeleteFaded", text = bars.thin },
}

local signs_config_2 = {
  add = { hl = "GreenSign", text = bars.thick, numhl = "GitSignsAddNr" },
  change = { hl = "BlueSign", text = bars.thick, numhl = "GitSignsChangeNr" },
  delete = { hl = "RedSign", text = bars.thick, numhl = "GitSignsDeleteNr" },
  topdelete = { hl = "RedSign", text = bars.thick, numhl = "GitSignsDeleteNr" },
  changedelete = { hl = "PurpleSign", text = bars.thick, numhl = "GitSignsChangeDeleteNr" },
}

require("gitsigns").setup {
  signs = signs_config_1,
  numhl = false,
  linehl = false,
  -- keymaps = {
  --   -- Default keymap options
  --   noremap = true,
  --   buffer = true,
  --   ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
  --   ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
  --   ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
  --   ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
  --   ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
  --   ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
  --   ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
  --   -- Text objects
  --   ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
  --   ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'
  -- },

  -- 21:03:08 [INFO] notify: use_internal_diff is now deprecated, please use diff_opts.internal {  title="gitsigns" }, file="start/cheovim/lua/logger.lua", line=110
  -- 21:03:08 [INFO] notify: watch_index is now deprecated, please use watch_gitdir {  title="gitsigns" }, file="start/cheovim/lua/logger.lua", line=110
  -- diff_opts { internal = { title = "gitsigns" } },
  -- watch_gitdir = { title = "gitsigns", interval = 1000 },
  current_line_blame = false,
  current_line_blame_opts = { delay = 1000, virt_text_pos = "eol" },
  sign_priority = 6,
  update_debounce = 200,
  status_formatter = nil, -- Use default
}

-- signs = {
--   add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
--   change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--   delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--   topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--   changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--
-- add          = {hl = 'GitSignsAdd'   , text = ' ', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
-- change       = {hl = 'GitSignsChange', text = '▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
-- delete       = {hl = 'GitSignsDelete', text = ' ', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
-- topdelete    = {hl = 'GitSignsDelete', text = ' ', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
-- changedelete = {hl = 'GitSignsChangeDelete', text = '▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
