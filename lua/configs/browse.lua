-- require('browse.devdocs').search_with_filetype()
-- require('browse.mdn').search()
require("browse").setup({
  -- search provider you want to use
  provider = "google", -- duckduckgo, bing
  -- either pass it here or just pass the table to the functions
  -- see below for more
  bookmarks = {},
  icons = {
    bookmark_alias = "->", -- if you have nerd fonts, you can set this to ""
    bookmarks_prompt = "", -- if you have nerd fonts, you can set this to "󰂺 "
    grouped_bookmarks = "->", -- if you have nerd fonts, you can set this to 
  },
})
-- local bookmarks = {
--   ["github"] = {
--       ["name"] = "search github from neovim",
--       ["code_search"] = "https://github.com/search?q=%s&type=code",
--       ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
--       ["issues_search"] = "https://github.com/search?q=%s&type=issues",
--       ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
--   },
-- }
-- local bookmarks = {
--   "https://github.com/search?q=%s&type=code",
--   "https://github.com/search?q=%s&type=repositories",
-- }
-- local bookmarks = {
--   "https://github.com/hoob3rt/lualine.nvim",
--   "https://github.com/neovim/neovim",
--   "https://neovim.discourse.group/",
--   "https://github.com/nvim-telescope/telescope.nvim",
--   "https://github.com/rockerBOO/awesome-neovim",
-- }

--   function command(name, rhs, opts)
--     opts = opts or {}
--     vim.api.nvim_create_user_command(name, rhs, opts)
--   end

--   command('InputSearch', function()
--     browse.input_search()
--   end, {})

--   -- this will open telescope using dropdown theme with all the available options
--   -- in which `browse.nvim` can be used
--   command('Browse', function()
--     browse.browse({ bookmarks = bookmarks })
--   end)

--   command('Bookmarks', function()
--     browse.open_bookmarks({ bookmarks = bookmarks })
--   end)

--   command('DevdocsSearch', function()
--     browse.devdocs.search()
--   end)

--   command('DevdocsFiletypeSearch', function()
--     browse.devdocs.search_with_filetype()
--   end)

--   command('MdnSearch', function()
--     browse.mdn.search()
--   end)
