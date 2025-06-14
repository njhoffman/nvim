local adapters = require("configs.codecompanion.adapters")

local maps_1 = function()
  vim.keymap.set(
    { "n", "v" },
    "<leader>ck",
    "<cmd>CodeCompanionActions<cr>",
    { noremap = true, silent = true }
  )
  vim.keymap.set(
    { "n", "v" },
    "<leader>a",
    "<cmd>CodeCompanionChat Toggle<cr>",
    { noremap = true, silent = true }
  )
  vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>cs", adapters.select_model, { desc = "Select Gemini Model" })
  -- Expand 'cc' into 'CodeCompanion' in the command line
  vim.cmd([[cab cc CodeCompanion]])
end
