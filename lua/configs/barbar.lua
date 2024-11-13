require("barbar").setup({
  auto_hide = 1,
  -- insert_at_end = false,
  -- insert_at_start = false,
  -- hide = { inactive = true },
  highlight_alternate = true,
  -- highlights = {
  --   fill = {
  --     fg = { attribute = "fg", highlight = "TabLine" }, -- change to this
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  -- },
  icons = {
    -- diagnostics = {
    --   [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '' },
    -- },

    -- separator = { left = '▎' },
    -- right = { " " },

    separator = { left = "▎", right = "" },
    -- If true, add an additional separator at the end of the buffer list
    separator_at_end = true,

    preset = "default",
    pinned = {
      button = "",
      filename = true,
      separator = { right = " " },
    },
    alternate = { filetype = { custom_colors = true, enabled = true } },
  },
})

-- mini.sessions
--  vim.opt.sessionoptions:append 'globals'
--  require'mini.sessions'.setup {
--    hooks = {
--      pre = {
--        write = function() vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'}) end,
--      },
--    },
--  }
--

vim.opt.sessionoptions:append("globals")
vim.api.nvim_create_user_command("Mksession", function(attr)
  vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
  -- Neovim 0.8<=
  vim.cmd.mksession({ bang = attr.bang, args = attr.fargs })
end, { bang = true, complete = "file", nargs = "?" })
