-- example .graphqlrc.json
--   { "schema": "https://rickandmortyapi.com/graphql",
--     "url": "https://rickandmortyapi.com/graphql",
--     "headers": { "Authorization": "Bearer abc" } }

-- -- create new collection, update .graphqlrc.json, run:
-- require('graphql').open()
-- require('graphql').close()
-- require('graphql').run()

require("graphql").setup({
  prefix_path = vim.fn.stdpath("data") .. "/graphql.nvim",
})

-- keys = {
--   { "<leader>gg", function() require("graphql").open() end, desc = "graphql - Open" },
--   { "<leader>gq", function() require("graphql").close() end },
--   { "<leader>gr", function() require("graphql").run() end }
-- },

-- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#graphql
-- require'lspconfig'.graphql.setup{}
