local actions = require("commands.ui.actions")

local setup_commands = function()
  vim.api.nvim_create_user_command(
    "CloseMulti",
    actions.close_multi,
    { desc = "Close tabpage, window, or buffer in that order" }
  )

  vim.api.nvim_create_user_command(
    "CloseMultiNoPrompt",
    actions.close_multi_no_prompt,
    { desc = "Close tabpage, window, or buffer in that order" }
  )

  vim.api.nvim_create_user_command(
    "ClosePopups",
    actions.close_popups,
    { desc = "Format buffer using lsp" }
  )
end

-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('...',true,true,true))
-- TODO: c-s-d , c-s-f, c-s-h,l,j,k, c-s-|, c-s-+

local setup = function()
  setup_commands()
end

return { setup = setup, smart_win_split = actions.smart_win_split }
