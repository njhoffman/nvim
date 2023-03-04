local defaults = {
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = "DiffText",
    current = "DiffAdd",
  },
}

-- GitConflictChooseOurs — Select the current changes.
-- GitConflictChooseTheirs — Select the incoming changes.
-- GitConflictChooseBoth — Select both changes.
-- GitConflictChooseNone — Select none of the changes.
-- GitConflictNextConflict — Move to the next conflict.
-- GitConflictPrevConflict — Move to the previous conflict.
-- GitConflictListQf — Get all conflict to quickfix

vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    local bufnr = vim.fn.expand("<afile>")
    vim.notify("Conflict detected in " .. bufnr)
    vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { buffer = bufnr })
    vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { buffer = bufnr })
    vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { buffer = bufnr })
    vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { buffer = bufnr })
    vim.keymap.set("n", "[[", "<Plug>(git-conflict-prev-conflict)", { buffer = bufnr })
    vim.keymap.set("n", "[c", "<Plug>(git-conflict-prev-conflict)", { buffer = bufnr })
    vim.keymap.set("n", "]]", "<Plug>(git-conflict-next-conflict)", { buffer = bufnr })
    vim.keymap.set("n", "]c", "<Plug>(git-conflict-next-conflict)", { buffer = bufnr })
  end,
})
