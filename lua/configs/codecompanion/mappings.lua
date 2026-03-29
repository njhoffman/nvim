local adapters = require("configs.codecompanion.adapters")

local map = require("mapper").map

local maps_1 = function()
  map(
    { "n", "v" },
    "<leader>ck",
    "<cmd>CodeCompanionActions<cr>",
    { desc = "CodeCompanion actions" }
  )
  map(
    { "n", "v" },
    "<leader>a",
    "<cmd>CodeCompanionChat Toggle<cr>",
    { desc = "Toggle CodeCompanion chat" }
  )
  map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to CodeCompanion chat" })

  map("n", "<leader>cs", adapters.select_model, { desc = "Select Gemini Model" })
  -- Expand 'cc' into 'CodeCompanion' in the command line
  vim.cmd([[cab cc CodeCompanion]])
end
