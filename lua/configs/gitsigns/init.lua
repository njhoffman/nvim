local bars = { thick = "▎", thin = "│" }

local signs_thin = function()
  vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GitSignsAddFaded" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GitSignsChangeFaded" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "GitSignsDeleteFaded" })
  vim.api.nvim_set_hl(0, "GitSignsTopDelete", { link = "GitSignsDeleteFaded" })
  vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { link = "GitSignsChangeDeleteFaded" })

  return {
    add = { text = bars.thin },
    change = { text = bars.thin },
    delete = { text = bars.thin },
    topdelete = { text = bars.thin },
    changedelete = { text = bars.thin },
  }
end

local signs_thick = {
  add = { hl = "GreenSign", text = bars.thick, numhl = "GitSignsAddNr" },
  change = { hl = "BlueSign", text = bars.thick, numhl = "GitSignsChangeNr" },
  delete = { hl = "RedSign", text = bars.thick, numhl = "GitSignsDeleteNr" },
  topdelete = { hl = "RedSign", text = bars.thick, numhl = "GitSignsDeleteNr" },
  changedelete = { hl = "PurpleSign", text = bars.thick, numhl = "GitSignsChangeDeleteNr" },
}

--       
local on_attach = function(bufnr)
  -- Don't attach to specific buffers whose name matches a pattern
  -- vim.dbglog("attach", bufnr)
  local ignore_pattern = "quicknotes/daily"
  if vim.api.nvim_buf_get_name(bufnr):match(ignore_pattern) then
    return false
  end

  local setup_mappings = require("configs.gitsigns.mappings")
  local setup_environment = require("configs.gitsigns.environment")

  setup_environment(bufnr)
  setup_mappings(bufnr)
  return true
end

-- :Gitsigns blame
-- :Gitsigns blame_line
-- :Gitsigns change_base nil true
-- :Gitsigns change_base ~
-- :Gitsigns diffthis HEAD~1
-- :Gitsigns preview_hunk_inline
-- :Gitsigns reset_buffer
-- :Gitsigns reset_hunk.
-- :Gitsigns setqflist/setloclist
-- :Gitsigns show <REVISION>
-- :Gitsigns stage_hunk.
-- :Gitsigns toggle_current_line_blame
-- :Gitsigns toggle_signs
-- :Gitsigns toggle_word_diff.

local mySettings = {
  worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. "/.cfg",
    },
  },
  on_attach = on_attach,
  sign_priority = 5,
  signs = signs_thin(),
  current_line_blame_opts = {
    ignore_whitespace = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
  },
  attach_to_untracked = true,
  update_debounce = 200,
  preview_config = {
    --           {relative='win', width=12, height=3, bufpos={100,10}})
    --       style = 'minimal',
    --       relative = 'cursor',
    row = 1,
    col = 1,
    border = "rounded",
  },
  debug_mode = false,
  -- dump_cache`, `debug_messages`, `clear_debug`.
  --
  -- _on_attach_pre = function(bufnr, callback)
  --   return callback({
  --     gitdir = vim.env.HOME .. "/.cfg",
  --     toplevel = vim.env.HOME,
  --   })
  -- end,

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

local get_git_info = function()
  return {
    head_buf = table.pack(pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_head")),
    head_g = table.pack(pcall(vim.api.nvim_get_var, "gitsigns_head")),
    status_buf = table.pack(pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")),
  }
end

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  callback = function(args)
    vim.schedule(function()
      local bufnr = args.data and args.data.buffer or args.buf or 0
      if vim.api.nvim_buf_is_valid(bufnr) == false then
        vim.dbglog("gitsigns invalid buffer: " .. bufnr)
        return
      end
      local gitenv = get_git_info()
      gitenv.status_buf = gitenv.status_buf[1] and gitenv.status_buf[2] or "nil"
      gitenv.head_buf = gitenv.head_buf[1] and gitenv.head_buf[2] or "nil"
      gitenv.head_g = gitenv.head_g[1] and gitenv.head_g[2] or "nil"
    end)
    -- vim.dbglog(not args.data and "**" or "" .. "Gitsigns update: ", bufnr, "\n", gitenv)
  end,
})

require("gitsigns").setup(mySettings)

-- local gs = package.loaded.gitsigns

local orig_detach = vim.schedule_wrap(require("gitsigns.attach").detach)
require("gitsigns.attach").detach = function(bufnr, keep_signs)
  vim.api.nvim_buf_set_var(bufnr, "gitsigns_status_dict", nil)
  -- vim.fn.setenv("GIT_WORK_TREE", "")
  -- vim.fn.setenv("GIT_DIR", "")
  -- vim.dbglog("detach", bufnr, keep_signs)
  orig_detach(bufnr, keep_signs)
end
