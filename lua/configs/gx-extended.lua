-- package.json - gx when cursor is under an npm dependency, navigates to https://www.npmjs.com/package/[packageName]
-- plugins.lua - In packer.nvim's convention plugins.lua file, gx when cursor is under a plugin dependency, navigates to https://github.com/[user/org]/[repo]
-- *.tf - In a terraform file, gx when cursor is under a terraform resource definition navigates to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]
-- * - In any file, gx navigates to no-protocol-urls like google.com, docs.google.com, etc.
require("gx-extended").setup({
  extensions = {
    { -- match github repos in lazy.nvim plugin specs
      patterns = { "*/plugins/**/*.lua" },
      name = "neovim plugins",
      match_to_url = function(line_string)
        local line = string.match(line_string, "[\"|'].*/.*[\"|']")
        local repo = vim.split(line, ":")[1]:gsub("[\"|']", "")
        local url = "https://github.com/" .. repo
        return line and repo and url or nil
      end,
    },
  },
})
