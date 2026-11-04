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

-- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#graphql
-- require'lspconfig'.graphql.setup{}
