local bars = { thick = '▎', thin = '│' }
local signs_thin = {
  add = { hl = 'GitSignsAddFaded', text = bars.thin },
  change = { hl = 'GitSignsChangeFaded', text = bars.thin },
  delete = { hl = 'GitSignsDeleteFaded', text = bars.thin },
  topdelete = { hl = 'GitSignsDeleteFaded', text = bars.thin },
  changedelete = { hl = 'GitSignsChangeDeleteFaded', text = bars.thin },
}

local signs_thick = {
  add = { hl = 'GreenSign', text = bars.thick, numhl = 'GitSignsAddNr' },
  change = { hl = 'BlueSign', text = bars.thick, numhl = 'GitSignsChangeNr' },
  delete = { hl = 'RedSign', text = bars.thick, numhl = 'GitSignsDeleteNr' },
  topdelete = { hl = 'RedSign', text = bars.thick, numhl = 'GitSignsDeleteNr' },
  changedelete = { hl = 'PurpleSign', text = bars.thick, numhl = 'GitSignsChangeDeleteNr' },
}

local defaultSettings = {
  signs = {
    add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = {
      hl = 'GitSignsChange',
      text = '│',
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
    delete = {
      hl = 'GitSignsDelete',
      text = '_',
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    topdelete = {
      hl = 'GitSignsDelete',
      text = '‾',
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    changedelete = {
      hl = 'GitSignsChange',
      text = '~',
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
}

local on_attach = function(bufnr)
  if vim.api.nvim_buf_get_name(bufnr):match('quicknotes/daily') then
    return false
  end

  -- git rev-parse --is-bare-repository
  local ok, gitsigns = pcall(vim.api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if ok == true then
    local check_bare_command =
      { 'git', "--git-dir='" .. gitsigns.gitdir .. "'", 'rev-parse', '--is-bare-repository' }
    local is_bare = string.gsub(vim.fn.system(vim.fn.join(check_bare_command, ' ')), '\n', '')
    gitsigns.is_bare = is_bare == 'true' and true or false
    vim.api.nvim_buf_set_var(bufnr, 'gitsigns_status_dict', gitsigns)
    -- vim.fn.setenv('GIT_WORK_TREE', gitsigns.root)
    -- vim.fn.setenv('GIT_DIR', gitsigns.gitdir)
  end

  local gs = package.loaded.gitsigns
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- map("n", "]h", gs.next_hunk, "Next Hunk")
  -- map("n", "[h", gs.prev_hunk, "Prev Hunk")
  -- map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  -- map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  -- map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  -- map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
  -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
  -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
  -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
  -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

  -- Navigation
  map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
  map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

  -- Actions
  map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  map('n', '<leader>hS', gs.stage_buffer)
  map('n', '<leader>hu', gs.undo_stage_hunk)
  map('n', '<leader>hR', gs.reset_buffer)
  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hb', function()
    gs.blame_line({ full = true })
  end)
  map('n', '<leader>tb', gs.toggle_current_line_blame)
  map('n', '<leader>hd', gs.diffthis)
  map('n', '<leader>hD', function()
    gs.diffthis('~')
  end)
  map('n', '<leader>td', gs.toggle_deleted)

  -- Text object
  map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

local on_detach = function()
  -- vim.fn.setenv('GIT_WORK_TREE', '')
  -- vim.fn.setenv('GIT_DIR', '')
end

local mySettings = {
  worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. '/.cfg',
    },
  },
  on_attach = on_attach,
  signs = signs_thin,
  current_line_blame_opts = { delay = 1000, virt_text_pos = 'eol' },
  attach_to_untracked = false,
  update_debounce = 200,
  -- watch_gitdir = { title = "gitsigns", interval = 1000 },
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
  -- diff_opts { internal = { title = "gitsigns" } },
}

require('gitsigns').setup(mySettings)
